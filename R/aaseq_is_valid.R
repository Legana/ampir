#' Check protein sequences for non-standard amino acids
#'
#' Any proteins that contains an amino acid that is not one of the 20 standard amino acids is flagged as invalid
#'
#'
#' @param seqs A vector of protein sequences
#'
#' @return A logical vector where TRUE indicates a valid protein sequence and FALSE indicates a sequence with invalid amino acids
#'
#' @examples
#'
#' # non_standard_df <- readRDS(system.file("extdata/non_standard_df.rds", package = "ampir"))
#'
#' ## Example dataframe (non_standard_df)
#' # non_standard_df
#' #       seq_name            seq_aa
#' # [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....
#' # [2] fake_sequence   MKVTHEUSYR$GXMBIJIDG*M80-%
#'
#' # aaseq_is_valid(non_standard_df$seq.aa)
#'
#' ## Output
#' # [1]  TRUE FALSE


aaseq_is_valid <- function(seq) {
  grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq)
}

