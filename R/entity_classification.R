#' Entity Classification
#'
#'
#'
#' @param INCHI_KEY a character string of a valid InChIKey
#' @return a list of two `tibbles`
#'   - __ClassyFire__ a `tibble` containing the following;
#'       - __Level__
#'       - __Classification__
#'       - __CHEMONT__
#'   - __Meta__ a `tibble` containing the following;
#'       - __Query__
#'       - __Version__
#'       - __Date__
#'
#' @examples
#' entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')
#'
#' @export

entity_classification <- function(INCHI_KEY)
{
  entity_url <- 'http://classyfire.wishartlab.com/entities/'

  entity_query <- paste0(entity_url, INCHI_KEY, '.json')

  response <- httr::GET(entity_query)

  if (response$status_code == 404) {
    message('No exisiting classification found', '/n')
    message('Use `classyFire::classify` to create classification')

  } else{
    text_content <- httr::content(response, 'text')

    json_res <- jsonlite::fromJSON(text_content)

    entity_class <- list(
      Kingdom = json_res$kingdom$name,
      Superlcas = json_res$superclass$name,
      Class = json_res$class$name,
      Subclass = json_res$subclass$name
    )

    entity_ontid <- list(
      Kingdom = json_res$kingdom$chemont_id,
      Superlcas = json_res$superclass$chemont_id,
      Class = json_res$class$chemont_id,
      Subclass = json_res$subclass$chemont_id
    )

    entity_res <-
      tibble::tibble(Level = names(entity_class),Classification = unlist(entity_class),
                 CHEMONT = unlist(entity_ontid))
    entity_meta <-
      tibble::tibble(
        Query = json_res$inchikey,
        Version = json_res$classification_version,
        Date = Sys.Date()
      )

    return(list(ClassyFire = entity_res, Meta = entity_meta))
  }
}
