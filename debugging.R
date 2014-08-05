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
modFit2.gbm <- train(diagnosis~., methood="gbm", data=training)
modFit2.lda <- train(diagnosis~., methood="lda", data=training)

stack.rf <- predict(modFit2.rf2, training)
stack.gbm <- predict(modFit2.gbm, training)
stack.lda <- predict(modFit2.lda, training)
stack.df <- data.frame(training$diagnosis, stack.rf, stack.gbm, stack.lda)

modFit2.stack <- train(training.diagnosis~., methood="rf", data=stack.df)

testing.stack <- data.frame("stack.rf"=predict(modFit2.rf2,testing),
                            "stack.gbm"=predict(modFit2.gbm,testing),
                            "stack.lda"=predict(modFit2.lda,testing))

accuracy2.rf2 <- confusionMatrix(testing$diagnosis, predict(modFit2.rf2,testing))
accuracy2.rf2$overall[1]
accuracy2.gbm <- confusionMatrix(testing$diagnosis, predict(modFit2.gbm,testing))
accuracy2.gbm$overall[1]
accuracy2.lda <- confusionMatrix(testing$diagnosis, predict(modFit2.lda,testing))
accuracy2.lda$overall[1]
accuracy2.stack <- confusionMatrix(testing$diagnosis, predict(modFit2.stack,testing.stack))
accuracy2.stack$overall[1]