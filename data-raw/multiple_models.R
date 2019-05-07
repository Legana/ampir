library(caret)

set.seed(1)

#split the data 80/20 and create train and test set from features
#the model is fit on the training set, and the fitted model is used to predict the dependent variable (response or Y variable)
trainIndex <-createDataPartition(y=features$Label, p=.8, list = FALSE)
featuresTrain <-features[trainIndex,]
featuresTest <-features[-trainIndex,]

#resample method using repeated cross validation and adding in and adding in a probability calculation to use later when predicting
trctrl_prob <- trainControl(method = "repeatedcv", number = 10, repeats = 3, classProbs = TRUE)

set.seed(1)
svm_Radial1 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(2)
svm_Radial2 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(3)
svm_Radial3 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(4)
svm_Radial4 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)


set.seed(5)
svm_Radial5 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(6)
svm_Radial6 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(7)
svm_Radial7 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(8)
svm_Radial8 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)
set.seed(9)
svm_Radial9 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

set.seed(10)
svm_Radial10 <- train(Label~., data = featuresTrain, method="svmRadial",
                    trControl = trctrl_prob, preProcess = c("center", "scale"),
                    tuneLength = 10)

test_pred1 <- predict(svm_Radial1, featuresTest)
test_pred2 <- predict(svm_Radial2, featuresTest)
test_pred3 <- predict(svm_Radial3, featuresTest)
test_pred4 <- predict(svm_Radial4, featuresTest)
test_pred5 <- predict(svm_Radial5, featuresTest)
test_pred6 <- predict(svm_Radial6, featuresTest)
test_pred7 <- predict(svm_Radial7, featuresTest)
test_pred8 <- predict(svm_Radial8, featuresTest)
test_pred9 <- predict(svm_Radial9, featuresTest)
test_pred10 <- predict(svm_Radial10, featuresTest)

confusionMatrix(test_pred3, featuresTest$Label)
confusionMatrix(test_pred4, featuresTest$Label)

