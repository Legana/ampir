test_that("chunk_rows works when ncores is equal to 1", {

  result_1 <- chunk_rows(10,1)
  result_2 <- chunk_rows(11,1)

  expect_type(result_1,"list")
  expect_type(result_2,"list")

  expect_equal(length(result_1),1)
  expect_equal(length(result_2),1)

  expect_equal(result_1[[1]],1:10)
  expect_equal(result_2[[1]],1:11)

})


test_that("chunk_rows works when ncores is equal to 2", {

  result_1 <- chunk_rows(10,2)
  result_2 <- chunk_rows(11,2)

  expect_type(result_1,"list")
  expect_type(result_2,"list")

  expect_equal(length(result_1),2)
  expect_equal(length(result_2),2)

  expect_equal(result_1[[1]],1:5)
  expect_equal(result_1[[2]],6:10)

  expect_equal(result_2[[1]],1:5)
  expect_equal(result_2[[2]],6:11)

})


test_that("chunk_rows works when ncores is equal to 3", {

  result_1 <- chunk_rows(10,3)
  result_2 <- chunk_rows(11,3)

  expect_type(result_1,"list")
  expect_type(result_2,"list")

  expect_equal(length(result_1),3)
  expect_equal(length(result_2),3)

  expect_equal(result_1[[1]],1:3)
  expect_equal(result_1[[2]],4:6)
  expect_equal(result_1[[3]],7:10)

  expect_equal(result_2[[1]],1:3)
  expect_equal(result_2[[2]],4:6)
  expect_equal(result_2[[3]],7:11)

})
