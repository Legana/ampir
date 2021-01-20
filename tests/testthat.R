Sys.unsetenv("R_TESTS")

library(testthat)
library(ampir)

test_check("ampir")
