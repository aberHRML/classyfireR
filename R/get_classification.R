#' Get Entity Classification
#'
#' Retrieve entity classification from `http://classyfire.wishartlab.com/entities/'
#'
#' @param inchi_key a character string of a valid InChIKey
#' @return a `ClassyFire` S4 object.
#' @seealso ClassyFire-class
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
#'get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-B')
#' }
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


    object <- methods::new('ClassyFire')


    object@meta <-
      list(
        inchikey = json_res$inchikey,
        smiles = json_res$smiles,
        version = json_res$classification_version
      )

    object@classification <- classification

    object@direct_parent <- json_res$direct_parent

    object@alternative_parents <-
      tibble::tibble(
        name = json_res$alternative_parents$name,
        description = json_res$alternative_parents$description,
        chemont_id = json_res$alternative_parents$chemont_id,
        url = json_res$alternative_parents$url
      )

    object@predicted_chebi <- json_res$predicted_chebi_terms

    object@external_descriptors <- parse_external_desc(json_res)

    object@description <- json_res$description


    return(object)
  }

}
