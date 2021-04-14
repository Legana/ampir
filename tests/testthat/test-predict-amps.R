hepseq_name <- "Hepcidin"
hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
hepseq_df <- data.frame(hepseq_name, hepseq, stringsAsFactors = FALSE)

test_that("predict_amps gives a data frame with correct dimensions", {

  result <- predict_amps(hepseq_df)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(1,3))

})


test_that("predict_amps works when input contains invalid aa sequences", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,paste(hepseq,"%",sep=""),substring(hepseq,1,30)), stringsAsFactors = FALSE)

  result <- predict_amps(test_df)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(3,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0,1,0))

})


test_that("predict_amps works when input contains invalid aa sequences and short sequences", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,paste(hepseq,"%",sep=""),substring(hepseq,1,3)), stringsAsFactors = FALSE)

  result <- predict_amps(test_df)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(3,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0,1,1))

})


test_that("predict_amps works when input contains sequences exactly equal to min_len", {

  min_len = 8

  test_df <- data.frame(names=c("A"),substring(hepseq,1,min_len), stringsAsFactors = FALSE)

  result <- predict_amps(test_df,min_len)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(1,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0))
})


test_that("predict_amps works when input contains only invalid sequences", {

  min_len = 8

  test_df <- data.frame(names=c("A"),substring(hepseq,1,min_len-2), stringsAsFactors = FALSE)

  result <- predict_amps(test_df,min_len)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(1,3))

  expect_equal(
    rowSums(is.na(result)),
    c(1))
})


test_that("predict_amps works with explicitly specified precursor model", {
  skip_on_os('windows')
  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,hepseq,hepseq), stringsAsFactors = FALSE)

  result <- predict_amps(test_df, model = "precursor")

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(3,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0,0,0))

})


test_that("predict_amps works with explicitly specified mature model", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,hepseq,hepseq), stringsAsFactors = FALSE)

  result <- predict_amps(test_df, model = "mature")

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(3,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0,0,0))

})


test_that("predict_amps gives an error when invalid model specified", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,hepseq,hepseq), stringsAsFactors = FALSE)

  expect_error(predict_amps(test_df, model = "invalidxxx"),"Unknown model invalidxxx provided*")

})

test_that("predict_amps gives an error when NULL model specified", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,hepseq,hepseq), stringsAsFactors = FALSE)

  expect_error(predict_amps(test_df, model = NULL),"No model*")

})

test_that("predict_amps gives an error when model includes non-ampir features", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,hepseq,hepseq), stringsAsFactors = FALSE)

  fake_model <- list(coefnames = c("blah","blah1"))

  expect_error(predict_amps(test_df, model = fake_model),"One or more*")

})

test_that("predict_amps gives an error when sequences are not characters", {

  test_df <- data.frame(name="Hepcidin",seq="MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT", stringsAsFactors = TRUE)

  expect_error(predict_amps(test_df),"Sequences are required*")

})

test_that("predict_amps works when sequences contain a stop codon at the end", {

  test_data <- data.frame(name = c("withstop","nostop"),
                          seq=c("DKLIGSCVWGAVNYTSDCNGECKRRGYKGGHCGSFANVNCWCET*",
                                "DKLIGSCVWGAVNYTSDCNGECKRRGYKGGHCGSFANVNCWCET"),
                          stringsAsFactors = FALSE)

  result <- predict_amps(test_data)

  expect_s3_class(result,"data.frame")

  expect_equal(
    dim(result),
    c(2,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0,0))
})

# test_that("predict_amps works with multiple cores", {
#   skip_on_os('windows')
#   test_df <- readRDS("../testdata/xbench.rds")
#   result_1core <- predict_amps(test_df, n_cores = 1)
#   expect_equal(
#     dim(result_1core),
#     c(16,3))
#
#   result_2core <- predict_amps(test_df, n_cores = 2)
#   expect_equal(
#     result_1core,
#     result_2core)
# })


