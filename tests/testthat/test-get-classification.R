entity_fixture_json <- function(
  inchikey = "InChIKey=BRMWTNUJHUMWMS-LURJTMIESA-N",
  smiles = "CCO"
) {
  jsonlite::toJSON(
    list(
      inchikey = inchikey,
      smiles = smiles,
      classification_version = "1.0",
      kingdom = list(
        name = "Organic compounds",
        chemont_id = "CHEMONTID:0000000"
      ),
      superclass = list(
        name = "Organooxygen compounds",
        chemont_id = "CHEMONTID:0000001"
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
      predicted_chebi_terms = c("CHEBI:15743", "CHEBI:30879"),
      external_descriptors = list(
        list(
          source = "HMDB",
          source_id = "HMDB00001",
          annotations = c("annot 1", "annot 2")
        )
      ),
      description = "Example compound"
    ),
    auto_unbox = TRUE
  )
}

test_that("get_classification returns a populated ClassyFire object", {
  testthat::local_mocked_bindings(
    .cf_retry = function(...) list(status_code = 200),
    .cf_content = function(...) entity_fixture_json(),
    .env = asNamespace("classyfireR")
  )

  result <- classyfireR::get_classification("BRMWTNUJHUMWMS-LURJTMIESA-N")

  expect_s4_class(result, "ClassyFire")
  expect_equal(classyfireR::meta(result)[["inchikey"]], "InChIKey=BRMWTNUJHUMWMS-LURJTMIESA-N")
  expect_s3_class(classyfireR::classification(result), "tbl_df")
  expect_equal(classyfireR::direct_parent(result)[["name"]], "Primary alcohols")
  expect_equal(classyfireR::alternative_parents(result)$name, "Alternative parent")
  expect_equal(classyfireR::chebi(result), c("CHEBI:15743", "CHEBI:30879"))
  expect_equal(classyfireR::descriptors(result)$annotations, "annot 1 // annot 2")
  expect_equal(classyfireR::description(result), "Example compound")
})

test_that("get_classification caches and reuses serialized results", {
  conn <- classyfireR::open_cache()
  on.exit(RSQLite::dbDisconnect(conn), add = TRUE)

  testthat::local_mocked_bindings(
    .cf_retry = function(...) list(status_code = 200),
    .cf_content = function(...) entity_fixture_json(),
    .env = asNamespace("classyfireR")
  )

  first <- classyfireR::get_classification("BRMWTNUJHUMWMS-LURJTMIESA-N", conn = conn)

  testthat::local_mocked_bindings(
    .cf_retry = function(...) stop("HTTP should not be called on cache hit"),
    .env = asNamespace("classyfireR")
  )

  second <- classyfireR::get_classification("BRMWTNUJHUMWMS-LURJTMIESA-N", conn = conn)

  expect_equal(classyfireR::meta(first), classyfireR::meta(second))
  expect_equal(
    RSQLite::dbGetQuery(conn, "SELECT COUNT(*) AS n FROM classyfire")$n,
    1
  )
})

test_that("get_classification returns NULL for 404 and empty payloads", {
  testthat::local_mocked_bindings(
    .cf_retry = function(...) list(status_code = 404),
    .env = asNamespace("classyfireR")
  )
  expect_null(classyfireR::get_classification("missing-key"))

  testthat::local_mocked_bindings(
    .cf_retry = function(...) list(status_code = 200),
    .cf_content = function(...) "{}",
    .env = asNamespace("classyfireR")
  )
  expect_null(classyfireR::get_classification("empty-payload"))
})

test_that("get_classification raises explicit errors for 429 and other failures", {
  testthat::local_mocked_bindings(
    .cf_retry = function(...) list(status_code = 429),
    .env = asNamespace("classyfireR")
  )
  expect_error(
    classyfireR::get_classification("rate-limited"),
    "Request rate limit exceeded!"
  )

  testthat::local_mocked_bindings(
    .cf_retry = function(...) list(status_code = 503),
    .env = asNamespace("classyfireR")
  )
  expect_error(
    classyfireR::get_classification("server-error"),
    "HTTP status 503"
  )
})
