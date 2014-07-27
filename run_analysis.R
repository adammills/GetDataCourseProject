## Data Cleansing and Analysis Script for getdata-005 course project
## Submission by Adam Mills - Sunday 27th July
## The following script contains ALL the required steps to extract, merge, compile and aggregate the UCI HAR Dataset
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Load Dependencies
library(reshape2)

## Set Dataset Path
sourcedatapath <- "./UCI HAR Dataset/"

## Import Activity Keys Table
activitylabelspath <- paste(sourcedatapath,"activity_labels.txt", sep="")
activities <- read.table(file=activitylabelspath, sep = " ", header=FALSE, stringsAsFactors=TRUE, col.names=c("activity_id","activity"))

## Import Features Table
featurespath <- paste(sourcedatapath,"features.txt", sep="") #Set Path
features <- read.table(file=featurespath, sep = " ", header=FALSE, stringsAsFactors=FALSE, col.names=c("feature_id","feature")) # Read Table
features <- as.data.frame(t(features), stringsAsFactors=FALSE) # Transpose so Columns become Rows

###############################################################################

## BRING IN TRAIN SETS
subset <- "train"

## Import X Train Data onto Features
trainfeaturesfile <- paste(sourcedatapath,subset,"/X_",subset,".txt", sep="")
trainfeatures <- read.table(file=trainfeaturesfile)
colnames(trainfeatures) <- features[2,] # Set Column Names using Universal Feature Table

## Import Train Subjects
trainsubjectfile <- paste(sourcedatapath,subset,"/subject_",subset,".txt", sep="")
trainsubjects <- read.table(file=trainsubjectfile, sep = "\n", header=FALSE, stringsAsFactors=TRUE, col.names="subject")

## Import Train Subject Activity onto Subjects
trainsubjectactivityfile <- paste(sourcedatapath,subset,"/y_",subset,".txt", sep="")
trainsubjects <- cbind(trainsubjects, read.table(file=trainsubjectactivityfile, sep = "\n", header=FALSE, stringsAsFactors=TRUE, col.names="activity_id"))

## Combine Train Subjects and Feature Data
traindataset <- cbind(trainsubjects, trainfeatures)

###############################################################################

## BRING IN TEST SETS
subset <- "test"

## Import X Test Data onto Features
testfeaturesfile <- paste(sourcedatapath,subset,"/X_",subset,".txt", sep="")
testfeatures <- read.table(file=testfeaturesfile)
colnames(testfeatures) <- features[2,] # Set Column Names using Universal Feature Table

## Import Test Subjects
testsubjectfile <- paste(sourcedatapath,subset,"/subject_",subset,".txt", sep="")
testsubjects <- read.table(file=testsubjectfile, sep = "\n", header=FALSE, stringsAsFactors=TRUE, col.names="subject")

## Import Test Subject Activity onto Subjects
testsubjectactivityfile <- paste(sourcedatapath,subset,"/y_",subset,".txt", sep="")
testsubjects <- cbind(testsubjects, read.table(file=testsubjectactivityfile, sep = "\n", header=FALSE, stringsAsFactors=TRUE, col.names="activity_id"))

## Combine Test Subjects and Feature Data
testdataset <- cbind(testsubjects, testfeatures)

###############################################################################

## Combine TRAIN and TEST into Single Working Data Set
workingdataset <- rbind(traindataset,testdataset)

###############################################################################

## Drop unwanted columns i.e. keep subject, activity_id, and all mean and std
workingdataset <- workingdataset[,grep("subject|activity_id|mean\\(\\)+|std\\(\\)+",colnames(workingdataset))]

## Merge WorkingData Set with Activities using an in situ substitution easier than a merge
workingdataset[["activity_id"]] <- activities[ match(workingdataset[['activity_id']], activities[['activity_id']] ) , 'activity']
names(workingdataset)[names(workingdataset)=="activity_id"] <- "activity" ## update id field to correct name

## Melt Data Set
wdsmelt <- melt(workingdataset,id=c("subject","activity")) # Melts the data.frame around the keys subject and activity (think group by)
cleanseddataset <- dcast(wdsMelt, subject + activity ~ variable,mean) # Casts the melted data and collapses around subject and activity using aggregate function mean

###############################################################################

## Write Output to Csv
if(!file.exists("./cleanseddata")){dir.create("./cleanseddata")} # creates output directory if not exist
cleansedfilepath <- "./cleanseddata/output.csv"
write.csv(cleanseddataset, file=cleansedfilepath)
