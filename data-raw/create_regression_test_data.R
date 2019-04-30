# Performs calculations using the current version of ampir and saves results to regression test files
#

library(ampir)

little_seqs <- read_faa("inst/extdata/little_test.fasta")

little_seqs_features <- calculate_features(little_seqs$seq.aa)
little_seqs_features <- cbind(little_seqs$seq.name,little_seqs_features)

saveRDS(little_seqs_features,"tests/little_seqs_features.rds")


hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
hepcidin_paac <- calc_pseudo_comp(hepseq)

saveRDS(hepcidin_paac,"tests/hepcidin_paac.rds")
