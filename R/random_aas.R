#' Create a random amino acid sequence of given length
#'
#' These functions create random amino acid sequences.
#' random_aa results in a single sequence of any given length,
#' random_aas results in a given number of amino acid sequences with a default random length range between 10 and 2000.
#'
#' @importFrom stats runif
#'
#' @return A character vector of given length
#'
#' @param x Sequence length for random_aa
#'
#' @examples
#' random_aa(x = 10)
#' [1] "IIANHDNADR"
#'


random_aa <- function(x) {

  aa <- c('A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I','L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y','V')
  aa_r <- sample(aa, x, replace = TRUE)
  aa_r <- paste(aa_r, collapse ="")

  aa_r
}

#' Create multiple random amino acid sequences of given length
#'
#' @param n The number of sequences for random_aas
#' @param min_length,max_length The minimum and maximum length of the sequence (default is 10 and 2000, respectively) for random_aas
#'
#' random_aas(n = 3, min_length = 5, max_length = 20)
#' [1] "IGPRWSFRLW"   "NEAHNW"  "LDNCQRTLWKFPHHFHL"

random_aas <- function(n, min_length = 10, max_length = 2000){

  lengths <- round(runif(n,min=min_length,max=max_length))
  sapply(lengths, random_aa)

}
