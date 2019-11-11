context('entity-classification')

test_that('entity-classification', {

  Sys.sleep(4)
  cl1 <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')

  expect_true(isS4(cl1))

})
