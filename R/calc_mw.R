# The called function within this function originates from the Peptides package (https://github.com/dosorio/Peptides/).
# Reference: Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).

calc_mw <- function(seq) {
  Mw <- mw(seq)

  as.data.frame(Mw)

  }

