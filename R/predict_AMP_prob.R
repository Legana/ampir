#' Predict the antimicrobial peptide probability of a protein
#'
#' This function predicts the probability of a protein to be an antimicrobial peptide based on feature calculations (as obtained from \code{calculate_features})
#'
#' @export predict_AMP_prob
#'
#' @importFrom caret predict.train
#'
#' @note This model was created via the caret package (https://github.com/topepo/caret/)
#'
#' @param df A dataframe containing numerical features (as calculated by \code{calculate_features})
#'
#' @return A dataframe containing a single column with probability values
#'
#' @examples
#'
#' my_protein_features <- readRDS(system.file("extdata/my_protein_features.rds", package = "ampir"))
#'
#' predict_AMP_prob(my_protein_features)
#' #       seq.name    prob_AMP
#' # [1] G1P6H5_MYOLU  0.9723796

predict_AMP_prob <- function(df) {

  seq.name <- df[,1]
  df <- df[,-1]

  svm_Radial <- ampir_package_data[["svm_Radial"]]

  p_AMP <- predict.train(svm_Radial, df, type = "prob")

  names(p_AMP)[names(p_AMP) == "Tg"] <- "prob_AMP"

  p_AMP_df <- as.data.frame(p_AMP)[2]

  cbind(seq.name, p_AMP_df)

}


