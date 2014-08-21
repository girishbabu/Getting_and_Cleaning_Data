# Author: Girish Babu
# 21-Aug-2014

# 1. Create one dataset by merging the test set & training set
setwd("~/R-programming/getting_and_cleaning_data")
training_data <- read.table("./uci_data/train/X_train.txt")
dim(training_data) 
head(training_data)

training_label <- read.table("./uci_data/train/y_train.txt")
table(training_label)
training_subject <- read.table("./uci_data/train/subject_train.txt")

test_data <- read.table("./uci_data/test/X_test.txt")
dim(test_data) # 2947*561
test_label <- read.table("./uci_data/test/y_test.txt") 
table(test_label) 

test_subject <- read.table("./uci_data/test/subject_test.txt")
joined_data <- rbind(training_data, test_data)
dim(joined_data) 

joined_label <- rbind(training_label, test_label)
dim(joined_label) 

joined_subject <- rbind(training_subject, test_subject)
dim(joined_subject) 

# 2. Mean and standard deviation of each measurement. 
features <- read.table("./uci_data/features.txt")
dim(features) 

mean_stddev_indices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
length(mean_stddev_indices) 

joined_data <- joined_data[, mean_stddev_indices]
dim(joined_data) # 10299*66
names(joined_data) <- gsub("\\(\\)", "", features[mean_stddev_indices, 2]) # remove "()"
names(joined_data) <- gsub("mean", "Mean", names(joined_data)) # uppercase M
names(joined_data) <- gsub("std", "Std", names(joined_data)) # uppercase S
names(joined_data) <- gsub("-", "", names(joined_data)) # remove "-" in column names 

# Descriptive activity names of the data set
activity <- read.table("./uci_data/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activity_label <- activity[joined_label[, 1], 2]
joined_label[, 1] <- activity_label
names(joined_label) <- "activity"

# Label the data set with descriptive activity names
names(joined_subject) <- "subject"
cleaned_data <- cbind(joined_subject, joined_label, joined_data)
dim(cleaned_data)

# write out the 1st dataset
write.table(cleaned_data, "merged_data.txt") 

# 5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
subject_length <- length(table(joined_subject)) # 30
activity_length <- dim(activity)[1] # 6
column_length <- dim(cleaned_data)[2]
result <- matrix(NA, nrow=subject_length*activity_length, ncol=column_length) 
result <- as.data.frame(result)
colnames(result) <- colnames(cleaned_data)
row <- 1
for(i in 1:subject_length) {
  for(j in 1:activity_length) {
    result[row, 1] <- sort(unique(joined_subject)[, 1])[i]
    result[row, 2] <- activity[j, 2]
    bool1 <- i == cleaned_data$subject
    bool2 <- activity[j, 2] == cleaned_data$activity
    result[row, 3:column_length] <- colMeans(cleaned_data[bool1&bool2, 3:column_length])
    row <- row + 1
  }
}
head(result)

# write the result section from the second dataset
write.table(result, "data_with_means.txt")
