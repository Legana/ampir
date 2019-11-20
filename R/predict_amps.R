#' Predict the antimicrobial peptide probability of a protein
#'
#' This function predicts the probability of a protein to be an antimicrobial peptide
#'
#' @importFrom caret predict.train
#'
#' @export predict_amps
#'
#' @param faa_df A dataframe obtained from \code{read_faa}) containing two columns: the sequence name (seq_name) and amino acid sequence (seq_aa)
#' @param min_len The minimum protein length for which predictions will be generated
#'
#' @return The original input data.frame with a new column added called \code{prob_AMP} with the probability of that sequence to be an antimicrobial peptide. Any sequences that are too short or which contain invalid amin acids will have NA in this column
#'
#' @examples
#'
#' my_bat_faa_df <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#'
#' predict_amps(my_bat_faa_df)
#' #       seq_name    prob_AMP
#' # [1] G1P6H5_MYOLU  0.9723796


predict_amps <- function(faa_df, min_len = 20) {

  output <- faa_df

  valid_seqs <- aaseq_is_valid(faa_df[,2])
  long_enough_seqs <- nchar(faa_df[,2])>=min_len

  predictable_rows <- valid_seqs & long_enough_seqs

  svm_Radial <- ampir_package_data[["svm_Radial"]]

  df <- faa_df[predictable_rows,]

  df_features <- calculate_features(df, min_len)

  p_AMP <- predict.train(svm_Radial, df_features, type = "prob")

  output$prob_AMP[predictable_rows] <- p_AMP$Tg

  output
}
