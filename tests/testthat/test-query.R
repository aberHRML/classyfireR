query_fixture_json <- function() {
  jsonlite::toJSON(
    list(
      entities = list(
        list(
          identifier = "mol1",
          inchikey = "KEY-1",
          smiles = "CCO",
          classification_version = "1.0",
          kingdom = list(
            name = "Organic compounds",
            chemont_id = "CHEMONTID:0000000"
          ),
          direct_parent = list(
            name = "Primary alcohols",
            description = "Alcohols with a primary carbon center",
            chemont_id = "CHEMONTID:0000002",
            url = "https://example.org/direct-parent"
          ),
          alternative_parents = list(
            list(
              name = "Alternative parent",
              description = "Alternative description",
              chemont_id = "CHEMONTID:0000003",
              url = "https://example.org/alternative-parent"
            )
          ),
          predicted_chebi_terms = c("CHEBI:15743"),
          description = "Example compound"
        )
      )
    ),
    auto_unbox = TRUE
  )
}

test_that("get_query returns text for successful requests", {
  testthat::local_mocked_bindings(
    .cf_get = function(...) list(status_code = 200),
    .cf_content = function(...) "query-body",
    .env = asNamespace("classyfireR")
  )

  expect_equal(classyfireR::get_query(123, format = "json"), "query-body")
})

test_that("get_query returns NA for non-200 responses", {
  testthat::local_mocked_bindings(
    .cf_get = function(...) list(status_code = 500),
    .env = asNamespace("classyfireR")
  )

  expect_true(is.na(classyfireR::get_query(123, format = "csv")))
})

test_that("submit_query uses the requested type and returns a Query object", {
  posted_body <- NULL

  testthat::local_mocked_bindings(
    .cf_post = function(body, ...) {
      posted_body <<- body
      structure(list(status_code = 200), class = "mock_post")
    },
    .cf_content = function(resp, ...) {
      if (inherits(resp, "mock_post")) {
        return(list(id = 123))
      }
      stop("Unexpected response object")
    },
    .cf_retry = function(...) list(status_code = 200),
    get_query = function(...) query_fixture_json(),
    .env = asNamespace("classyfireR")
  )

  result <- classyfireR::submit_query(
    label = "query_test",
    input = c(mol1 = "CCO", mol2 = "CCC"),
    type = "IUPAC_NAME"
  )

  expect_equal(jsonlite::fromJSON(posted_body)$query_type, "IUPAC_NAME")
  expect_s4_class(result, "Query")
  expect_equal(classyfireR::meta(result)$identifier, "mol1")
  expect_equal(classyfireR::unclassified(result), c(mol2 = "CCC"))
})

test_that("submit_query reports when no entities are classified", {
  testthat::local_mocked_bindings(
    .cf_post = function(...) structure(list(status_code = 200), class = "mock_post"),
    .cf_content = function(resp, ...) {
      if (inherits(resp, "mock_post")) {
        return(list(id = 123))
      }
      stop("Unexpected response object")
    },
    .cf_retry = function(...) list(status_code = 200),
    get_query = function(...) "{\"entities\":[]}",
    .env = asNamespace("classyfireR")
  )

  expect_message(
    expect_null(classyfireR::submit_query("query_test", c(mol1 = "CCO"))),
    "No Successful Classifications"
  )
})
