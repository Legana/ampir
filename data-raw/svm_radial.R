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
set.seed(3) # works
set.seed(9) # works but lower ac
set.seed(7)

bg <- bg[sample(nrow(bg),3481),]

bg_tg <- rbind(bg, tg)

#calculate features (this can take some time depending on the dataset size)
features <- calculate_features(bg_tg$seq.aa)

features$Label <- bg_tg$Label

features[["Label"]] <- factor(features[["Label"]])

# Use features to train the model

library(caret)

set.seed(1)

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


#test model
test_pred <- predict(svm_Radial, featuresTest)

confusionMatrix(test_pred, featuresTest$Label)






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

