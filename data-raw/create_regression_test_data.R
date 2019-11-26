# Performs calculations using the current version of ampir to create regression test files


library(ampir)

little_seqs <- read_faa("inst/extdata/little_test.fasta")
#calculate features for little_seqs
little_seqs_features <- ampir:::calculate_features(little_seqs)


hepseq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
#calculate pseudo amino acid composition with maximum lambda of 4
hepcidin_paac <- ampir:::calc_pseudo_comp(hepseq, lambda_max = 4)

#calculate pseudo amino acid composition
hepcidin_paac <- ampir:::calc_pseudo_comp(hepseq)

hepseq_pieces <- c(hepseq,substring(hepseq,1,11), substring(hepseq,1,8))

source("R/calc_pseudo_comp.R")

calc_pseudo_comp(hepseq_pieces)
