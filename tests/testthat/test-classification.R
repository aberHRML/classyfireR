context('entity-classification')

test_that('entity-classification', {
  expect_true(dplyr::is.tbl(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')))

  expect_true(dplyr::is.tbl(entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')))

  expect_true(nrow(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')) == 4)
  expect_true(nrow(entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')) == 4)


  expect_true(ncol(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')) == 3)

  expect_true(ncol(entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')) == 3)

  expect_true(is.null(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-B')))

})
