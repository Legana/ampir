
#These functions are from the protr package (https://github.com/nanxstats/protr)
# references Nan Xiao, Dong-Sheng Cao, Min-Feng Zhu, and Qing-Song Xu. (2015). protr/ProtrWeb: R package and web server for generating various numerical representation schemes of protein sequences. Bioinformatics 31 (11), 1857-1859.


protcheck = function(x) {

  AADict = c(
    'A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I',
    'L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V')

  all(strsplit(x, split = '')[[1]] %in% AADict)

}


extractPAAC = function(
  x, props = c('Hydrophobicity', 'Hydrophilicity', 'SideChainMass'),
  lambda = 30, w = 0.05, customprops = NULL) {

  if (protcheck(x) == FALSE)
    stop('x has unrecognized amino acid type')

  if (nchar(x) <= lambda)
    stop('Length of the protein sequence must be greater than "lambda"')

  AAidx = ampir_package_data[['AAidx']]

  if (!is.null(customprops)) AAidx = rbind(AAidx, customprops)

  aaidx = AAidx[, -1]
  row.names(aaidx) = AAidx[, 1]

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

  # Compute (big) Theta

  Theta = vector('list', lambda)

  xSplitted = strsplit(x, split = '')[[1]]

  N = length(xSplitted)

  for (i in 1:lambda) {
    for (j in 1:(N-i)) {
      Theta[[i]][j] = mean((H[, xSplitted[j]] - H[, xSplitted[j + i]])^2)
    }
  }

  # Compute (small) theta

  theta = sapply(Theta, mean)

  # Compute first 20 features

  fc  = summary(factor(xSplitted, levels = AADict), maxsum = 21)
  Xc1 = fc/(1 + (w * sum(theta)))
  names(Xc1) = paste('Xc1.', names(Xc1), sep = '')

  # Compute last lambda features

  Xc2 = (w * theta)/(1 + (w * sum(theta)))
  names(Xc2) = paste('Xc2.lambda.', 1:lambda, sep = '')

  # Combine (20 + lambda) features

  Xc = c(Xc1, Xc2)

  Xc

}
