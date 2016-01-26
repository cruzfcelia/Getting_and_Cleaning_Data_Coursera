#Coursera: Getting and Cleaning Data (Assignment)
#Célia F. Cruz
#January 2015

#load features and activities data  
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureid", "featurename"))
features[,2] <- as.character(features[,2])
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityid", "activitylabels"))
activity[,2] <- as.character(activity[,2])

#extract data on mean and standard deviation
featureswanted <- grep(".*mean.*|.*std.*", features[,2])
featureswanted.names <- features[featureswanted,2]
featureswanted.names <- gsub('-mean', 'Mean', featureswanted.names)
featureswanted.names <- gsub('-std', 'Std', featureswanted.names)
featureswanted.names <- gsub('[-()]', '', featureswanted.names)

#load datasets
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")

#merging and naming test and training data
train <- cbind(subject_train, Y_train, X_train)
test <- cbind(subject_test, Y_test, X_test)
mergeddata <-rbind(train,test)
colnames(mergeddata) <-c("subject", "activity", featureswanted.names)
mergeddata$activity <-factor(mergeddata$activity, levels = activity[,1], labels = activity[,2])
mergeddata$subject <- as.factor(mergeddata$subject)

#creating a data set with standard deviation and average calculations of each variable for each activity and each subjec
library(data.table)
dt <- data.table(mergeddata)
calculateddata<- dt[, lapply(.SD, mean), by=c("subject", "activity")]
write.table(calculateddata, "tidy_data.txt", row.names = FALSE)