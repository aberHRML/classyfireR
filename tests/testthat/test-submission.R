context('new-submission')

test_that('submit-classification', {
  expect_true(is.list(get_status_code(2813259)))
  expect_true(length(get_status_code(2813259)) == 2)

  inchi <-
    'InChI=1S/C7H11N3O2/c1-10-3-5(9-4-10)2-6(8)7(11)12/h3-4,6H,2,8H2,1H3,(H,11,12)/t6-/m0/s1'

  inchi_sub <-
    submit_classification(query = inchi,
                          label = 'package_test',
                          type = 'STRUCTURE')

  if (is.list(inchi_sub)) {
    expect_true(dplyr::is.tbl(retrieve_classification(inchi_sub$query_id)))
  } else{
    expect_true(dplyr::is.tbl(inchi_sub))
  }

})
