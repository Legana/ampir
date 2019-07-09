library(caret)
library(mltools)
library(pROC)

tg <- read_faa("data-raw/tmpdata/amps_sp_ampdbs98.fasta")
tg$Label <- "Tg"

#bg <- read_faa("data-raw/tmpdata/filtered_random.fasta")

bg_filtered <- read_faa("data-raw/tmpdata/uniprot-filtered.fasta")
bg_filtered$Label <- "Bg"

bg_filtered  <- bg_filtered [!bg_filtered $seq.aa %in% tg$seq.aa,]

tg <- remove_nonstandard_aa(tg)
bg_filtered <- remove_nonstandard_aa(bg_filtered)

tg <- tg[nchar(tg$seq.aa) >=20,]
bg_filtered <- bg_filtered[nchar(bg$seq.aa) >=20,]

set.seed(386)
#select the same number of rows as tg so databases are 1:1
bg_filtered <- bg_filtered[sample(nrow(bg_filtered),4981),]

bg_filtered_tg <- rbind(bg_filtered, tg)
rownames(bg_filtered_tg) <- NULL

#calculate features
filtered_features <- calculate_features(bg_filtered_tg)

filtered_features$Label <- bg_filtered_tg$Label

filtered_features[["Label"]] <- factor(filtered_features[["Label"]])

# Use features to train the model

#split the data 80/20 and create train and test set from features
trainIndex <-createDataPartition(y=filtered_features$Label, p=.8, list = FALSE)
filtered_featuresTrain <-filtered_features[trainIndex,]
filtered_featuresTest <-filtered_features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)


#training the model with seed 386
svm_Radial_filtered <- train(Label~.,
                             data = filtered_featuresTrain[,-c(1,27:45)], method="svmRadial",
                             trControl = trctrl_prob, preProcess = c("center", "scale"),
                             tuneLength = 10)

#testing the model
filtered_test_pred <- predict(svm_Radial_filtered, filtered_featuresTest)
confusionMatrix(filtered_test_pred, filtered_featuresTest$Label)

#mcc
mcc(TP = 941, FP = 55, TN = 948, FN = 48)
#roc-auc
test_pred_prob <- predict(svm_Radial_filtered, filtered_featuresTest, type = "prob")
roc_out <- roc(filtered_featuresTest$Label, test_pred_prob$Tg)


#testing 1000 proteins

#featuresTest_1000 <- readRDS("data-raw/tmpdata/1000_test_features.rds")

#predicted against reference (true results)

filtered_test_pred <- predict(svm_Radial_filtered, featuresTest_1000)
confusionMatrix(filtered_test_pred, featuresTest_1000$Label)

#mcc
mcc(TP = 479, FP = 22, TN = 245, FN = 254)

#roc-auc
test_pred_prob <- predict(svm_Radial_filtered, featuresTest_1000, type = "prob")
roc_out <- roc(featuresTest_1000$Label, test_pred_prob$Tg)

