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

  list_output <- list_output[!sapply(list_output, is.null)]

  if (length(list_output) > 0) {
    class_tibble <- purrr::map(1:length(list_output),  ~ {
      l <- list_output[[.]]
      tibble::tibble(
        Level = names(list_output)[.],
        Classification = l$name,
        CHEMONT = l$chemont_id
      )
    }) %>%
      dplyr::bind_rows() %>%
      dplyr::filter(!duplicated(Classification))

    nIntermediate <- class_tibble %>%
      dplyr::filter(Level == 'intermediate_nodes') %>%
      nrow()

    class_tibble$Level[class_tibble$Level == 'intermediate_nodes'] <-
      purrr::map_chr(5:(5 + (nIntermediate - 1)),  ~ {
        stringr::str_c('level ', .)
      })
    class_tibble$Level[class_tibble$Level == 'direct_parent'] <-
      stringr::str_c('level ', 5 + nIntermediate)

  } else {
    class_tibble <- NULL
  }
  return(class_tibble)
}




#' Parse External Descriptors
#'
#' Parse the list output of returned External Descriptors
#'
#' @param json_res the list output from `jsonlite::fromJSON(x)`
#' @return a `tibble` containing the following;
#' * __source__ External source name
#' * __source_id__ External source ID
#' * __annotations__ External source annotation
#' @keywords internal

parse_external_desc <- function(x)
{
  external_ann <- list()
  for (i in seq_along(x$external_descriptors$annotations)) {
    external_ann[[i]] <-
      paste(x$external_descriptors$annotations[[i]], collapse = ' // ')
  }

  external_desc <-
    tibble::tibble(
      source = x$external_descriptors$source,
      source_id = x$external_descriptors$source_id,
      annotations = unlist(external_ann)
    )

  return(external_desc)

}
