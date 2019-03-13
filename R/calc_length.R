# The called function within this function originates from the Peptides package (https://github.com/dosorio/Peptides/).
# Reference: Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).

calc_length <- function(seq) {
  aa_count <- lengthpep(seq)

  aa_count <- as.numeric(aa_count)
  as.data.frame(aa_count)
}

