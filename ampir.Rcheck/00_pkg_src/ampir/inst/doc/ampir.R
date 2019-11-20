## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning=FALSE, message=FALSE--------------------------------------
library(ampir)

## ---- warning=FALSE, message=FALSE--------------------------------------------
my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))

## ---- echo = FALSE------------------------------------------------------------
knitr::kable(as.data.frame(as.list(sapply(my_protein, strtrim, 35))), caption = "My protein")

## -----------------------------------------------------------------------------
my_prediction <- predict_amps(my_protein)

## ---- echo=FALSE--------------------------------------------------------------
knitr::kable(my_prediction, digits = 3, caption = "My prediction")

## -----------------------------------------------------------------------------
my_predicted_amps <- extract_amps(df_w_seq = my_protein, df_w_prob = my_prediction, prob = 0.55)

## ---- echo=FALSE--------------------------------------------------------------
knitr::kable(as.data.frame(as.list(sapply(my_predicted_amps, strtrim, 35))), caption = "My predicted AMPs")

## ----eval=FALSE---------------------------------------------------------------
#  df_to_faa(my_predicted_amps, "my_predicted_amps.fasta")

