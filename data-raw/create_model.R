library(devtools)

load("data-raw/svmRadialwithprob_amph.Rdata")
load("data-raw/uniprot_features.Rdata")

ampir_package_data <- list('svmRadialwithprob_amph'=svmRadialwithprob_amph,'uniprot_features'=uniprot_features)

usethis::use_data(ampir_package_data,internal = TRUE,overwrite = TRUE)
