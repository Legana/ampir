#' Extract predicted antimicrobial peptides (AMPs)
#'
#' This function extracts the protein sequences predicted to be AMPs from \code{predict_AMP_prob}
#'
#' @export df_to_faa
#'
#' @param df_w_seq a dataframe containing two columns (sequence name and sequence)
#'           (output from  \code{read_faa})
#' @param df_w_prob a dataframe containing two columns (sequence name and AMP probability)
#'           (output from \code{predict_AMP_prob})
#' @param prob The greater than or equal to probability value AMP identification should be set at
#'             default is 0.50
#'
#' @return A FASTA file where protein sequences are represented in two lines: The protein name preceded by a greater than symbol,
#'         and a new second line that contains the protein sequence
#'
#' @examples
#'
#' my_protein <- readRDS(system.file("extdata/my_protein_df.rds", package = "ampir"))
#' my_protein_prediction <- readRDS(system.file("extdata/my_protein_prediction.rds", package = "ampir"))
#'
#' extract_amps(my_protein, my_protein_prediction, prob = 0.55)
#'
#' #' ## Output
#' #         seq.name              seq.aa
#' # [1] G1P6H5_MYOLU  MALTVRIQAACLLLLLLASLTSYSL....

extract_amps <- function(df_w_seq, df_w_prob, prob = 0.50) {

  df_w_seq[df_w_prob[,2] >= prob,]
}

