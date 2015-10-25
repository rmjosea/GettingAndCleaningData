#Getting and Cleaning Data Course Project

This descriptions were taken from features.txt

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
‘-XYZ’ is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

####The set of variables that were estimated from these signals are:

mean(): Mean value

std(): Standard deviation

Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#Requiere packages for this Assigment

library(dplyr)

library(data.table)

library(tidyr)

####Files in folder ‘UCI HAR Dataset’ that will be used are:

This are the Subject Files

test/subject_test.txt

train/subject_train.txt

####ACTIVITY FILES

test/X_test.txt

train/X_train.txt

####DATA FILES

test/y_test.txt

train/y_train.txt

features.txt - Names of column variables in the dataTable

activity_labels.txt - Links the class labels with their activity name.

The follow steps were follow to complete the activity describe in the assigment

1. Load packages
```
library(dplyr)

library(data.table)

library(tidyr)
```
2. Read Data 
```

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
```
3. Merge Data
```
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
```
4. Write a tidy File
```
write.table(combineDataTable, "TidyDataSet.txt", row.name=FALSE)
```