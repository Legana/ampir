# The called function within this function originates from the protr package (https://github.com/road2stat/protr)
# Reference: Nan Xiao, Dong-Sheng Cao, Min-Feng Zhu, and Qing-Song Xu. (2015). protr/ProtrWeb: R package and web server for generating various numerical representation schemes of protein sequences. Bioinformatics 31 (11), 1857-1859.

calc_pseudo_comp <- function(seq) {
  seq <- as.character(seq)
  pseudo_comp <- extractPAAC(seq)

  as.data.frame(pseudo_comp)


  #loop to reiterate function for each sequence as extractPAAC function only takes 1 sequence at a time


}

