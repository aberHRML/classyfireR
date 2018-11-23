#' Submit InChI Code for Classification
#'
#' Submit and new entity for classification using the ClassyFire webserver
#'
#' @param query a character string of `InChI Code` or `SMILE`
#' @param label a character string of the query name
#' @param type the label type (`Default = STRUCTURE`)
#' @return if the classification has completed;  a `tibble` containing the following;
#' * __Level__ Classification level (kingdom, superclass, class and subclass)
#' * __Classification__ The compound classification
#' * __CHEMONT__ Chemical Ontology Identification code
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


  if (get_status_code(as.numeric(query_id$id))$status != 'Done') {
    message(crayon::yellow('... classification still in progress', '\n'))
    message(
      crayon::yellow(
        '... use `retrieve_classification` once submission is out of queue'
      )
    )
    return(get_status_code(as.numeric(query_id$id)))

  } else{
    classification <- retrieve_classification(query_id$id)
    return(classification)
  }
}
