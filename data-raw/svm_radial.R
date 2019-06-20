# Creating the predictive model

library(ampir)
library(caret)
library(mltools)
library(pROC)

#read and prepare data
#tg <- read_faa("data-raw/tmpdata/swissprot-amps-april19.fasta")
#bg <- read_faa("data-raw/tmpdata/swissprot-all-april19.fasta")

# read and prepare data for files analysed by cd-hit

tg <- read_faa("data-raw/tmpdata/amps_sp_ampdbs98.fasta")
tg$Label <- "Tg"

bg <- read_faa("data-raw/tmpdata/bg70g.fasta")
#bg <- read_faa("data-raw/tmpdata/bg60.fasta")
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
set.seed(398)
set.seed(396)

bg <- bg[sample(nrow(bg),4981),]
#bg <- bg[sample(nrow(bg),14943),] #4981 * 3

bg_tg <- rbind(bg, tg)

rownames(bg_tg) <- NULL

#calculate older features removed in calculate_features function
#Length <- ampir:::calc_length(bg_tg$seq.aa)
#AAComp <- ampir:::calc_composition(bg_tg$seq.aa)

#calculate features
features <- calculate_features(bg_tg)

#features_all11bg70 <- cbind(features[,-46], Length, AAComp)

#features_all11bg70$Label <- bg_tg$Label

#features_all11bg70[["Label"]] <- factor(features_all11bg70[["Label"]])

#saveRDS(features_all11bg70, "data-raw/tmpdata/features_all11bg70.rds")

features$Label <- bg_tg$Label

features[["Label"]] <- factor(features[["Label"]])

#set aside extra bg sequences to append later in the test set
#features_cut_bg <- features[1:9982,]
#make a balanced dataset
#features <- features[9983:19924,]

# Use features to train the model
#split the data 80/20 and create train and test set from features
#the model is fit on the training set, and the fitted model is used to predict the dependent variable (response or Y variable)
trainIndex <-createDataPartition(y=features$Label, p=.8, list = FALSE)
featuresTrain <-features[trainIndex,]
featuresTest <-features[-trainIndex,]

#create validation subset
#trainIndex2 <-createDataPartition(y=featuresTrain$Label, p=.85, list = FALSE)
#override first featurestrain to remove 15% used as validation set
#featuresTrain <-featuresTrain[trainIndex2,]
#featuresValidation <-featuresTrain[-trainIndex2,]


#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

#set.seed(398)

grid <- expand.grid(sigma = 0.0571133, C = c(3, 4, 5, 6, 7, 8 ,9, 10, 11, 12, 13, 14, 15, 16))

grid1 <- expand.grid(sigma=seq(0,.65,by=0.005), C=c(1:16))

grid2 <- expand.grid(sigma=seq(0.05,0.06,by=0.005), C=c(6:16))

grid3 <- expand.grid(sigma=seq(0.05,0.06,by=0.003), C=c(1:9))

grid4 <- expand.grid(sigma=seq(0.05,0.06,by=0.001), C=c(5:8))

grid5 <- expand.grid(sigma=seq(0.03,0.045,by=0.003), C=c(5:8))

#training the model


svm_Radial <- train(Label~.,
                    data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                    method="svmRadial",
                    trControl = trctrl_prob,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)

svm_Radial_tuned <- train(Label~.,
                          data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                          method="svmRadial",
                          trControl = trctrl_prob,
                          preProcess = c("center", "scale"),
                          tuneGrid = grid3)

svm_Radial_tuned_fine <- train(Label~.,
                          data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                          method="svmRadial",
                          trControl = trctrl_prob,
                          preProcess = c("center", "scale"),
                          tuneGrid = grid4)


svm_Radial_tuned_fine_lessgamma <- train(Label~.,
                               data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                               method="svmRadial",
                               trControl = trctrl_prob,
                               preProcess = c("center", "scale"),
                               tuneGrid = grid5)
#seed 396
svm_Radial_bg60 <- train(Label~.,
                    data = featuresTrain[,-c(1,27:45)], #without names and lamda values
                    method="svmRadial",
                    trControl = trctrl_prob,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)
#test model
test_pred <- predict(svm_Radial, featuresTest)

test_pred <- predict(svm_Radial_tuned_fine, featuresTest)

confusionMatrix(test_pred, featuresTest$Label)

mcc(TP = 909, FP = 87, TN = 915, FN = 81)

mcc(TP = 916, FP = 96, TN = 916, FN = 80)


test_pred_prob <- predict(svm_Radial_tuned_fine, featuresTest, type = "prob")
roc_out <- roc(featuresTest$Label, test_pred_prob$Tg)


confusionMatrix(test_pred, featuresTest$Label, positive = "Tg", mode = "prec_recall")


#extra bg
#featuresTest_extrabg <- rbind(features_cut_bg, featuresTest)
#test_pred_xbg <- predict(svm_Radial_nolambda, featuresTest_extrabg)
#confusionMatrix(test_pred_xbg, featuresTest_extrabg$Label)
#mcc(TP = 905, FP = 91, TN = 10128, FN = 846)
#test_pred_prob <- predict(svm_Radial_nolambda, featuresTest_extrabg, type = "prob")
#roc_out <- roc(featuresTest_extrabg$Label, test_pred_prob$Tg)


# REDUCED TEST TEST


test_pred_short <- predict(svm_Radial, featuresTest_1000)
confusionMatrix(test_pred_short, featuresTest_1000$Label)

mcc(TP = 459, FP = 42, TN = 461, FN = 38)

test_pred_short_prob <- predict(svm_Radial, featuresTest_1000, type = "prob")
roc_out <- roc(featuresTest_1000$Label, test_pred_short_prob$Tg)



#subset testfeatures to 1000
testIndex1 <-createDataPartition(y=featuresTest$Label, p=.503, list = FALSE)
featuresTest_1000 <-featuresTest[testIndex1,]

#make fasta formatable file
test_1000 <- bg_tg[bg_tg$seq.name %in% featuresTest_1000$seq.name,]
rownames(test_1000) <- NULL
df_to_faa(test_1000[,-3], "data-raw/tmpdata/1000_test_sqns.fasta")

saveRDS(featuresTest_1000 ,"data-raw/tmpdata/1000_test_features.rds")


#half these 1000 to use in webservers
#testIndex2 <-createDataPartition(y=featuresTest_1000$Label, p=.499, list = FALSE)
#featuresTest_500_1 <-featuresTest_1000[testIndex2,]
#featuresTest_500_2 <-featuresTest_1000[-testIndex2,]

test_500_1 <- test_1000[1:500,]
test_500_2 <- test_1000[501:1000,]

df_to_faa(test_500_1[,-3], "data-raw/tmpdata/500_1_test_sqns.fasta")
df_to_faa(test_500_2[,-3], "data-raw/tmpdata/500_2_test_sqns.fasta")


#which(featuresTest_500_2$seq.name %in% featuresTest_500_1$seq.name)

#length(grep("Bg", featuresTest_1000$Label))
#length(grep("Tg", featuresTest_1000$Label))


############################# same for filtered model


tg <- read_faa("data-raw/tmpdata/amps_sp_ampdbs98.fasta")
tg$Label <- "Tg"

#bg <- read_faa("data-raw/tmpdata/filtered_random.fasta")

#bg_filtered <- read_faa("data-raw/tmpdata/bg_filtered40.fasta")
bg_filtered <- read_faa("data-raw/tmpdata/uniprot-filtered.fasta")
bg_filtered$Label <- "Bg"

bg_filtered  <- bg_filtered [!bg_filtered $seq.aa %in% tg$seq.aa,]

tg <- remove_nonstandard_aa(tg)
bg_filtered <- remove_nonstandard_aa(bg_filtered)

tg <- tg[nchar(tg$seq.aa) >=20,]
bg_filtered <- bg_filtered[nchar(bg$seq.aa) >=20,]

set.seed(567)
#select the same number of rows as tg so databases are 1:1
bg_filtered <- bg_filtered[sample(nrow(bg_filtered),4981),]

bg_filtered_tg <- rbind(bg_filtered, tg)
rownames(bg_filtered_tg) <- NULL

#calculate features (this can take some time depending on the dataset size)
filtered_features <- calculate_features(bg_filtered_tg)

filtered_features$Label <- bg_filtered_tg$Label

filtered_features[["Label"]] <- factor(filtered_features[["Label"]])

# Use features to train the model

library(caret)


#split the data 80/20 and create train and test set from features
#the model is fit on the training set, and the fitted model is used to predict the dependent variable (response or Y variable)
trainIndex <-createDataPartition(y=filtered_features$Label, p=.8, list = FALSE)
filtered_featuresTrain <-filtered_features[trainIndex,]
filtered_featuresTest <-filtered_features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)


#training the model
svm_Radial_filtered <- train(Label~.,
                             data = filtered_featuresTrain[,-c(1,27:45)], method="svmRadial",
                             trControl = trctrl_prob, preProcess = c("center", "scale"),
                             tuneLength = 10)

#testing the model
filtered_test_pred <- predict(svm_Radial_filtered, filtered_featuresTest)

confusionMatrix(filtered_test_pred, filtered_featuresTest$Label)

library(mltools)

mcc(TP = 946, FP = 50, TN = 952, FN = 44)

library(pROC)

test_pred_prob <- predict(svm_Radial_filtered, filtered_featuresTest, type = "prob")
roc_out <- roc(filtered_featuresTest$Label, test_pred_prob$Tg)

#testing 1000 proteins (unfiltered)

#predicted against reference (true results)

library(caret)
filtered_test_pred <- predict(svm_Radial_filtered, featuresTest_1000)
confusionMatrix(filtered_test_pred, featuresTest_1000$Label)

library(mltools)
mcc(TP = 483, FP = 18, TN = 247, FN = 252)


library(pROC)


test_pred_prob <- predict(svm_Radial_filtered, featuresTest_1000, type = "prob")
roc_out <- roc(featuresTest_1000$Label, test_pred_prob$Tg)

