#' Get Status Code
#'
#' Retrieve the status code of a new submission for entity classification
#'
#' @param query_id a numeric value for the query id
#' @return a list of `query_id` and classification status; either `In progress` or `Done`
#'
#' @export
#' @examples
#' get_status_code(2813259)

get_status_code <- function(query_id)
{
  if (!is.numeric(query_id)) {
    stop(deparse(substitute(query_id)), ' must be a numeric value')
  }

  status <-
    httr::GET(
      paste0(
        "http://classyfire.wishartlab.com/queries/",
        query = query_id,
        "/status.json"
      )
    ) %>%
    httr::content(., 'text')

  return(list(query_id = query_id, status = status))

}
