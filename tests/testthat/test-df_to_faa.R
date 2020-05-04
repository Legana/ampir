context("df_to_faa")

hepseq_name <- "Hepcidin"
hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
hepseq_df <- data.frame(hepseq_name, hepseq, stringsAsFactors = FALSE)

test_that("df_to_faa writes a file", {

  written_file <- tempfile()

  expect_false(file.exists(written_file))

  df_to_faa(hepseq_df,file = written_file)

  expect_true(file.exists(written_file))

})

test_that("df_to_faa writes with the correct FASTA output", {

  written_file <- tempfile()

  df_to_faa(hepseq_df,file = written_file)

  read_writtenfile <- readLines(written_file)

  expect_setequal(read_writtenfile,
                  c(">Hepcidin", "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"))

})
