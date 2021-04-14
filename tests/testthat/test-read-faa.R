test_that("read_faa returns a two column data frame", {

  bat_df <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))

  expect_s3_class(bat_df,"data.frame")

  expect_length(bat_df, 2)
})
