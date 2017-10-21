## Script for reading teh UCI HAR dataset, merging the training and test sets
## and providing a tidied version of selected features of the combined set.

## Loading libraries

library(dplyr)

## Reading the files

## Reading label and feature files

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Reading subject files

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Reading test files

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

## Reading training files

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

## Create a factor of the activity labels for use in tables

activity_labels_factor <- factor(activity_labels[[2]])

## Add activity labels and subjects to tables

xy_test <- cbind(subject_test, x_test)
xy_test <- cbind(activity_labels_factor[y_test[[1]]], xy_test)
xy_train <- cbind(subject_train, x_train)
xy_train <- cbind(activity_labels_factor[y_train[[1]]], xy_train)

## Remove brackets () from the feature names to make them more tidy

tidyfeatures <- sub("\\(\\)", "", as.character(features[[2]]))

## Set column names

names(xy_test) <- c("Activity", "Subject", tidyfeatures)
names(xy_train) <- c("Activity", "Subject", tidyfeatures)

## Merge tables

xy_test_train <- rbind(xy_test, xy_train)

## Find columns with either mean or std in the name

selection <- grep(".*mean.*|.*std.*", names(xy_test_train))

## Select those columns, including also the activity and subject column (1, 2)

xy_test_train_selected <- xy_test_train[,c(1, 2, selection)] 

## Group by Activity and Subject and summarize by applying the mean function

mean_by_activity_and_subject <- group_by(xy_test_train_selected, Activity, Subject) %>% summarize_all(mean)

write.table(mean_by_activity_and_subject, "set_mean.txt", row.name=FALSE)

print(mean_by_activity_and_subject)

