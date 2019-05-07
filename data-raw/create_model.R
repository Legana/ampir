library(usethis)

#svm_radial <- readRDS(system.file("svm_radial.rds", package = "ampir"))

# Used by calc_pseudo_comp
# Obtained from protr
#
#AAidx <- read.csv('data-raw/AAidx.csv', header = TRUE)
AAidx <- readRDS("data-raw/AAidx.rds")

tmp <- data.frame(
  AccNo = c('Hydrophobicity', 'Hydrophilicity', 'SideChainMass'),
  A = c(0.62,  -0.5, 15),  R = c(-2.53,   3, 101),
  N = c(-0.78,  0.2, 58),  D = c(-0.9,    3, 59),
  C = c(0.29,    -1, 47),  E = c(-0.74,   3, 73),
  Q = c(-0.85,  0.2, 72),  G = c(0.48,    0, 1),
  H = c(-0.4,  -0.5, 82),  I = c(1.38, -1.8, 57),
  L = c(1.06,  -1.8, 57),  K = c(-1.5,    3, 73),
  M = c(0.64,  -1.3, 75),  F = c(1.19, -2.5, 91),
  P = c(0.12,     0, 42),  S = c(-0.18, 0.3, 31),
  T = c(-0.05, -0.4, 45),  W = c(0.81, -3.4, 130),
  Y = c(0.26,  -2.3, 107), V = c(1.08, -1.5, 43))
AAidx <- rbind(AAidx, tmp)


ampir_package_data <- list('svm_Radial'=svm_Radial,
                           'AAidx'=AAidx)


##test best compression for each file:
#tools::checkRdaFiles("data-raw/svm_radial96.rds")
#tools::checkRdaFiles("data-raw/AAidx.rds")

usethis::use_data(ampir_package_data,internal = TRUE,overwrite = TRUE, compress = "xz")
