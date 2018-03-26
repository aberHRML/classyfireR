#' Entity Classification
#'
#' Retrive entity classification from `http://classyfire.wishartlab.com/entities/'
#'
#' @param inchi_key a character string of a valid InChIKey
#' @return a list of two `tibbles`
#'   - __ClassyFire__ a `tibble` containing the following;
#'       - __Level__ Classification level (kingdom, superclass, class and subclass)
#'       - __Classification__ The compound classification
#'       - __CHEMONT__ Chemical Ontology Identification code
#'   - __Meta__ a `tibble` containing the following;
#'       - __Query__ the submitted InChI key
#'       - __Version__ Version of classyFire
#'       - __Date__ Date classification retrieved
#'
#' @examples
#' entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')
#'
#' entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')
#'
#' @export
entity_classification <- function(inchi_key)
{
  entity_url <- 'http://classyfire.wishartlab.com/entities/'

  entity_query <- paste0(entity_url, inchi_key, '.json')

  response <- httr::GET(entity_query)

  if (response$status_code == 404) {
    message(crayon::red(
      clisymbols::symbol$cross,
      'no exisiting classification available'
    ))
  }

  if (response$status_code == 200) {
    message(crayon::green(clisymbols::symbol$tick, 'classification retrieved'))
    text_content <- httr::content(response, 'text')

    json_res <- jsonlite::fromJSON(text_content)


    list_output <-
      list(
        kingdom = json_res[['kingdom']],
        superclass = json_res[['superclass']],
        class = json_res[['class']],
        subclass = json_res[['subclass']]
      )

    len <- purrr::map(list_output, length) %>% unlist()

    class_tibble <-
      tibble::tibble(
        Level = names(len),
        Classification = 'NA',
        CHEMONT = 'NA'
      )

    for (i in seq_along(len)) {
      if (len[[i]] == 4) {
        class_tibble[i, 'Classification'] <- list_output[[i]]$name
        class_tibble[i, 'CHEMONT'] <- list_output[[i]]$chemont_id
      } else{
        class_tibble[i, 'Classification'] <- NA
        class_tibble[i, 'CHEMONT'] <- NA
      }
    }


    entity_meta <-
      tibble::tibble(
        Query = json_res$inchikey,
        Version = json_res$classification_version,
        Date = Sys.Date()
      )

    return(list(ClassyFire = class_tibble, Meta = entity_meta))
  }
}
