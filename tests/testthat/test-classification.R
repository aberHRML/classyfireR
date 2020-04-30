context('entity-classification')

test_that('entity-classification', {
  cl1 <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')

  expect_true(isS4(cl1))
  expect_true(is.list(meta(cl1)))
  expect_true(tibble::is_tibble(classification(cl1)))
  expect_true(is.list(direct_parent(cl1)))
  expect_true(tibble::is_tibble(alternative_parents(cl1)))
  expect_true(is.vector(chebi(cl1)))
  expect_true(tibble::is_tibble(descriptors(cl1)))
  expect_true(is.character(description(cl1)))

  cl2 <- get_classification('BRMWTNUJHUMWMS-LURJTMIESA')

  expect_true(is.null(cl2))


})
