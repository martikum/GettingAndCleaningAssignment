library(stringr)
library(plyr)

## reading features and activities names
featuresNames <- read.table("features.txt")
activityL <- read.table("activity_labels.txt")

## reading test data
var561Data <- read.table("test/X_test.txt", col.names = featuresNames[[2]]) # reading test data with features names
activityN <- read.table("test/y_test.txt") # reading test activities labels
activityNames <- activityL[[2]][activityN[[1]][]] # transforming activity labels into names
var561Data["activity"] <- activityNames # adding activity names to test dataset
subject <- read.table("test/subject_test.txt") # reading test subjects
var561Data["subject"] <- subject # adding subjects to test dataset

## reading train data
tmpDataset <- read.table("train/X_train.txt", col.names = featuresNames[[2]]) # reading train data with features names
activityN <- read.table("train/y_train.txt") # reading train activities labels
activityNames <- activityL[[2]][activityN[[1]][]] # transforming activity labels into names
tmpDataset["activity"] <- activityNames # adding activity names to train dataset
subject <- read.table("train/subject_train.txt") # reading train subjects
tmpDataset["subject"] <- subject # adding subjects to train dataset

## binding test and train data
var561Data <- rbind(var561Data, tmpDataset)

## removing obsolete data frames
rm(tmpDataset)
rm(activityN)

## subsetting only mean and standard deviation features 
meanStdLogi <- grepl("*mean|std*", featuresNames[[2]])
tidyDataSet <- var561Data[, c(meanStdLogi, TRUE, TRUE)]

## aggregate data grouping by subject + activity columns
tidyDataSetMeans <- aggregate(. ~ subject+activity, data = tidyDataSet, FUN = function(x) c(mn = mean(x) ) )

## export resulting data set to output.txt file
write.table(tidyDataSetMeans, file = "output.txt")