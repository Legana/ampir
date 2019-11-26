#' Read FASTA amino acids file into a dataframe
#'
#' This function reads a FASTA amino acids file into a dataframe
#'
#' @export read_faa
#'
#' @note This function was adapted from `read.fasta.R` by Jinlong Zhang (jinlongzhang01@@gmail.com) for the phylotools package (http://github.com/helixcn/phylotools)
#'
#' @param file file path to the FASTA format file containing the protein sequences
#'
#' @return Dataframe containing the sequence name (seq_name) and sequence (seq_aa) columns
#'
#' @examples
#'
#' read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#'
#' ## Output
#' #         seq_name              seq_aa
#' # [1] G1P6H5_MYOLU  MALTVRIQAACLLLLLLASLTSYSL....

read_faa <- function (file = NULL) {
  faa_lines <- readLines(file)

  ### get sequence names
  seq_name_index <- grep(">", faa_lines)
  seq_name <- gsub(">", "", faa_lines[seq_name_index])

  ### get sequence
  seq_aa_start_index <- seq_name_index + 1
  seq_aa_end_index <- c(seq_name_index, length(faa_lines)+1)[-1]-1

  seq_aa <- rep(NA, length(seq_name_index))

  ### replace NA content with actual sequence content, and concatenate the lines
  for(i in seq_along(seq_name_index)){
    seq_aa_start <- seq_aa_start_index[i]
    seq_aa_end   <- seq_aa_end_index[i]
    seq_aa[i] <- gsub("[[:space:]]", "",
                      paste(faa_lines[seq_aa_start:seq_aa_end],
                            collapse = ""))
  }

  data.frame(seq_name, seq_aa, stringsAsFactors = FALSE)
}
