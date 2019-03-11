# The called function within this function originates from the Peptides package (https://github.com/dosorio/Peptides/).
# Reference: Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).

calc_composition <- function(seq) {
  aaComp(seq)
  #browser()
  aa_comp <<- (aaComp(seq))
  as.data.frame(aa_comp)
  aa_comp <- t(aa_comp)
  aa_comp
 # aa_comp <- aa_comp[, -grep('Number', names(aa_comp))]
}

