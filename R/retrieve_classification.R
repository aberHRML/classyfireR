#' Retrieve classification results
#'
#' Retrieve classification results from a new submission
#'
#' @param query_id a numeric value for the query id
#' @return a `tibble` containing the following;
#' * __Level__ Classification level (kingdom, superclass, class and subclass)
#' * __Classification__ The compound classification
#' * __CHEMONT__ Chemical Ontology Identification code
#'
#' @export
#' @examples
#'
#' retrieve_classification(2813259)

retrieve_classification <- function(query_id)
{
  retrieve <-
    paste0('http://classyfire.wishartlab.com/queries/',
           query_id,
           '.json')

  response <- httr::GET(retrieve)

  text_content <- httr::content(response, 'text')

  json_res <- jsonlite::fromJSON(text_content)

  classification <- parse_json_output(json_res$entities)

  return(classification)

}
