context("remove_nonstandard_aa")

seq_name <- c("Hepcidin", "fake_sequence")
seq <- c("MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT", "MKVTHEUSYR$GXMBIJIDG*M80-%")


test_that("remove_nonstandard_aa returns a data frame", {

  my_messy_protein_test <- data.frame(seq_name, seq, stringsAsFactors = FALSE)

  result <- remove_nonstandard_aa(my_messy_protein_test)

  expect_is(result,"data.frame")
})

test_that("remove_nonstandard_aa removes the fake sequence", {

  my_messy_protein_test <- data.frame(seq_name, seq, stringsAsFactors = FALSE)

  result <- remove_nonstandard_aa(my_messy_protein_test)

  expect_length(nrow(result), 1)

})
