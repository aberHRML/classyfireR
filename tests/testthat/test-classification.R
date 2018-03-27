context('entity-classification')

test_that('entity-classification', {
  expect_true(is.tbl(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')))

  expect_true(is.tbl(entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')))

  expect_that(nrow(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')), equals(4))
  expect_that(nrow(entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')), equals(4))


  expect_that(ncol(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')), equals(3))

  expect_that(ncol(entity_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')), equals(3))

  expect_true(is.null(entity_classification('BRMWTNUJHUMWMS-LURJTMIESA-B')))

})
