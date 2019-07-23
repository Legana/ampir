library(caret)
library(pROC)

set.seed(396)

tg_pep <- read_faa("data-raw/tmpdata/tg_peptides98.fasta")
tg_pep$Label <- "Tg"

bg_pep <- read_faa("data-raw/tmpdata/bg_peptides98.fasta")
bg_pep$Label <- "Bg"

bg_pep <- bg_pep[!bg_pep$seq.aa %in% tg_pep$seq.aa,]

tg_pep <- remove_nonstandard_aa(tg_pep)
bg_pep <- remove_nonstandard_aa(bg_pep)

bg_pep <- bg_pep[sample(nrow(bg_pep),1307),]

bg_pep_length <- ampir:::calc_length(bg_pep$seq.aa)
range(bg_pep_length) #11 171

tg_pep_length <- ampir:::calc_length(tg_pep$seq.aa)
range(tg_pep_length) #11 132

bg_tgpep <- rbind(bg_pep, tg_pep)
rownames(bg_tgpep) <- NULL

#calculate peptide features
peptide_features <- ampir:::calculate_peptide_features(bg_tgpep)
#add Label column for y variable
peptide_features$Label <- bg_tgpep$Label
#convert to factor
peptide_features[["Label"]] <- factor(peptide_features[["Label"]])


#split the data 80/20 and create train and test set from features
trainIndex <-createDataPartition(y=peptide_features$Label, p=.8, list = FALSE)
peptide_featuresTrain <-peptide_features[trainIndex,]
peptide_featuresTest <-peptide_features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

# train model

svm_peptides_Radial <- train(Label~.,
                    data = peptide_featuresTrain[,-c(1,27:30)], #without names and lamda values
                    method="svmRadial",
                    trControl = trctrl_prob,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)

svm_peptides_Radial_tuned <- train(Label~.,
                             data = peptide_featuresTrain[,-c(1,27:30)], #without names and lamda values
                             method="svmRadial",
                             trControl = trctrl_prob,
                             preProcess = c("center", "scale"),
                             tuneGrid = grid_pep)

grid_pep <- expand.grid(sigma=seq(0.01,0.08,by=0.003), C=c(1:8))

# test model
test_pred <- predict(svm_peptides_Radial, peptide_featuresTest)
confusionMatrix(test_pred, peptide_featuresTest$Label)
#tuned model
test_pred <- predict(svm_peptides_Radial_tuned, peptide_featuresTest)
confusionMatrix(test_pred, peptide_featuresTest$Label)

#roc-auc
test_pred_prob <- predict(svm_peptides_Radial, peptide_featuresTest, type = "prob")
roc(peptide_featuresTest$Label, test_pred_prob$Tg)



damicornin_peptide_feet <- ampir:::calculate_peptide_features(damicornin_mature)
predict(svm_peptides_Radial, damicornin_peptide_feet, type = "prob")



predict(svm_peptides_Radial_tuned, damicornin_peptide_feet, type = "prob")
