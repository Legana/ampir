#' Check protein sequences for non-standard amino acids
#'
#' Any proteins that contains an amino acid that is not one of the 20 standard amino acids is flagged as invalid
#'
#'
#' @param seq A vector of protein sequences
#'
#' @return A logical vector where TRUE indicates a valid protein sequence and FALSE indicates a sequence with invalid amino acids

aaseq_is_valid <- function(seq) {
  grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq)
}

