context('entity-classification')

test_that('entity-classification', {
  expect_true(dplyr::is.tbl(get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')))

  expect_true(dplyr::is.tbl(get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')))

  expect_true(nrow(get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')) == 7)
  expect_true(nrow(get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')) == 3)

  expect_true(ncol(get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')) == 3)

  expect_true(ncol(get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')) == 3)

  expect_true(is.null(get_classification('BRMWTNUJHUMWMS-LURJTMIESA-B')))

})
