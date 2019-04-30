library(caret)

featuresPEP <- readRDS("featuressptgbg13.rds")

trainIndex <-createDataPartition(y=features$Label, p=.8, list = FALSE)
featuresTrain <-features[trainIndex,]
featuresTest <-features[-trainIndex,]

trctrlPEP <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

set.seed(123)

svm_PEP31 <- train(Label~., data = featuresTrain, method="svmRadial",
                   trControl = trctrlPEP, preProcess = c("center", "scale"),
                   tuneLength = 10)


saveRDS(svm_PEP31, file = "svm_spbgtg_31.rds")
