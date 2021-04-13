library(usethis)

# Tuned model for full length precursors
# Tuned model for mature peptides
#
# See https://github.com/legana/amp_pub for details of how this was generated
#
precursor_model <- readRDS("data-raw/tuned_precursor_imbal_full.rds")
precursor_model$trainingData <- precursor_model$trainingData[1,]
precursor_model$resampledCM <- NULL
precursor_model$control <- NULL
precursor_model$results <- NULL
precursor_model$resample <- NULL

mature_model <- readRDS("data-raw/tuned_mature_full.rds")
mature_model$trainingData <- mature_model$trainingData[1,]
mature_model$resampledCM <- NULL
mature_model$control <- NULL
mature_model$results <- NULL
mature_model$resample <- NULL

# Data used for calc_pseudo_comp function
# data obtained from protr package (https://github.com/nanxstats/protr)

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


ampir_package_data <- list('mature_model'=mature_model,"precursor_model" = precursor_model,
                           'AAidx'=AAidx)


usethis::use_data(ampir_package_data,internal = TRUE,overwrite = TRUE, compress = "xz")
