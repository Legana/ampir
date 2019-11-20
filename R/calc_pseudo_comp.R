#' Calculate the pseudo amino acid composition
#'
#' This function is adapted from the extractPAAC function from the protr package (https://github.com/nanxstats/protr)
#' @references Nan Xiao, Dong-Sheng Cao, Min-Feng Zhu, and Qing-Song Xu. (2015). protr/ProtrWeb: R package and web server for generating various numerical representation schemes of protein sequences. Bioinformatics 31 (11), 1857-1859.
#'
#' @param seq A vector of protein sequences as character strings
#' @param lambda_min Minimum allowable lambda. It is an error to provide a protein sequence shorter than lambda_min+1
#' @param lambda_max For each sequence lambda will be set to one less than the sequence length or lambda_max, whichever is smaller
#'
calc_pseudo_comp <- function(seq,lambda_min = 4,lambda_max=19) {

  if ( is.factor(seq)){
    message("Coercing factor to character")
    seq <- as.character(seq)
  }

  if ( min(nchar(seq)) < (lambda_min + 1) ){
    stop("One or more sequence is shorter than lambda_min +1 ")
  }

  # Prepare H matrix
  # Note that this is probably the slowest part of this function now.
  # Further performance gains could be obtained by caching this result (via memoize)
  #
  AAidx <- ampir_package_data[["AAidx"]]
  aaidx <- AAidx[, -1]
  row.names(aaidx) <- AAidx[, 1]
  props <- c('Hydrophobicity', 'Hydrophilicity', 'SideChainMass')
  n <- length(props)

  # Standardize H0 to H

  H0 <- as.matrix(aaidx[props, ])

  H  <- matrix(ncol = 20, nrow = n)
  for (i in 1:n) H[i, ] =
    (H0[i, ] - mean(H0[i, ]))/(sqrt(sum((H0[i, ] - mean(H0[i, ]))^2)/20))
  AADict = c(
    'A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I',
    'L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V')
  dimnames(H) = list(props, AADict)


  output_width <- min(lambda_max,max(nchar(seq)))


  pseudo_comp = NULL
  pseudo_comp_names <- c(paste('Xc1.', AADict, sep = ''),paste('Xc2.lambda.', 1:output_width, sep = ''))


  for (i in seq_along(seq)){

    tseq <- strsplit(seq[i],"")[[1]]

    lambda <- min(lambda_max,length(tseq)-1)

    raw_pseaac <- rcpp_paac(tseq,H,lambda,0.05)

    pseaac <- c(raw_pseaac,rep(NA,length(pseudo_comp_names)-length(raw_pseaac)))

    names(pseaac) <- pseudo_comp_names

    pseudo_comp <- rbind(pseudo_comp,pseaac)
    rownames(pseudo_comp) <- NULL
    pseudo_comp <- as.data.frame(pseudo_comp)
  }
  pseudo_comp
}



