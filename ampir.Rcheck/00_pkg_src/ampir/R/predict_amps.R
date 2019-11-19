#' Predict the antimicrobial peptide probability of a protein
#'
#' This function predicts the probability of a protein to be an antimicrobial peptide
#'
#' @export predict_amps
#'
#' @param faa_df A dataframe obtained from \code{read_faa}) containing two columns: the sequence name (seq_name) and amino acid sequence (seq_aa)
#'
#' @return A dataframe containing a column with the sequence name and probability of that sequence to be an antimicrobial peptide
#'
#' @examples
#'
#' my_bat_faa_df <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#'
#' predict_amps(my_bat_faa_df)
#' #       seq_name    prob_AMP
#' # [1] G1P6H5_MYOLU  0.9723796


predict_amps <- function(faa_df) {
  clean_faa_df <- remove_nonstandard_aa(faa_df)
  features_faa_df <- calculate_features(clean_faa_df)
  rsvm_classify(features_faa_df)
}
