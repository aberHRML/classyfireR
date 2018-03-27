#' Entity Classification
#'
#' Retrive entity classification from `http://classyfire.wishartlab.com/entities/'
#'
#' @param inchi_key a character string of a valid InChIKey
#' @return a `tibble` containing the following;
#'       - __Level__ Classification level (kingdom, superclass, class and subclass)
#'       - __Classification__ The compound classification
#'       - __CHEMONT__ Chemical Ontology Identification code
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

    classification <- parse_json_output(json_res)


    return(classification)
  }
}
