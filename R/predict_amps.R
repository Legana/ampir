#' Predict the antimicrobial peptide probability of a protein
#'
#' This function predicts the probability of a protein to be an antimicrobial peptide
#'
#' @importFrom caret predict.train
#' @importFrom parallel mclapply
#'
#' @export predict_amps
#'
#' @param faa_df A dataframe obtained from \code{read_faa} containing two columns: the sequence name (seq_name) and amino acid sequence (seq_aa)
#' @param min_len The minimum protein length for which predictions will be generated
#' @param n_cores On multicore machines split the task across this many processors. This option does not work on Windows
#' @param model Either a string with the name of a built-in model (mature, precursor), OR, A train object suitable for passing to the predict.train function in the caret package. If omitted the default model will be used.
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

predict_amps <- function(faa_df, min_len = 5, n_cores=1, model = "precursor") {

  if (!is.character(faa_df[,2])){
    col2format <- class(faa_df[,2])
    stop(paste("Sequences are required to be in character format but are provided as ",col2format))
  }

  faa_df <- as.data.frame(faa_df)

  output <- faa_df

  valid_seqs <- aaseq_is_valid(faa_df[,2])
  long_enough_seqs <- nchar(faa_df[,2])>=min_len

  predictable_rows <- valid_seqs & long_enough_seqs

  if (sum(!predictable_rows) > 0){
    message("Could not run prediction for ",sum(!predictable_rows)," proteins because they were either too short or contained invalid amino acids")
  }

  df <- faa_df[predictable_rows,]

  if (is.null(model)){
    stop("No model specified. Value specified for model argument should be a string specifying one of ampirs internal models or a train object")
  }

  if ( (length(model)==1) && (class(model)=="character") ){
    if ( model == "mature"){
      model <- ampir_package_data[["mature_model"]]
    } else if (model == "precursor") {
      model <- ampir_package_data[["precursor_model"]]
    } else {
      stop("Unknown model ",model, " provided. Must be one of ampirs named models or a train object")
    }
  } else {
    feature_list <- colnames(calculate_features(df[1,], min_len))
    if(!all(model$coefnames %in% feature_list)){
      stop("One or more predictors in specified model does not exist in predictors calculated by ampir")
    }
  }


  if ( nrow(df) == 0){

    output$prob_AMP <- NA

    } else {
      chunks <- chunk_rows(nrow(df),n_cores)

      p_AMP_list <- mclapply(chunks,predict_amps_core,df,model,min_len, mc.cores = n_cores)
      p_AMP <- do.call(rbind,p_AMP_list)
      output$prob_AMP[predictable_rows] <- p_AMP[,2]
  }

  output
}


predict_amps_core <- function(rows,df,model,min_len){
  predictors <- colnames(model$trainingData)[-1]
  df_features <- calculate_features(df[rows,], min_len)
  predict.train(model, df_features[,predictors], type = "prob")
}
