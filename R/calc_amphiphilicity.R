#' Calculate amphiphilicity (or hydrophobic moment)
#'
#' @references Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).
#' The imported function originates from the Peptides package (https://github.com/dosorio/Peptides/).
#'
#' @importFrom Peptides hmoment
#'
#' @param seq A protein sequence
#'

calc_amphiphilicity <- function(seq) {
  Amphiphilicity <- hmoment(seq)

  as.data.frame(Amphiphilicity)
}



