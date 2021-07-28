Sys.setenv("R_TESTS" = "")

library(testthat)
library(classyfireR)
library(RSQLite)

test_check('classyfireR')
