#' Create multiple random amino acid sequences of given length
#'
#' This function uses a helper function (see \code{random_aa}) and creates random amino acid sequences of a given number and length range
#'
#'
#' @importFrom stats runif
#'
#' @param n The number of sequences
#' @param min_length,max_length The minimum and maximum length of the sequence (default is 10 and 2000, respectively)
#'
#' @return A character vector of given number and length range

random_aas <- function(n, min_length = 10, max_length = 2000){

  lengths <- round(runif(n,min=min_length,max=max_length))
  sapply(lengths, random_aa)

}
