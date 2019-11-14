#' Remove non standard amino acids from protein sequences
#'
#' This function removes anything that is not one of the 20 standard amino acids in protein sequences
#'
#'
#' @param df A dataframe which contains protein sequence names as the first column and amino acid sequence as the second column
#'
#' @return a dataframe like the input dataframe but with removed proteins that contained non standard amino acids
#'
#' # Example
#' # non_standard_df <- readRDS(system.file("extdata/non_standard_df.rds", package = "ampir"))
#'
#' ## Example dataframe (non_standard_df)
#' # non_standard_df
#' #       seq_name            seq_aa
#' # [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....
#' # [2] fake_sequence   MKVTHEUSYR$GXMBIJIDG*M80-%
#'
#' # remove_nonstandard_aa(non_standard_df)
#'
#' ## Output
#' #       seq_name        seq_aa
#' # [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....

#todo: edit function to remove terminal stop codons automatically and give warning if stop codons are present within the sequence
remove_nonstandard_aa <- function(df) {

  seq <- df[,2]
  seq.name <- df[,1]

  standard_aa_indices <-grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq)

  df[standard_aa_indices,]

}

