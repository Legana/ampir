#' Remove non standard amino acids from protein sequences
#'
#' This function removes anything that is not one of the 20 standard amino acids in protein sequences
#'
#' @export remove_nonstandard_aa
#'
#' @param df a dataframe
#' @param seq a column in a dataframe containing protein sequences
#'
#' @return a dataframe like the input dataframe but with removed proteins that contained non standard amino acids
#'
#' @examples
#' ## Example dataframe (param df input)
#' # seq.name        seq.aa
#' # G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....
#' # fake_sequence   MKVTHEUSYR$GXMBIJIDGM80-%
#'
#' remove_nonstandard_aa(df, df$seq.aa)
#'
#' ## Output
#' # seq.name        seq.aa
#' # G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....

remove_nonstandard_aa <- function(df, seq) {

  standard_aa_indices <-grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq)

  df[standard_aa_indices,]

}

