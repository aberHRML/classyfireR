#' Parse JSON output
#'
#' Parse the JSON output from the `GET` or `POST` request
#'
#' @param json_res the list output from `jsonlite::fromJSON(x)`
#' @return a `tibble` containing the following;
#' * __Level__ Classification level (kingdom, superclass, class and subclass)
#' * __Classification__ The compound classification
#' * __CHEMONT__ Chemical Ontology Identification code
#' @keywords internal

parse_json_output <- function(json_res)
{
  list_output <-
    list(
      kingdom = json_res[['kingdom']],
      superclass = json_res[['superclass']],
      class = json_res[['class']],
      subclass = json_res[['subclass']]
    )

  len <- lapply(list_output, length) %>% unlist()

  class_tibble <-
    tibble::tibble(Level = names(len),
                   Classification = 'NA',
                   CHEMONT = 'NA')

  for (i in seq_along(len)) {
    if (len[[i]] == 4) {
      class_tibble[i, 'Classification'] <- list_output[[i]]$name
      class_tibble[i, 'CHEMONT'] <- list_output[[i]]$chemont_id
    } else{
      class_tibble[i, 'Classification'] <- NA
      class_tibble[i, 'CHEMONT'] <- NA
    }
  }


  return(class_tibble)

}
