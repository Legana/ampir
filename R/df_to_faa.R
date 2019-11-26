#' Save a dataframe in FASTA format
#'
#' This function writes a dataframe out as a FASTA format file
#'
#' @export df_to_faa
#'
#' @param df a dataframe containing two columns: the sequence name and amino acid sequence itself
#' @param file file path to save the named file to
#'
#' @return A FASTA file where protein sequences are represented in two lines: The protein name preceded by a greater than symbol,
#'         and a new second line that contains the protein sequence
#'
#' @examples
#'
#' my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#'
#' # Write a dataframe to a FASTA file
#' df_to_faa(my_protein, tempfile("my_protein.fasta", tempdir()))
#'
#'

df_to_faa <- function(df, file = "") {

  seq_name <- as.character(df[,1])
  seq_aa <- as.character(df[,2])

  writeLines(paste(">", seq_name, "\n", seq_aa, sep = ""), file)


}
