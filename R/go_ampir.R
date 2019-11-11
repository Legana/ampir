#' Predict the antimicrobial peptide probability of a protein
#'
#' This function predicts the probability of a protein to be an antimicrobial peptide
#'
#' @export go_ampir
#'
#' @importFrom caret predict.train
#'
#' @note The predictive model within this function was created via the caret package (https://github.com/topepo/caret/)
#'
#' @param faa_df A dataframe obtained from \code{read_faa}) containing two columns: the sequence name (seq.name) and amino acid sequence (seq.aa)
#'
#' @return A dataframe containing a column with the sequence name and probability of that sequence to be an antimicrobial peptide
#'
#' @examples
#'
#' my_protein_features <- readRDS(system.file("extdata/my_protein_features.rds", package = "ampir"))
#'
#' my_faa_df <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#'
#' go_ampir(my_faa_df)
#' #       seq.name    prob_AMP
#' # [1] G1P6H5_MYOLU  0.9723796


go_ampir <- function(faa_df) {
  clean_faa_df <- remove_nonstandard_aa(faa_df)
  features_faa_df <- calculate_features(clean_faa_df)
  predict_AMP_prob(features_faa_df)

}
