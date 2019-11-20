#' Create a random amino acid sequence of given length
#'
#' This function results in a single sequence of any given length. It is also a helper function for \code{random_aas}.
#'
#' @param x Sequence length for random_aa
#'
#' @return A character vector of given sequence length

random_aa <- function(x) {

  aa <- c('A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I','L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y','V')
  aa_r <- sample(aa, x, replace = TRUE)
  aa_r <- paste(aa_r, collapse ="")

  aa_r
}
