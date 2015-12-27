# install.packages("RCurl")
library(RCurl)
require(caret)
require(ggplot2)
require(randomForest)

# URLS OF SOURCE DATA
URL_TRAIN <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
URL_TEST <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

# DATA FRAMES WITH SOURCE DATA
set_train <- read.csv(URL_TRAIN,na.strings=c("NA",""))
set_test <- read.csv(URL_TEST,na.strings=c("NA",""))

# DATA FRAMES CLEANED OUT OF ROWS CONTAINING NAs VALUES
cells_no_NAs<-apply(!is.na(set_train),2,sum) == 19622
cells_no_NAs["X"] <- FALSE
useful_data_train <- set_train[,cells_no_NAs]
useful_data_test <- set_test[,cells_no_NAs]

InTrain<-createDataPartition(y=useful_data_train$classe,p=0.75,list=FALSE)
set_train_1 <- useful_data_train[InTrain,]

# TRAINING AN ALGORITHM BASED ON RANDOM FOREST MODEL
model_control <- trainControl(method="cv",number=5, allowParallel=T, verbose=T)
random_forest_model<-train(classe~.,data=set_train_1,method="rf",
                trControl=model_control, verbose = F)

print(random_forest_model)
print(random_forest_model$finalModel)