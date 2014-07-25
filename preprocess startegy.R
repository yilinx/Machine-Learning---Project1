#preprocess strategy

#remove near zero value
nzv <- nearZeroVar(train)
train.process <- train[,-nzv]

#remove columns with large number of NA
na.test <- function(x) {
        sum(is.na(x))
        }
try <- apply(train.process,2,na.test)
try <- try/nrow(train.process)*100    #percentage of NAs in each column
try.select <- data.frame(try[try<0.9])
train.process <- subset(train.process, select=c(rownames(try.select)))

#remove some column names such as "X", "user_name", "raw_timestamp_part_1", 
#"raw_timestamp_part_2", "cvtd_timestamp", "num_window" 
train.process <- train.process[,-(1:6)]
train.proC <- train.process[complete.cases(train.process),]   #keep only completecase enteries

