context("predict_amps")

hepseq_name <- "Hepcidin"
hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
hepseq_df <- data.frame(hepseq_name, hepseq, stringsAsFactors = FALSE)

test_that("predict_amps gives a data frame with correct dimensions", {

  result <- predict_amps(hepseq_df)

  expect_is(result,"data.frame")

  expect_equal(
    dim(result),
    c(1,3))

})


test_that("predict_amps works when input contains invalid aa sequences", {

  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,paste(hepseq,"%",sep=""),substring(hepseq,1,30)), stringsAsFactors = FALSE)

  result <- predict_amps(test_df)

  expect_is(result,"data.frame")

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

  expect_is(result,"data.frame")

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

  expect_is(result,"data.frame")

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

  expect_is(result,"data.frame")

  expect_equal(
    dim(result),
    c(1,3))

  expect_equal(
    rowSums(is.na(result)),
    c(1))
})


test_that("predict_amps works with multiple input sequences on multiple cores", {
  skip_on_os('windows')
  test_df <- data.frame(names=c("A","B","C"),seq=c(hepseq,hepseq,hepseq), stringsAsFactors = FALSE)

  result <- predict_amps(test_df, n_cores = 2)

  expect_is(result,"data.frame")

  expect_equal(
    dim(result),
    c(3,3))

  expect_equal(
    rowSums(is.na(result)),
    c(0,0,0))

})
