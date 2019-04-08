#' Calculate the pseudo amino acid composition
#'
#' @references Nan Xiao, Dong-Sheng Cao, Min-Feng Zhu, and Qing-Song Xu. (2015). protr/ProtrWeb: R package and web server for generating various numerical representation schemes of protein sequences. Bioinformatics 31 (11), 1857-1859.
#' The imported function within this function originates from the protr package (https://github.com/road2stat/protr)
#'
#' @importFrom protr extractPAAC
#'
#' @param seq A protein sequence
#'
calc_pseudo_comp <- function(seq) {

    pseudo_comp = NULL

    for (i in 1:length(seq)){

      tseq <- as.character(seq[i])

      if(length(tseq)<30) {
        pseaac <- extractPAAC(tseq,lambda=4)
      } else {
        pseaac <- extractPAAC(tseq)
      }

      pseudo_comp <- rbind(pseudo_comp,pseaac)
      rownames(pseudo_comp) <- NULL
      pseudo_comp <- as.data.frame(pseudo_comp)
    }
    pseudo_comp
  }
