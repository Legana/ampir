hepseq_name <- "Hepcidin"
hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"


test_that("calculate_features results in a 45 column data frame", {

  my_protein_test <- data.frame(hepseq_name, hepseq, stringsAsFactors = FALSE)

  result <- calculate_features(my_protein_test)

  expect_s3_class(result,"data.frame")

  expect_length(
    result,
    45)

})


test_that("calculate_features results accepts multi-row input", {

  multirow_test <- data.frame(c("A","B"), c(hepseq,hepseq), stringsAsFactors = FALSE)

  result <- calculate_features(multirow_test)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(2,45))

})

test_that("calculate_features results throws an error on sequences less than min_len", {

  multirow_test <- data.frame(c("A","B"), c(hepseq,substring(hepseq,1,19)), stringsAsFactors = FALSE)

  expect_error(calculate_features(multirow_test, min_len=30))

})



# ## Output (showing the first six output columns)
# #      seq_name     Amphiphilicity  Hydrophobicity     pI          Mw       Charge    ....
# # [1] G1P6H5_MYOLU	   0.4145847       0.4373494     8.501312     9013.757   4.53015   ....


test_that("Hepcidin gives correct Amphiphilicity", {

  result <- calc_amphiphilicity(hepseq)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result$Amphiphilicity,
    0.4145847, tolerance=1e-5)

})


test_that("Hepcidin gives correct Hydrophobicity", {

  result <- calc_hydrophobicity(hepseq)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result$Hydrophobicity,
    0.4373493, tolerance=1e-5)

})


test_that("Hepcidin gives correct Isoelectric point", {

  result <- calc_pI(hepseq)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result$pI,
    8.50131, tolerance=1e-5)

})



test_that("Hepcidin gives correct Molecular weight", {

  result <- calc_mw(hepseq)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result$Mw,
    9013.757, tolerance=1e-5)

})


test_that("Hepcidin gives correct Net charge", {

  result <- calc_net_charge(hepseq)

  expect_s3_class(result,"data.frame")

  expect_equal(
    result$Charge,
    4.53015, tolerance=1e-5)

})

test_that("Sequence column is character format in a dataframe", {

  my_protein_test <- data.frame(hepseq_name, hepseq, stringsAsFactors = FALSE)

  result <- my_protein_test[[2]]

  expect_type(result, "character")
})

