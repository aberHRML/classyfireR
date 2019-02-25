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
#' @importFrom dplyr bind_rows filter
#' @importFrom purrr map map_chr
#' @importFrom stringr str_c
#' @importFrom tibble tibble
#' @importFrom magrittr %>%

parse_json_output <- function(json_res)
{
  list_output <-
    list(
      kingdom = json_res[['kingdom']],
      superclass = json_res[['superclass']],
      class = json_res[['class']],
      subclass = json_res[['subclass']],
      intermediate_nodes = json_res[['intermediate_nodes']],
      direct_parent = json_res[['direct_parent']]
    )

  if (length(list_output$intermediate_nodes) == 0) {
    list_output$intermediate_nodes <- NULL
  }

  list_output <- list_output[!sapply(list_output,is.null)]

  class_tibble <- map(1:length(list_output),~{
    l <- list_output[[.]]
    tibble(
      Level = names(list_output)[.],
      Classification = l$name,
      CHEMONT = l$chemont_id
    )
  }) %>%
    bind_rows() %>%
    filter(!duplicated(Classification))

  nIntermediate <- class_tibble %>%
    filter(Level == 'intermediate_nodes') %>%
    nrow()

  class_tibble$Level[class_tibble$Level == 'intermediate_nodes'] <- map_chr(5:(5 + (nIntermediate - 1)),~{str_c('level ',.)})
  class_tibble$Level[class_tibble$Level == 'direct_parent'] <- str_c('level ',5 + nIntermediate)

  return(class_tibble)
}
