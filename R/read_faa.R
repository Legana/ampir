#' Read FASTA amino acid file into a dataframe
#'
#' This function reads a FASTA amino acids file into a dataframe
#'
#' @export read_faa
#'
#' @note This function was originally written by Jinlong Zhang (jinlongzhang01@@gmail.com) for the phylotools package (http://github.com/helixcn/phylotools)
#'
#' @param file file path to the FASTA format file containing the protein sequences
#'
#' @return Dataframe containing the sequence name (seq.name) and sequence (seq.aa) columns
#'
#' @examples
#'
#' read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
#' #         seq.name              seq.aa
#' # [1] G1P6H5_MYOLU  MALTVRIQAACLLLLLLASLTSYSL....

read_faa <- function (file = NULL) {
  faa.lines <- readLines(file)

  ### get sequence names
  seq.name.index <- grep(">", faa.lines)
  seq.name <- gsub(">", "", faa.lines[seq.name.index])

  ### get sequence
  seq.aa.start.index <- seq.name.index + 1
  seq.aa.end.index <- c(seq.name.index, length(faa.lines)+1)[-1]-1

  seq.aa <- rep(NA, length(seq.name.index))

  ### replace NA content with actual sequence content, and concatenate the lines
  for(i in seq_along(seq.name.index)){
    seq.aa.start <- seq.aa.start.index[i]
    seq.aa.end   <- seq.aa.end.index[i]
    seq.aa[i] <- gsub("[[:space:]]", "",
                      paste(faa.lines[seq.aa.start:seq.aa.end],
                            collapse = ""))
  }

  res <- data.frame(seq.name, seq.aa)
  return(res)
}
