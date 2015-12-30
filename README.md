# Assignment Week 3
Practical Machine Learning
27 / December / 2015

Connect all the libraries

```r
library(RCurl)
```

```
## Loading required package: methods
## Loading required package: bitops
```

```r
require(caret)
```

```
## Loading required package: caret
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
require(ggplot2)
require(randomForest)
```

```
## Loading required package: randomForest
## randomForest 4.6-12
## Type rfNews() to see new features/changes/bug fixes.
## 
## Attaching package: 'randomForest'
## 
## The following object is masked from 'package:ggplot2':
## 
##     margin
```

URLS OF SOURCE DATA

```r
URL_TRAIN <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
URL_TEST <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
```

DATA FRAMES WITH SOURCE DATA

```r
set_train <- read.csv(URL_TRAIN,na.strings=c("NA",""))
set_test <- read.csv(URL_TEST,na.strings=c("NA",""))
```

DATA FRAMES CLEANED OUT OF ROWS CONTAINING NAs VALUES

```r
cells_no_NAs<-apply(!is.na(set_train),2,sum) == 19622
cells_no_NAs["X"] <- FALSE
useful_data_train <- set_train[,cells_no_NAs]
useful_data_test <- set_test[,cells_no_NAs]

InTrain<-createDataPartition(y=useful_data_train$classe,p=0.75,list=FALSE)
set_train_1 <- useful_data_train[InTrain,]
```

TRAINING AN ALGORITHM BASED ON RANDOM FOREST MODEL

```r
model_control <- trainControl(method="cv",number=5, allowParallel=T, verbose=T)
random_forest_model<-train(classe~.,data=set_train_1,method="rf",
                trControl=model_control, verbose = F)
```

```
## + Fold1: mtry= 2 
## - Fold1: mtry= 2 
## + Fold1: mtry=41 
## - Fold1: mtry=41 
## + Fold1: mtry=80 
## - Fold1: mtry=80 
## + Fold2: mtry= 2 
## - Fold2: mtry= 2 
## + Fold2: mtry=41 
## - Fold2: mtry=41 
## + Fold2: mtry=80 
## - Fold2: mtry=80 
## + Fold3: mtry= 2 
## - Fold3: mtry= 2 
## + Fold3: mtry=41 
## - Fold3: mtry=41 
## + Fold3: mtry=80 
## - Fold3: mtry=80 
## + Fold4: mtry= 2 
## - Fold4: mtry= 2 
## + Fold4: mtry=41 
## - Fold4: mtry=41 
## + Fold4: mtry=80 
## - Fold4: mtry=80 
## + Fold5: mtry= 2 
## - Fold5: mtry= 2 
## + Fold5: mtry=41 
## - Fold5: mtry=41 
## + Fold5: mtry=80 
## - Fold5: mtry=80 
## Aggregating results
## Selecting tuning parameters
## Fitting mtry = 41 on full training set
```


```r
print(random_forest_model)
```

```
## Random Forest 
## 
## 14718 samples
##    58 predictor
##     5 classes: 'A', 'B', 'C', 'D', 'E' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold) 
## Summary of sample sizes: 11775, 11774, 11774, 11774, 11775 
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy   Kappa      Accuracy SD   Kappa SD    
##    2    0.9877021  0.9844411  0.0003717216  0.0004712359
##   41    0.9991847  0.9989687  0.0003873132  0.0004898931
##   80    0.9986411  0.9982812  0.0006355951  0.0008040246
## 
## Accuracy was used to select the optimal model using  the largest value.
## The final value used for the model was mtry = 41.
```


```r
print(random_forest_model$finalModel)
```

```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry, verbose = ..1) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 41
## 
##         OOB estimate of  error rate: 0.07%
## Confusion matrix:
##      A    B    C    D    E  class.error
## A 4185    0    0    0    0 0.0000000000
## B    2 2846    0    0    0 0.0007022472
## C    0    4 2563    0    0 0.0015582392
## D    0    0    3 2408    1 0.0016583748
## E    0    0    0    0 2706 0.0000000000
```

Run prediction

```r
predict(random_forest_model, set_test)
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
