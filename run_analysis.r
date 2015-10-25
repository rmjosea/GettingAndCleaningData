###Load packages
library(dplyr)
library(data.table)
library(tidyr)

##Path to data
filesPath <- "/home/jose/proyectos/coursera/GettingCleaningData/Project/UCI\ HAR\ Dataset"
#PAth to test
pathTest<-file.path(filesPath, "test")
#Path to train
pathTrain<-file.path(filesPath, "train")

#Data Subject Test
dataSubjectTest <- tbl_df(read.table(file.path(pathTest,"subject_test.txt")))
#Data Activity Test
dataActivityTest <- tbl_df(read.table(file.path(pathTest,"y_test.txt")))
#Data subject Train
dataSubjectTrain <- tbl_df(read.table(file.path(pathTrain,"subject_train.txt")))
#Data Activity Train
dataActivityTrain <- tbl_df(read.table(file.path(pathTrain,"y_train.txt")))
#DataFiles
#Read data files.
dataTrain <- tbl_df(read.table(file.path(pathTrain, "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(pathTest, "X_test.txt" )))

##  Merges data

## Activity and Subject files merge 
##All Data Subject
allSubject <- rbind(dataSubjectTrain, dataSubjectTest)
#Rename Variables "subject" and "activityNum"
setnames(allSubject, "V1", "subject")
##All Data Activity
allActivity<- rbind(dataActivityTrain, dataActivityTest)
#rename Variables
setnames(allActivity, "V1", "activityNum")

combineDataTable <- rbind(dataTrain, dataTest)

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
dataFeatures <- tbl_df(read.table(file.path(filesPath, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(combineDataTable) <- dataFeatures$featureName

activityLabels<- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

# Merge columns
allDataMerge<- cbind(allSubject, allActivity)
combineDataTable <- cbind(allDataMerge, combineDataTable)

# Extract mean and standard deviation
dataFeaturesMeanDesviation <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) #var name

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"

dataFeaturesMeanDesviation <- union(c("subject","activityNum"), dataFeaturesMeanDesviation)
combineDataTable<- subset(combineDataTable,select=dataFeaturesMeanDesviation)

# Uses descriptive activity names to name the activities in the data set

##enter name of activity into dataTable
combineDataTable <- merge(activityLabels, combineDataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(combineDataTable$activityName)

## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(combineDataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = combineDataTable, mean) 
combineDataTable<- tbl_df(arrange(dataAggr,subject,activityName))

write.table(combineDataTable, "../TidyDataSet.txt", row.name=FALSE)

