#' Submit InChI Code for Classification
#'
#' Submit and new entity for classification using the ClassyFire webserver
#'
#' @param query a charatcer string of `InChI Code` or `SMILE`
#' @param label a character string of the query name
#' @param type the label type (`Default = STRUCTURE`)
#' @return a `tibble` containing the following;
#'       - __Level__ Classification level (kingdom, superclass, class and subclass)
#'       - __Classification__ The compound classification
#'       - __CHEMONT__ Chemical Ontology Identification code
#'
#' @export
#' @importFrom magrittr "%>%"

submit_classification <- function(query, label, type = 'STRUCTURE')
  {
  params <- list(label = label,
                 query_input = query,
                 query_type = type)

  submit <- httr::POST(
    "http://classyfire.wishartlab.com/queries",
    body = params,
    encode = "json",
    httr::accept_json(),
    httr::add_headers("Content-Type" = "application/json")
  )

  query_id <-
    jsonlite::fromJSON(httr::content(submit, 'text')) %>% unlist() %>% as.list()

  get_status_code(as.numeric(query_id$id[1]))

  retrieve <-
    paste0('http://classyfire.wishartlab.com/queries/',
           query_id$id,
           '.json')

  response <- httr::GET(retrieve)

  text_content <- httr::content(response, 'text')

  json_res <- jsonlite::fromJSON(text_content)

  classification <- parse_json_output(json_res$entities)

  return(classification)

}
