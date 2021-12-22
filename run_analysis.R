# Load packages
#library(tidyverse)

# Download the dataset
file_name <- "UCI HAR Dataset"
file_dest <- paste0("./data/", file_name)

if(!file.exists(file_dest)) {
    file_url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
    download.file(url = file_url, destfile = file_dest)
}

# Fetch data
# features & activity
features <- read.table(paste0(file_dest,"/features.txt"), col.names = c("n","feature"))
features$feature <- gsub("[-()]","", features$feature)
activities <- read.table(paste0(file_dest,"/activity_labels.txt"), col.names = c("n","activity"))

# train data
x_train <- read.table(paste0(file_dest,"/train/X_train.txt"), col.names = features$feature)
y_train <- read.table(paste0(file_dest,"/train/y_train.txt"), col.names = "label")
subject_train <- read.table(paste0(file_dest,"/train/subject_train.txt"), col.names = "subject")

# test data
x_test <- read.table(paste0(file_dest,"/test/X_test.txt"), col.names = features$feature)
y_test <- read.table(paste0(file_dest,"/test/y_test.txt"), col.names = "label")
subject_test <- read.table(paste0(file_dest,"/test/subject_test.txt"), col.names = "subject")

# Merge data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
Merged_data <- cbind(subject_data,y_data,x_data)

# Extract mean & std dev cols
Extract_data <- select(Merged_data, subject, label, contains("mean"), contains("std"))

# Replace activity label with the activity description and update colnames
Extract_data$label <- activities[Extract_data$label, 2]
names(Extract_data)[2] <- "activity"

# Grouping by activity and subject
Tidy_data <- Extract_data %>% 
    group_by(subject, activity) %>% 
    summarize_all(.funs = mean)

# Writing to a File
write.table(Tidy_data, "TidyData.txt", row.names = FALSE)
