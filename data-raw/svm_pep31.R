library(caret)

featuresPEP <- readRDS("data-raw/tmpdata/featuresPEP31.rds")

trainPEPIndex <-createDataPartition(y=featuresPEP$Label, p=.8, list = FALSE)
featuresPEPTrain <-featuresPEP[trainPEPIndex,]
featuresPEPTest <-featuresPEP[-trainPEPIndex,]

trctrlPEP <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

set.seed(123)

svm_PEP31 <- train(Label~., data = featuresPEPTrain, method="svmRadial",
                    trControl = trctrlPEP, preProcess = c("center", "scale"),
                    tuneLength = 10)


saveRDS(svm_PEP31, file = "svm_pepbgtg_31.rds")
