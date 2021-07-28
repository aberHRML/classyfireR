library(testthat)
library(RSQLite)

test_that('inchikey in/out db',{
  no_db <-get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')
  expect_false(exists("temp_conn"))
  expect_equal(no_db@meta[["inchikey"]],"InChIKey=MDHYEMXUFSJLGV-UHFFFAOYSA-N")

  temp_conn <- dbConnect(RSQLite::SQLite(), ":memory:")

  dbExecute(temp_conn,"CREATE TABLE IF NOT EXISTS 'classyfire' (
          InChikey CHAR(27) PRIMARY KEY,
          InChi TEXT,
          Classification TEXT)")

  key_wrong <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA',temp_conn)
  expect_true(is.null(key_wrong))

  key_classified <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N',temp_conn)
  expect_equal(key_classified@meta[["inchikey"]],"InChIKey=BRMWTNUJHUMWMS-LURJTMIESA-N")

  key_in_db <- dbGetQuery(temp_conn, "SELECT InChiKey FROM classyfire WHERE InChiKey='BRMWTNUJHUMWMS-LURJTMIESA-N'")
  expect_true(key_in_db=="BRMWTNUJHUMWMS-LURJTMIESA-N")

  key_not_in_db <- dbGetQuery(temp_conn, "SELECT InChiKey FROM classyfire WHERE InChiKey='TYCTXYVLCWMDDR-UHFFFAOYSA-N'")
  expect_true(is.na(key_not_in_db[1,1]))

})

test_that('entity-classification', {
  cl1 <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N',temp_conn)

  expect_true(isS4(cl1))
  expect_true(is.list(meta(cl1)))
  expect_true(tibble::is_tibble(classification(cl1)))
  expect_true(is.list(direct_parent(cl1)))
  expect_true(tibble::is_tibble(alternative_parents(cl1)))
  expect_true(is.vector(chebi(cl1)))
  expect_true(tibble::is_tibble(descriptors(cl1)))
  expect_true(is.character(description(cl1)))

})


