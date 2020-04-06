#' Remove non standard amino acids from protein sequences
#'
#' This function removes anything that is not one of the 20 standard amino acids in protein sequences
#'
#' @export remove_nonstandard_aa
#'
#' @param df A dataframe which contains protein sequence names as the first column and amino acid sequence as the second column
#'
#' @return a dataframe like the input dataframe but with removed proteins that contained non standard amino acids
#'
#' @examples
#'
#' non_standard_df <- readRDS(system.file("extdata/non_standard_df.rds", package = "ampir"))
#'
#' # non_standard_df
#' #       seq_name            seq_aa
#' # [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....
#' # [2] fake_sequence   MKVTHEUSYR$GXMBIJIDG*M80-%
#'
#' remove_nonstandard_aa(non_standard_df)
#' #       seq_name        seq_aa
#' # [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....

remove_nonstandard_aa <- function(df) {

  seq_aa <- df[,2]
  seq_name <- df[,1]

  standard_aa_indices <-grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq_aa)

  df[standard_aa_indices,]

}

