#' Predict the antimicrobial peptide probability of a protein
#'
#' This function predicts the probability of a protein to be an antimicrobial peptide
#'
#' @importFrom caret predict.train
#' @importFrom parallel mclapply
#'
#' @export predict_amps
#'
#' @param faa_df A dataframe obtained from \code{read_faa}) containing two columns: the sequence name (seq_name) and amino acid sequence (seq_aa)
#' @param min_len The minimum protein length for which predictions will be generated
#' @param n_cores On multicore machines split the task across this many processors. This option does not work on Windows
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

predict_amps <- function(faa_df, min_len = 5, n_cores=1) {

  if ( is_tibble(faa_df)){
    message("Coercing tibble to dataframe")
    faa_df <- as.data.frame(faa_df)
  }

  output <- faa_df

  valid_seqs <- aaseq_is_valid(faa_df[,2])
  long_enough_seqs <- nchar(faa_df[,2])>=min_len

  predictable_rows <- valid_seqs & long_enough_seqs

  if (sum(!predictable_rows) > 0){
    message("Could not run prediction for ",sum(!predictable_rows)," proteins because they were either too short or contained invalid amino acids")
  }

  svm_Radial <- ampir_package_data[["svm_Radial"]]

  df <- faa_df[predictable_rows,]

  if ( nrow(df) == 0){

    output$prob_AMP <- NA

    } else {
      n_chunks <- n_cores
      if ( n_cores>1 && nrow(df)>=n_chunks ){
        starts <- as.integer(seq(1,nrow(df),length.out=n_chunks+1))[-(n_chunks+1)]
        ends <- as.integer(seq(1,nrow(df)+1,length.out=n_chunks+1))[-1]-1
        chunk_rows <- lapply(1:n_chunks,function(i){seq(starts[i],ends[i],by=1)})
      } else {
        n_chunks <- 1
        chunk_rows <- list(seq(1,nrow(df),by=1))
      }

    p_AMP_list <- mclapply(chunk_rows,predict_amps_core,df,svm_Radial,min_len, mc.cores = n_cores)
    p_AMP <- do.call(rbind,p_AMP_list)
    output$prob_AMP[predictable_rows] <- p_AMP$Tg
  }

  output
}


predict_amps_core <- function(rows,df,svm_Radial,min_len){
  df_features <- calculate_features(df[rows,], min_len)
  predict.train(svm_Radial, df_features, type = "prob")
}
