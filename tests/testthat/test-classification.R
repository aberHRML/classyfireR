context('entity-classification')

test_that('entity-classification', {

  Sys.sleep(4)
  cl1 <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')
  Sys.sleep(4)
  cl2 <- get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')
  Sys.sleep(4)
  cl3 <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA-B')

  expect_true(dplyr::is.tbl(cl1))

  expect_true(dplyr::is.tbl(cl2))

  expect_true(nrow(cl1) == 7)
  expect_true(nrow(cl2) == 3)

  expect_true(ncol(cl1) == 3)

  expect_true(ncol(cl2) == 3)

  expect_true(is.null(cl3))

})
