test_that("parse_json_output renames intermediate levels and removes duplicates", {
  json_res <- list(
    kingdom = list(name = "Organic compounds", chemont_id = "CHEMONTID:0000000"),
    superclass = list(name = "Lipids and lipid-like molecules", chemont_id = "CHEMONTID:0000001"),
    intermediate_nodes = list(
      list(name = "Fatty Acyls", chemont_id = "CHEMONTID:0000002")
    ),
    direct_parent = list(
      name = "Primary alcohols",
      chemont_id = "CHEMONTID:0000003"
    ),
    subclass = list(
      name = "Primary alcohols",
      chemont_id = "CHEMONTID:0000003"
    )
  )

  parsed <- classyfireR:::parse_json_output(json_res)

  expect_s3_class(parsed, "data.frame")
  expect_equal(parsed$Classification, c(
    "Organic compounds",
    "Lipids and lipid-like molecules",
    "Primary alcohols",
    "Fatty Acyls"
  ))
  expect_equal(parsed$Level, c("kingdom", "superclass", "subclass", "level 5"))
})

test_that("parse_json_output returns an empty tibble for empty payloads", {
  parsed <- classyfireR:::parse_json_output(list())

  expect_s3_class(parsed, "tbl_df")
  expect_equal(nrow(parsed), 0)
})

test_that("parse_external_desc collapses annotations", {
  parsed <- classyfireR:::parse_external_desc(list(
    external_descriptors = list(
      source = c("HMDB", "KEGG"),
      source_id = c("HMDB00001", "C00001"),
      annotations = list(
        c("annot 1", "annot 2"),
        "annot 3"
      )
    )
  ))

  expect_equal(parsed$source, c("HMDB", "KEGG"))
  expect_equal(parsed$annotations, c("annot 1 // annot 2", "annot 3"))
})

test_that("is_server_there checks the active API host", {
  requested_url <- NULL

  testthat::local_mocked_bindings(
    .cf_get = function(url, ...) {
      requested_url <<- url
      list(status_code = 200)
    },
    .env = asNamespace("classyfireR")
  )

  expect_equal(classyfireR:::is_server_there(), 1)
  expect_match(requested_url, "^https://cfb\\.fiehnlab\\.ucdavis\\.edu/entities/")
})
