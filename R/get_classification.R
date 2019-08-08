#' Get Entity Classification
#'
#' Retrieve entity classification from `http://classyfire.wishartlab.com/entities/'
#'
#'
#' @param inchi_key a character string of a valid InChIKey
#' @return a `tibble` containing the following;
#' * __Level__ Classification level (kingdom, superclass, class and subclass)
#' * __Classification__ The compound classification
#' * __CHEMONT__ Chemical Ontology Identification code
#'
#' @examples
#' \dontrun{
#'
#' # Valid InChI key where all four classification levels are available
#' get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')
#'
#' # Valid InChI key where only three classification levels are available
#' get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')
#'
#' # Invalid InChI key
#' get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-B')
#'
#'
#' # Using `dplyr` a vector of InChI Keys can be submitted and easily parsed
#'   library(dplyr)
#'   library(purrr)
#'   library(tidyr)
#'
#'  keys <- c(
#' 'BRMWTNUJHUMWMS-LURJTMIESA-N',
#' 'XFNJVJPLKCPIBV-UHFFFAOYSA-N',
#' 'TYEYBOSBBBHJIV-UHFFFAOYSA-N',
#' 'AFENDNXGAFYKQO-UHFFFAOYSA-N')
#'
#'  classification_list <- map(keys, get_classification)
#'
#'  classification_list <- map(classification_list, ~{select(.,-CHEMONT)})
#'
#'  spread_tibble <- purrr:::map(classification_list, ~{
#'                   spread(., Level, Classification)
#'                   }) %>% bind_rows() %>% data.frame()
#'
#'  rownames(spread_tibble) <- keys
#'
#'  classification_tibble <-  tibble(
#'      InChIKey = rownames(spread_tibble),
#'      Kingdom = spread_tibble$kingdom,
#'      SuperClass = spread_tibble$superclass,
#'      Class = spread_tibble$class,
#'      SubClass = spread_tibble$subclass,
#'      Level5 = spread_tibble$level.5,
#'      Level6 = spread_tibble$level.6,
#'      Level7 = spread_tibble$level.7
#'     )
#'
#'  print(classification_tibble)
#'}
#'
#'
#' @export
get_classification <- function(inchi_key)
{
  entity_url <- 'http://classyfire.wishartlab.com/entities/'

  entity_query <- paste0(entity_url, inchi_key, '.json')

  response <- httr::GET(entity_query)

  if (response$status_code == 429) {
    stop('Request rate limit exceeded!')
  }

  if (response$status_code == 404) {
    message(crayon::red(clisymbols::symbol$cross, inchi_key))
  }

  if (response$status_code == 200) {
    message(crayon::green(clisymbols::symbol$tick, inchi_key))
    text_content <- httr::content(response, 'text')

    json_res <- jsonlite::fromJSON(text_content)

    classification <- parse_json_output(json_res)
    return(classification)
  }

}
