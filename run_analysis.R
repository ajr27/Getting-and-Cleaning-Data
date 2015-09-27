###############################################################################
################### Getting and Cleaning Data Course Project ##################
##
##     Written by: Arcenis Rojas
##     9/20/2015
##
##     File description:
##     This script presents the UCI HAS study data collected for this project
##     as a tidy dataset in which the means of all the variables are presented.
##     The script has the following 5 steps:
##     1. Download and unzip the data file.
##     2. Read the files into R and merge them. First the training dataset is
##        "stacked" to include the data to include the x-train and y-train
##        data, then the same is done for the test datasets, and finally, the
##        two resulting datasets are merged.
##     3. Variables are given descriptive names.
##     4. Means for each variable are calculated using the "aggregate" function
##        and the data is sorted by Activity ID and Subject ID using the
##        "dplyr" package. The tidy dataset is the written as a .csv file.
##
###############################################################################
###############################################################################

# Clean up the workspace
rm(list=ls())

# Date on which the project files were downloaded
dl.date <- date()


###################### STEP 1. Download and unzip the data ####################

# Query the user to choose a root directory in which download and unzip files.
root.dir <- getwd()

# Save the name of the folder to use as a working directory for the project
project.dir <- paste0(root.dir, "/Getting and Cleaning Data Course Project")

# Create a folder for the project files
dir.create(project.dir, showWarnings = FALSE)

# Set the working directory
setwd(project.dir)

# Save the download link for the project files
uci.url <- paste0("https://d396qusza40orc.cloudfront.net/",
  "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")

# Download the course project files
download.file(uci.url, destfile = "ucidata.zip", method = "internal")

# Unzip the UCI HAR folder into the course project folder
unzip("ucidata.zip", exdir = ".")

################### STEP 2. Read in the files and merge data ##################

# Store the name of the UCI HAR Dataset folder and its subfolders
uci.folder   <- paste0(project.dir, "/UCI HAR Dataset")
test.folder  <- paste0(uci.folder, "/test")  # test data folder
train.folder <- paste0(uci.folder, "/train")  # training data folder

# Read in feature and activity label files for naming rows and columns
features.labels <- read.table(paste0(uci.folder, "/features.txt"), 
                              header = FALSE)
activity.labels <- read.table(paste0(uci.folder, "/activity_labels.txt"),
                              header = FALSE)

# Name the columns of the activity labels file
colnames(activity.labels) <- c("ActivityID", "ActivityType")

# Read in and label train data
subject.train <- read.table(paste0(train.folder, "/subject_train.txt"), 
                            header = FALSE)
x.train       <- read.table(paste0(train.folder, "/X_train.txt"), 
                            header = FALSE)
y.train       <- read.table(paste0(train.folder, "/y_train.txt"), 
                            header = FALSE)

colnames(subject.train) <- "SubjectID"
colnames(x.train)       <- features.labels[, 2]
colnames(y.train)       <- "ActivityID"

# Merge the training data
train.data <- cbind(y.train, subject.train, x.train)

# Read in and label test data
subject.test <- read.table(paste0(test.folder, "/subject_test.txt"), 
                            header = FALSE)
x.test       <- read.table(paste0(test.folder, "/X_test.txt"), 
                            header = FALSE)
y.test       <- read.table(paste0(test.folder, "/y_test.txt"), 
                            header = FALSE)

colnames(subject.test) <- "SubjectID"
colnames(x.test)       <- features.labels[, 2]
colnames(y.test)       <- "ActivityID"

# Merge the test data
test.data <- cbind(y.test, subject.test, x.test)

# Combine train and test data
uci.data <- rbind(train.data, test.data)

# Subset data to include only means and standard deviations
uci.col.index <- c(grep("SubjectID", names(uci.data)), 
                   grep("ActivityID", names(uci.data)), 
                   grep("mean", names(uci.data)), grep("std", names(uci.data)))
uci.col.index <- sort(uci.col.index)
uci.data      <- uci.data[, uci.col.index]

################### STEP 3. Create descriptive variable names #################

# Store the data's column names
uci.cols <- names(uci.data)

for(i in 3:length(uci.cols)){
  uci.cols[i] <- gsub("\\()", "", uci.cols[i])
  uci.cols[i] <- gsub("^(t)", "Time -", uci.cols[i])
  uci.cols[i] <- gsub("^(f)", "FFT -", uci.cols[i])
  uci.cols[i] <- gsub("Body", " Body", uci.cols[i])
  uci.cols[i] <- gsub("Body Body", "Body", uci.cols[i])
  uci.cols[i] <- gsub("Acc", " Acceleration", uci.cols[i])
  uci.cols[i] <- gsub("Jerk", " Jerk", uci.cols[i])
  uci.cols[i] <- gsub("Gravity", " Gravity", uci.cols[i])
  uci.cols[i] <- gsub("Gyro", " Gyro", uci.cols[i])
  uci.cols[i] <- gsub("Mag", " Magnitude", uci.cols[i])
  uci.cols[i] <- gsub("-meanFreq", " - Mean Frequency", uci.cols[i])
  uci.cols[i] <- gsub("-mean", " - Mean", uci.cols[i])
  uci.cols[i] <- gsub("-std", " - StdDev", uci.cols[i])
  uci.cols[i] <- gsub("-X", " - X", uci.cols[i])
  uci.cols[i] <- gsub("-Y", " - Y", uci.cols[i])
  uci.cols[i] <- gsub("-Z", " - Z", uci.cols[i])
}

# Replace the column names with the new variable names
colnames(uci.data) <- uci.cols

###################### STEP 4. Calculate variable means #######################

# Create a dataset with the average of each variable for each activity 
# for each subject
tidy.data <- aggregate(uci.data[,names(uci.data) != c('ActivityID','SubjectID')], 
                        by = list(ActivityID= uci.data$ActivityID, 
                                  SubjectID = uci.data$SubjectID),mean)

# Merge tidy.data with the descriptive activity labels
tidy.data <- merge(tidy.data, activity.labels, by = "ActivityID", 
                       all.x = TRUE)

# Put the descriptive activity labels in the 3rd column
tidy.data <- tidy.data[, c(1, 2, ncol(tidy.data), 3:(ncol(tidy.data) - 1))]

# Use the 'dplyr' package to sort the data by ActivityID and SubjectID
library(dplyr)
tidy.data <- arrange(tidy.data, ActivityID, SubjectID)

names(tidy.data)[1:3] <- c("Activity ID", "Subject ID", "Activity Type")

# Write tidy.data to a table in .csv format
write.csv(tidy.data, "tidyData.txt")

