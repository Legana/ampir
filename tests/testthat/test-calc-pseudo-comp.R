# Calculate pseudo amino acid composition from Hepcidin AMP from Myotis lucifugus (UniProt ID G1P6H5)

hepseq_name <- "Hepcidin"
hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"


test_that("calc_pseudo_comp gives correct result with default lambda", {

  expected_result <- readRDS("../testdata/hepcidin_paac.rds")

  result <- calc_pseudo_comp(hepseq)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result,
    expected_result, tolerance=1e-5)

})


test_that("calc_pseudo_comp gives correct result with lambda_max set", {

  expected_result <- readRDS("../testdata/hepcidin_paac_lambda4.rds")

  result <- calc_pseudo_comp(hepseq, lambda_max = 4)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result,
    expected_result, tolerance=1e-5)

})

test_that("calc_pseudo_comp works with mixed length sequences", {

  hepseq_pieces <- c(hepseq,substring(hepseq,1,11), substring(hepseq,1,8))

  result <- calc_pseudo_comp(hepseq_pieces)

  expect_s3_class(result,"data.frame")

  # Result should have rows with 0, 9 and 12 NAs respectively

  expect_equal(
    rowSums(is.na(result)),
    c(0,9,12))

})


test_that("calc_pseudo_comp gives an error when a sequence has length less than or equal to lambda_min", {

  hepseq_short <- substring(hepseq,1,3)

  expect_error(calc_pseudo_comp(hepseq_short, lambda_max = 3))

})




