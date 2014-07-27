library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433) # simulate randomforest as the first model to be constructed
modFit2.rf2 <- train(diagnosis~., methood="rf", data=training)
accuracy2.rf2 <- confusionMatrix(testing$diagnosis, predict(modFit2.rf2,testing))
accuracy2.rf2$overall[1]