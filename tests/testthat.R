Sys.setenv("R_TESTS" = "")

library(testthat)
library(classyfireR)

test_check('classyfireR')
