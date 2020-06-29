#' Remove stop codon at end of sequence
#'
#' Stop codons at the end of the amino acid sequences are removed
#'
#'
#' @param faa_df A dataframe containing two columns: the sequence name and amino acid sequence
#'
#' @return The input dataframe without the stop codons at the end of sequences

remove_stop_codon <- function(faa_df) {
  seqs <- gsub("\\*$", "", faa_df[[2]])
  faa_df[[2]] <- seqs
  faa_df

}
