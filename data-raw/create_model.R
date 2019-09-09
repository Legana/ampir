library(usethis)
library(caret)

# read and prepare data

set.seed(396)
#read data
tg98 <- read_faa("tmpdata/amps_sp_ampdbs98.fasta")
tg98$Label <- "Tg"
bg98 <- read_faa("tmpdata/swissprot_all_MAY98.fasta")
bg98$Label <- "Bg"
#remove rows in bg that are in tg
bg98 <- bg98[!bg98$seq.aa %in% tg98$seq.aa,]
#remove nonstandard amino acids
tg98 <- remove_nonstandard_aa(tg98)
bg98 <- remove_nonstandard_aa(bg98)
#remove sequences shorter than 20 amino acids
tg98 <- tg98[nchar(tg98$seq.aa) >=20,]
bg98 <- bg98[nchar(bg98$seq.aa) >=20,]
#select the same number of rows as tg so databases are 1:1
bg98 <- bg98[sample(nrow(bg98),4981),]
#bind target and background datasets
bg_tg98 <- rbind(bg98, tg98)
#remove rownames
rownames(bg_tg98) <- NULL
#calculate features
features98 <- calculate_features(bg_tg98)
#add Label column for y variable
features98$Label <- bg_tg98$Label
#convert to factor
features98[["Label"]] <- factor(features98[["Label"]])

#split feature set data 80/20 and create train and test set
trainIndex <-createDataPartition(y=features98$Label, p=.8, list = FALSE)
features98Train <-features98[trainIndex,]
features98Test <-features98[-trainIndex,]

#resample method using repeated cross validation and adding in a probability calculation
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

# TRAIN MODEL

# An svm radial model was used using sigma=seq(0.01,0.07,by=0.003), C=c(1:8)
# The final values used for the model svm_radial98_tuned were sigma = 0.07 and C = 5.
# These values were used to recreate the model to minimise model file size


grid_for_final_svmradial98 <- expand.grid(sigma=0.07, C=5)

svm_Radial98_final <- train(Label~.,
                            data = features98Train[,-c(1,27:45)], #without names and lamda values
                            method="svmRadial",
                            trControl = trctrl_prob,
                            preProcess = c("center", "scale"),
                            tuneGrid = grid_for_final_svmradial98)

# TEST MODEL
test_pred <- predict(svm_Radial, featuresTest)
confusionMatrix(test_pred, featuresTest$Label)
#mcc
mcc(TP = 893, FP = 103, TN = 911, FN = 85)
#roc-auc
test_pred_prob <- predict(svm_Radial, featuresTest, type = "prob")
roc(featuresTest$Label, test_pred_prob$Tg)


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


ampir_package_data <- list('svm_Radial'=svm_Radial98_final,
                           'AAidx'=AAidx)


usethis::use_data(ampir_package_data,internal = TRUE,overwrite = TRUE, compress = "xz")
