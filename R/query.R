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
submit_query <- function(label, input, type = 'STRUCTURE') {
  base_url <- .classyfire_query_base_url()
  query_input <-
    paste(names(input), input, sep = '\t', collapse = '\n')
  q <- rjson::toJSON(list(
    label = label,
    query_input = query_input,
    query_type = type
  ))

  resp <- .cf_post(
    url = base_url,
    body = q,
    httr::content_type_json(),
    httr::accept_json(),
    httr::timeout(getOption('timeout'))
  )

  .cf_expect_status(
    response = resp,
    ok = c(200, 201),
    context = "ClassyFire query submission",
    url = base_url
  )

  post_cont <- .cf_content(resp)

  url <- paste0(base_url, '/', post_cont$id, ".json")

  resp <- .cf_retry("GET",
                    url = url,
                    encode = "json",
                    times = 100)

  .cf_expect_status(
    response = resp,
    ok = 200,
    context = sprintf("ClassyFire query %s polling", post_cont$id),
    url = url
  )

  json_res <- get_query(query_id = post_cont$id, format = 'json')

  json_parse <- json_res %>%
    tidyjson::enter_object(entities) %>%
    tidyjson::gather_array() %>%
    tidyjson::spread_all()

  if(nrow(json_parse) == 0){
    return(message(crayon::red(cli::symbol$cross, 'No Successful Classifications')))
  }

  json_tib <- json_parse %>%
    dplyr::as_tibble() %>%
    dplyr::group_by(inchikey)

  json_list <- json_parse$..JSON

  object <- methods::new('Query')

  object@meta <-
    json_tib %>% dplyr::select(identifier, inchikey, smiles, classification_version)


  Classification <- json_tib %>%
    dplyr::select(inchikey, dplyr::ends_with(".name")) %>%
    tidyr::pivot_longer(-inchikey, values_to = "Classification")

  Classification$Level <- sub("\\..*$", "", Classification$name)

  Classification <- Classification %>%
    dplyr::select(-name) %>%
    dplyr::ungroup()

  Classification <- dplyr::left_join(
    object@meta,
    Classification,
    by = 'inchikey'
  ) %>%
    dplyr::select(-smiles,-classification_version)

  object@classification <- Classification


  CHEMONT <- json_tib %>%
    dplyr::select(inchikey, dplyr::ends_with(".chemont_id")) %>%
    tidyr::pivot_longer(-inchikey, values_to = "CHEMONT")

  CHEMONT$Level <- sub("\\..*$", "", CHEMONT$name)
  CHEMONT <- dplyr::select(CHEMONT, -name)

  DirectParents <- json_tib %>%
    dplyr::select(inchikey, dplyr::starts_with("direct_parent.")) %>%
    dplyr::rename(
      name = direct_parent.name,
      description = direct_parent.description,
      chemont_id = direct_parent.chemont_id,
      url = direct_parent.url
    ) %>% dplyr::ungroup()

  object@direct_parent <- dplyr::left_join(
    object@meta,
    DirectParents,
    by = 'inchikey'
  ) %>%
    dplyr::select(-smiles, -classification_version)


  AltParents <- purrr::map(json_list, ~ {
    .$alternative_parents
  })

  AltParents_List <- list()
  for (i in seq_along(AltParents)) {
    AltParents_List[[i]] <-
      purrr::map(AltParents[[i]], dplyr::as_tibble) %>% dplyr::bind_rows() %>%
      tibble::add_column(identifier = json_tib$identifier[i], .before = 'name')
  }

  object@alternative_parents <-
    AltParents_List %>% dplyr::bind_rows()


  PredChebi <- purrr::map(json_list, ~ {
    as.character(.$predicted_chebi_terms)
  })

  names(PredChebi) <- object@meta$identifier

  object@predicted_chebi <- PredChebi


  Desc <- purrr::map(json_list, ~ {
    .$description
  })

  names(Desc) <- object@meta$identifier

  object@description <- Desc


  if(nrow(object@meta) == length(input)){
    return(object)
  }else{
    unclassified <- input[which(!names(input) %in% object@meta$identifier)]
    object@unclassified <- unclassified
  }

  return(object)

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
get_query <- function(query_id, format = c("json", "sdf", "csv")) {
  format <-
    match.arg(format,
              choices =  c("json", "sdf", "csv"),
              several.ok = F)
  base_url <- paste0(.classyfire_query_base_url(), "/")
  url <- paste0(base_url, query_id, ".", format)
  resp <- .cf_get(url = url, httr::accept_json())

  .cf_expect_status(
    response = resp,
    ok = 200,
    context = sprintf("ClassyFire query %s retrieval", query_id),
    url = url
  )

  .cf_content(resp, 'text')
}
