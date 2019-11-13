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
