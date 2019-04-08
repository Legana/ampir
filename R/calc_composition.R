#' Calculate the amino acid composition
#'
#' @references Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).
#' The imported function originates from the Peptides package (https://github.com/dosorio/Peptides/).
#'
#' @importFrom Peptides aaComp
#'
#' @param seq A protein sequence

calc_composition <- function(seq) {
  #call function and assign to variable
  aa_comp <- aaComp(seq)
  #make variable a df
  aa_comp <- as.data.frame(aa_comp)
  #remove all columns with "Number" in the name
  aa_comp <- aa_comp[,-grep('Number',names(aa_comp))]
  #swap rows and column
  aa_comp <- t(aa_comp)
  #change row names
  rownames(aa_comp) <- rownames(seq)
  #change variable to df again
  aa_comp <- as.data.frame(aa_comp)
  #change column names
  names(aa_comp) <- c("TinyAA", "SmallAA", "AliphaticAA", "AromaticAA", "NonPolarAA", "PolarAA", "ChargedAA","BasicAA", "AcidicAA")

  return(aa_comp)

}
