library(usethis)

#TODO: remove uniprot features and add second model (larger dataset or/and filtered ) check how to read data
#in here or save straight after model is created (probably better)

load("data-raw/svmRadialwithprob_amph.Rdata")
load("data-raw/uniprot_features.Rdata")

###why doesnt this work

#svm_radial <- readRDS(system.file("svm_radial.rds", package = "ampir"))
#svm_radial31 <- readRDS(system.file("data-raw/svm_spbgtg_31.rds", package = "ampir"))

#ampir_package_data <- list('svm_radial'=svm_radial,'uniprot_features'=uniprot_features)

ampir_package_data <- list('svm_Radial'=svm_Radial)


##test best compression for each file:
#tools::checkRdaFiles("data-raw/svmRadialwithprob_amph.Rdata")

usethis::use_data(ampir_package_data,internal = TRUE,overwrite = TRUE, compress = "gzip")
