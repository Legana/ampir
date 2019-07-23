library(usethis)
library(caret)

# read and prepare data

set.seed(396)

tg <- read_faa("data-raw/tmpdata/amps_sp_ampdbs98.fasta")
tg$Label <- "Tg"
bg <- read_faa("data-raw/tmpdata/bg70g.fasta")
bg$Label <- "Bg"
#remove rows in bg that are in tg
bg <- bg[!bg$seq.aa %in% tg$seq.aa,]
#remove nonstandard amino acids
tg <- remove_nonstandard_aa(tg)
bg <- remove_nonstandard_aa(bg)
#remove sequences shorter than 20 amino acids
tg <- tg[nchar(tg$seq.aa) >=20,]
bg <- bg[nchar(bg$seq.aa) >=20,]
#select the same number of rows as tg so databases are 1:1
bg <- bg[sample(nrow(bg),4981),]
#bind target and background datasets
bg_tg <- rbind(bg, tg)
#remove rownames
rownames(bg_tg) <- NULL
#calculate features
features <- calculate_features(bg_tg)
#add Label column for y variable
features$Label <- bg_tg$Label
#convert to factor
features[["Label"]] <- factor(features[["Label"]])

# Use features to train the model

#split the data 80/20 and create train and test set from features
trainIndex <-createDataPartition(y=features$Label, p=.8, list = FALSE)
featuresTrain <-features[trainIndex,]
featuresTest <-features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

# train model

svm_Radial <- train(Label~.,
                    data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                    method="svmRadial",
                    trControl = trctrl_prob,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)

# test model
test_pred <- predict(svm_Radial, featuresTest)
confusionMatrix(test_pred, featuresTest$Label)
#mcc
mcc(TP = 893, FP = 103, TN = 911, FN = 85)
#roc-auc
test_pred_prob <- predict(svm_Radial, featuresTest, type = "prob")
roc(featuresTest$Label, test_pred_prob$Tg)

#make grids for tuning
grid3 <- expand.grid(sigma=seq(0.05,0.06,by=0.003), C=c(1:9))
grid4 <- expand.grid(sigma=seq(0.05,0.06,by=0.001), C=c(5:8))
grid5 <- expand.grid(sigma=seq(0.01,0.07,by=0.003), C=c(1:8))



svm_Radial_tuned_fine <- train(Label~.,
                               data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                               method="svmRadial",
                               trControl = trctrl_prob,
                               preProcess = c("center", "scale"),
                               tuneGrid = grid4)

svm_Radial_wide_tune_range <- train(Label~.,
                               data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                               method="svmRadial",
                               trControl = trctrl_prob,
                               preProcess = c("center", "scale"),
                               tuneGrid = grid5)
# Test model

test_pred <- predict(svm_Radial_tuned_fine, featuresTest)
confusionMatrix(test_pred, featuresTest$Label)
#mcc
mcc(TP = 916, FP = 96, TN = 916, FN = 80)
#roc-auc
test_pred_prob <- predict(svm_Radial_tuned_fine, featuresTest, type = "prob")
roc_out <- roc(featuresTest$Label, test_pred_prob$Tg)

# wide tune
test_pred <- predict(svm_Radial_wide_tune_range, featuresTest)
confusionMatrix(test_pred, featuresTest$Label)
#mcc
mcc(TP = 898, FP = 98, TN = 916, FN = 80)
#roc-auc
test_pred_prob <- predict(svm_Radial_wide_tune_range, featuresTest, type = "prob")
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


ampir_package_data <- list('svm_Radial'=svm_Radial_tuned_fine,
                           'AAidx'=AAidx)


usethis::use_data(ampir_package_data,internal = TRUE,overwrite = TRUE, compress = "xz")
