# Performs calculations using the current version of ampir and saves results to regression test files
#

library(ampir)

little_seqs <- read_faa("inst/extdata/little_test.fasta")

little_seqs_features <- ampir:::calculate_features(little_seqs)

#saveRDS(little_seqs_features,"tests/little_seqs_features.rds")


hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
hepcidin_paac <- ampir:::calc_pseudo_comp(hepseq, lambda_max = 4)
saveRDS(hepcidin_paac,"tests/hepcidin_paac_lambda4.rds")

hepcidin_paac <- ampir:::calc_pseudo_comp(hepseq)
saveRDS(hepcidin_paac,"tests/hepcidin_paac.rds")


hepseq_pieces <- c(hepseq,substring(hepseq,1,11), substring(hepseq,1,8))

source("R/calc_pseudo_comp.R")

calc_pseudo_comp(hepseq_pieces)
