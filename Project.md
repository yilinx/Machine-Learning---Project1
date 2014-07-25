#Weight lifting excercises#

The aim of this piece of work is to explore using machine learning to determine how "correctly" one perfroms their physical workout. This is extremely important especially in atheletes and elderlies who are more susceptible to injuries from physical workouts.

In this study, large amount of data were collected from 6 participants. These data were from accelerometers on the belt, forearm, arm, and dumbell. The participant were asked to perform barbell lifts correctly and incorrectly in 5 different ways.



```
## Warning: package 'caret' was built under R version 3.1.1
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```
## Warning: package 'gbm' was built under R version 3.1.1
```

```
## Loading required package: survival
## Loading required package: splines
## 
## Attaching package: 'survival'
## 
## The following object is masked from 'package:caret':
## 
##     cluster
## 
## Loading required package: parallel
## Loaded gbm 2.1
```



```r
#remove near zero value
nzv <- nearZeroVar(train)
train.process <- train[,-nzv]

#remove columns with large number of NA
na.test <- function(x) {
        sum(is.na(x))
        }
try <- apply(train.process,2,na.test)
try <- try/nrow(train.process)*100    #percentage of NAs in each column
try.select <- data.frame(try[try<0.9])  #keep columns having less than 90% of NA values, ie more         than 90% of enerties are NA, we discard the column

train.process <- subset(train.process, select=c(rownames(try.select)))

#remove some column names such as "X", "user_name", "raw_timestamp_part_1", 
#"raw_timestamp_part_2", "cvtd_timestamp", "num_window" 
train.process <- train.process[,-(1:6)]
train.proC <- train.process[complete.cases(train.process),]   #keep only completecase enteries
```



```r
set.seed(4567)

#train control setting
fitControl <- trainControl(method="cv", number=10)
fitControl.pca <- trainControl(method="cv", number=10, preProcOptions = list(thresh = 0.99, ICAcomp = 3, k = 5))

#various types of models

#randomForest model
modFit.rf <- train(factor(classe)~., method="rf", trControl = fitControl, data=train.proC)   
```

```
## Loading required package: randomForest
```

```
## Warning: package 'randomForest' was built under R version 3.1.1
```

```
## randomForest 4.6-10
## Type rfNews() to see new features/changes/bug fixes.
```

```
## Warning: package 'e1071' was built under R version 3.1.1
```

```r
#gbm model
modFit.gbm <- train(factor(classe)~., method="gbm", trControl=fitControl, data=train.proC, verbose=F)
```

```
## Loading required package: plyr
```

```r
#lda model
modFit.lda <- train(factor(classe)~., method="lda", trControl=fitControl, data=train.proC)
```

```
## Loading required package: MASS
```

```r
#randomForest with pca model
modFit.rfpca <- train(factor(classe)~., method="rf", trControl = fitControl.pca, preProcess = "pca", data=train.proC)
```

```
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
## Warning: invalid mtry: reset to within valid range
```


```r
calacc <- function(modelObj,trueval,testdataframe){
        acc <- confusionMatrix(trueval,predict(modelObj,testdataframe))
        acc <- acc$overall[1]
        return(acc)
        }

#acc(modFit.rf,test$classe,test)
```

