# Creating the predictive model

#read and prepare data
tg <- read_faa("data-raw/tmpdata/swissprot-amps-april19.fasta")
tg$Label <- "Tg"

bg <- read_faa("data-raw/tmpdata/swissprot-all-april19.fasta")
bg$Label <- "Bg"

#remove rows in bg that are in tg
bg <- bg[!bg$seq.aa %in% tg$seq.aa,]

tg <- remove_nonstandard_aa(tg, tg$seq.aa)
bg <- remove_nonstandard_aa(bg, bg$seq.aa)

#select the same number of rows as tg so databases are 1:1
#as the bg database is already a random selection of SwissProt, the end sequences can be removed without issues
bg <- bg[1:3481,]

bg <- bg[sample(nrow(bg),10443),]

bg_tg <- rbind(bg, tg)

#calculate features (this can take some time depending on the dataset size)
features <- calculate_features(bg_tg$seq.aa)

features$Label <- bg_tg$Label

features[["Label"]] <- factor(features[["Label"]])

# Use features to train the model

library(caret)

set.seed(9)

#split the data 80/20 and create train and test set from features
#the model is fit on the training set, and the fitted model is used to predict the dependent variable (response or Y variable)
trainIndex <-createDataPartition(y=features$Label, p=.8, list = FALSE)
featuresTrain <-features[trainIndex,]
featuresTest <-features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

set.seed(398)
#set.seed(3)

#training the model
svm_Radial <- train(Label~., data = featuresTrain, method="svmRadial",
                                trControl = trctrl_prob, preProcess = c("center", "scale"),
                                tuneLength = 10)

RF <- train(Label~., data = featuresTrain, method="rf", ntree = 100,
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)
#testing the model
test_pred <- predict(RF, featuresTest)

#this model
test_pred <- predict(svm_spbgtg_31, featuresTest)

test_pred <- predict(svm_Radial, featuresTest)

confusionMatrix(test_pred, featuresTest$Label)

#svm model without length and aa comp
#Accuracy : 0.9102
#95% CI : (0.8939, 0.9247)
#Sensitivity : 0.9152
#Specificity : 0.9052

#svm model CURRENT with tunelength = 10, seed = 398
#Accuracy : 0.9303
#95% CI : (0.9157, 0.9431)
#Sensitivity : 0.9310
#Specificity : 0.9296

#RF without length or AA comp
#Accuracy : 0.9253
#95% CI : (0.9102, 0.9385)
#Sensitivity : 0.9397
#Specificity : 0.9109

#for RF with all features
#Accuracy : 0.9181
##Sensitivity : 0.9353
#Specificity : 0.9009

#svm
#seed 397 was this: -WITH LENGTH
#Accuracy : 0.9009
#95% CI : (0.8839, 0.9161)
#Sensitivity : 0.8980
#Specificity : 0.9037

#seed 397 without Length: ---- REMOVE LENGTH FROM FEATURE CALC
#Accuracy : 0.9023
#95% CI : (0.8855, 0.9174)
#Sensitivity : 0.9009
#Specificity : 0.9037

############################# same for filtered model


tg <- read_faa("data-raw/tmpdata/swissprot-amps-april19.fasta")
tg$Label <- "Tg"

bg <- read_faa("data-raw/tmpdata/filtered_random.fasta")
bg$Label <- "Bg"

bg <- bg[!bg$seq.aa %in% tg$seq.aa,]

tg <- remove_nonstandard_aa(tg, tg$seq.aa)
bg <- remove_nonstandard_aa(bg, bg$seq.aa)

#select the same number of rows as tg so databases are 1:1
#as the bg database is already a random selection of SwissProt, the end sequences can be removed without issues
bg <- bg[1:3481,]

bg_tg <- rbind(bg, tg)

#calculate features (this can take some time depending on the dataset size)
filtered_features <- calculate_features(bg_tg$seq.aa)

filtered_features$Label <- bg_tg$Label

filtered_features[["Label"]] <- factor(filtered_features[["Label"]])

# Use features to train the model

library(caret)

set.seed(6)

#split the data 80/20 and create train and test set from features
#the model is fit on the training set, and the fitted model is used to predict the dependent variable (response or Y variable)
trainIndex <-createDataPartition(y=filtered_features$Label, p=.8, list = FALSE)
filtered_featuresTrain <-filtered_features[trainIndex,]
filtered_featuresTest <-filtered_features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

set.seed(3)

#training the model
svm_Radial_filtered <- train(Label~., data = filtered_featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

#testing the model
filtered_test_pred <- predict(svm_Radial_filtered, filtered_featuresTest)

confusionMatrix(filtered_test_pred, filtered_featuresTest$Label)

