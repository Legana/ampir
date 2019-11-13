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


predict_amps <- function(faa_df, min_len = 20) {

  output <- faa_df

  valid_seqs <- aaseq_is_valid(faa_df[,2])
  long_enough_seqs <- nchar(faa_df[,2])>=min_len

  predictable_rows <- valid_seqs & long_enough_seqs

  svm_Radial <- ampir_package_data[["svm_Radial"]]

  df <- faa_df[predictable_rows,]

  df_features <- calculate_features(df)

  p_AMP <- caret:::predict.train(svm_Radial, df_features, type = "prob")

  output$prob_AMP[predictable_rows] <- p_AMP$Tg

  output
}
