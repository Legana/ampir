#' Save a dataframe in FASTA format
#'
#' This function writes a dataframe out as a FASTA format file
#'
#' @export df_to_faa
#'
#' @param df a dataframe containing two columns (seq.name and seq.aa)
#' @param file file path to save the named file to
#'
#' @return A FASTA file where protein sequences are represented in two lines: The protein name preceded by a greater than symbol,
#'         and a new second line that contains the protein sequence
#'
#' @examples
#'
#' # Use \code{read_faa} to read a FASTA file as a dataframe
#' my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#'
#' # Use \code{df_to_faa} to write a dataframe into FASTA file format
#' df_to_faa(my_protein,(system.file("extdata/my_protein.fasta", package = "ampir")))
#'
#'
#' ## Output written in "my_protein.fasta"
#' #[1] >G1P6H5_MYOLU
#' #[2] MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT

df_to_faa <- function(df, file = "") {

  seq_name <- as.character(df$seq_name)
  seq_aa <- as.character(df$seq_aa)

  writeLines(paste(">", seq_name, "\n", seq_aa, sep = ""), file)


}
