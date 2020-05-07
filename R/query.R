#' Submits a ClassyFire query in a JSON format.
#'
#' @param label a string the label of the query.
#' @param input a named list or vector of SMILES strings.
#' @param type a string the type of the query.
#'
#' @return A list of tibbles named by input name.
#' @export
#'
#' @examples
#' \dontrun{
#' input <- c(MOL1 = 'CCCOCC', MOL2 = 'COCC=CCC')
#' submit_query(label = 'query_test', input = input, type = 'STRUCTURE')
#' }
submit_query <- function(label, input, type = 'STRUCTURE'){
  base_url <- 'http://classyfire.wishartlab.com/queries'
  query_input <- paste(names(input), input, sep = '\t', collapse = '\n')
  q <- rjson::toJSON(list(
      label = label,
      query_input = query_input,
      query_type = 'STRUCTURE'
    ))

  resp <- httr::POST(
    url = base_url,
    body = q,
    httr::content_type_json(),
    httr::accept_json(),
    httr::timeout(getOption('timeout'))
  )

  post_cont <- httr::content(resp)

  url <- paste0(base_url, '/', post_cont$id, ".json")

  resp <- httr::RETRY("GET",
                      url = url,
                      encode = "json",
                      times = 100)

  if (resp$status_code == 200) {
    json_res <- get_query(query_id = post_cont$id, format = 'json')
    classification <-
      purrr::map(json_res$entities, parse_json_output)
    out <- setNames(classification, sapply(json_res$entities, function(x){x$identifier}))
  } else {
    out <- NA
  }
  return(out)
}


#'Retrieves the classification results for a given query.
#'
#' @param query_id query_id a numeric value for the ID of the query.
#' @param format a string of the format of the query (either JSON, CSV, or SDF)
#'
#' @return the parsed text output displaying the classification results for
#    the query's entities in the specified format.
#' @export
#'
get_query <- function(query_id, format = c("json", "sdf", "csv")){
  format <- match.arg(format, choices =  c("json", "sdf", "csv"), several.ok = F)
  base_url <- 'http://classyfire.wishartlab.com/queries/'
  url <- paste0(base_url, query_id, ".", format)
  resp <- httr::GET(url = url, httr::accept_json())
  if (resp$status_code == 200) {
    cont <- httr::content(resp, 'parsed')
  } else {
    cont <- NA
  }
  return(cont)
}
