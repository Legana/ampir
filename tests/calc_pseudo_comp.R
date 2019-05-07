#' Calculate the pseudo amino acid composition
#'
#' This function is adapted from the extractPAAC function from the protr package (https://github.com/nanxstats/protr)
#' @references Nan Xiao, Dong-Sheng Cao, Min-Feng Zhu, and Qing-Song Xu. (2015). protr/ProtrWeb: R package and web server for generating various numerical representation schemes of protein sequences. Bioinformatics 31 (11), 1857-1859.
#'
#' @param seq A protein sequence
#' @param lambda lambda value (determined within the function)
#'
calc_pseudo_comp <- function(seq,lambda = NULL) {

  if ( is.factor(seq)){
    warning("Coercing factor to character")
    seq <- as.character(seq)
  }

  # Prepare H matrix
  # Note that this is probably the slowest part of this function now.
  # Further performance gains could be obtained by caching this result (via memoize)
  #
  AAidx = ampir:::ampir_package_data[['AAidx']]
  aaidx = AAidx[, -1]
  row.names(aaidx) = AAidx[, 1]
  props = c('Hydrophobicity', 'Hydrophilicity', 'SideChainMass')
  n = length(props)

  # Standardize H0 to H

  H0 = as.matrix(aaidx[props, ])

  H  = matrix(ncol = 20, nrow = n)
  for (i in 1:n) H[i, ] =
    (H0[i, ] - mean(H0[i, ]))/(sqrt(sum((H0[i, ] - mean(H0[i, ]))^2)/20))
  AADict = c(
    'A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I',
    'L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V')
  dimnames(H) = list(props, AADict)


  if ( is.null(lambda) ){
    max_lambda <- max(sapply(seq,nchar))
    lambda <- min(30,max_lambda)
  }
  pseudo_comp = NULL
  pseudo_comp_names <- c(paste('Xc1.', AADict, sep = ''),paste('Xc2.lambda.', 1:lambda, sep = ''))


  for (i in 1:length(seq)){

    tseq <- strsplit(seq[i],"")[[1]]

    pseaac <- rcpp_paac(tseq,H,lambda,0.05)

    names(pseaac) <- pseudo_comp_names

    pseudo_comp <- rbind(pseudo_comp,pseaac)
    rownames(pseudo_comp) <- NULL
    pseudo_comp <- as.data.frame(pseudo_comp)
  }
  pseudo_comp
}

