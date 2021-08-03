#' Get Entity Classification
#'
#' Retrieve entity classification from `http://classyfire.wishartlab.com/entities/'.
#' The optional local cache function enables classification requests with less waiting time.
#' Furthermore, there will be fewer traffic on the classyFire servers. For best high efficiency
#' there is an option for creating a SQLight database to cache results.
#'
#' @param inchi_key a character string of a valid InChIKey
#' @param conn a DBIConnection object, as produced by dbConnect
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
#' get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-B')
#' }
#' @export
#' @import RSQLite

get_classification <- function(inchi_key, conn=NULL)
{
  cache_hits <- 0
  if (! is.null(conn))  {
    qry <-
      RSQLite::dbSendQuery(conn,
                           "SELECT InChiKey,Classification FROM classyfire WHERE InChiKey=?")
    RSQLite::dbBind(qry, inchi_key)
    key <- RSQLite::dbFetch(qry)
    cache_hits <-RSQLite::dbGetRowCount(qry)
    RSQLite::dbClearResult(qry)
  }

  if (cache_hits==1) {
    object <- unserialize(charToRaw(key$Classification))
    message(crayon::green(clisymbols::symbol$tick, 'cached: ', inchi_key))
    return(object)
  } else {
    entity_url <- 'http://classyfire.wishartlab.com/entities/'

    entity_query <- paste0(entity_url, inchi_key, '.json')

    response <- httr::RETRY(
      verb = "GET",
      url = entity_query,
      times = 10,
      terminate_on = c(404),
      quiet = T
    )

    if (response$status_code == 429) {
      stop('Request rate limit exceeded!')
    }

    if (response$status_code == 404) {
      message(crayon::red(clisymbols::symbol$cross, inchi_key))
    }

    if (response$status_code == 200) {
      text_content <- httr::content(response, 'text')

      if (text_content == '{}') {
        message(crayon::red(clisymbols::symbol$cross, inchi_key))
        return(invisible(NULL))
      } else{
        message(crayon::green(clisymbols::symbol$tick, inchi_key))
      }

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

      if (length(json_res$direct_parent) > 0) {
        object@direct_parent <- json_res$direct_parent
      }

      if (length(json_res$alternative_parents) > 0) {
        object@alternative_parents <-
          tibble::tibble(
            name = json_res$alternative_parents$name,
            description = json_res$alternative_parents$description,
            chemont_id = json_res$alternative_parents$chemont_id,
            url = json_res$alternative_parents$url
          )
      } else{
        object@alternative_parents <- tibble::tibble()
      }

      if (length(json_res$predicted_chebi_terms) > 0) {
        object@predicted_chebi <- json_res$predicted_chebi_terms
      } else{
        object@predicted_chebi <- vector(mode = 'character')
      }


      if (length(json_res$external_descriptors) > 0) {
        object@external_descriptors <-
          parse_external_desc(json_res)
      } else{
        object@external_descriptors <- tibble::tibble()
      }

      if (length(json_res$description) > 0) {
        object@description <- json_res$description
      }


      if (! is.null(conn))  {
        qry2 <-
          RSQLite::dbSendQuery(
            conn,
            "INSERT INTO classyfire (InChiKey,InChi,Classification) VALUES(?,?,?)"
          )
        RSQLite::dbBind(qry2, list(inchi_key, "NULL", rawToChar(
          serialize(object, connection = NULL, ascii = TRUE)
        )))
        RSQLite::dbClearResult(qry2)
      }
      return(object)
    }
  }
}


#' Open Cache
#'
#' Creates a SQLight database for the local caching. This database includes already
#' queried Inchikeys and the serialized classification object.
#'
#' @param dbname The path to the database file. SQLite keeps each database instance
#' in one single file. The name of the database is the file name, thus database names
#' should be legal file names in the running platform. There are two exceptions:
#' "" will create a temporary on-disk database. The file will be deleted when the connection is closed.
#' ":memory:" or "file::memory:" will create a temporary in-memory database.

#' @return `conn` a DBIConnection object, as produced by dbConnect
#'
#' @export
#' @import RSQLite

open_cache <- function(dbname=":memory:"){
  conn <- RSQLite::dbConnect(RSQLite::SQLite(), dbname)

  RSQLite::dbExecute(conn,"CREATE TABLE IF NOT EXISTS 'classyfire' (
          InChikey CHAR(27) PRIMARY KEY,
          InChi TEXT,
          Classification TEXT)")
  return(conn)
}
