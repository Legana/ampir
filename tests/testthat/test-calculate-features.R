context("Calculate features")


#' # Calculate features from Hepcidin AMP from Myotis lucifugus (UniProt ID G1P6H5)
#' calculate_features(seq =
#'    "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT")
#'
#' ## Output (showing the first five output columns)
#' # Amphiphilicity  Hydrophobicity     pI          Mw         ....
#' # [1]  0.4145847       0.4373494     8.501312     9013.757   ....

hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"


test_that("Hepcidin gives correct Amphiphilicity", {

  result <- calc_amphiphilicity(hepseq)

  expect_is(result,"data.frame")

  expect_equal(
    result$Amphiphilicity,
    0.4145847)

})


test_that("Hepcidin gives correct Hydrophobicity", {

  result <- calc_hydrophobicity(hepseq)

  expect_is(result,"data.frame")

  expect_equal(
    result$Hydrophobicity,
    0.4373493, tolerance=1e-5)

})


test_that("Hepcidin gives correct Isoelectric point", {

  result <- calc_pI(hepseq)

  expect_is(result,"data.frame")

  expect_equal(
    result$pI,
    8.50131, tolerance=1e-5)

})



test_that("Hepcidin gives correct Molecular weight", {

  result <- calc_mw(hepseq)

  expect_is(result,"data.frame")

  expect_equal(
    result$Mw,
    9013.757, tolerance=1e-5)

})


test_that("Hepcidin gives correct Net charge", {

  result <- calc_net_charge(hepseq)

  expect_is(result,"data.frame")

  expect_equal(
    result$Charge,
    4.53015, tolerance=1e-5)

})


test_that("Hepcidin gives correct Pseudo Amino Acid Composition", {

  expected_result <- readRDS("../hepcidin_paac.rds")

  result <- calc_pseudo_comp(hepseq,lambda=4)

  expect_is(result,"data.frame")

  expect_equal(
    result,
    expected_result, tolerance=1e-5)

})


