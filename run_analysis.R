# Downloading and unzipping dataset =========================================
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/clfassignment.zip", method = "curl")

unzip(zipfile="./data/clfassignment.zip",exdir="./data")

# Merging "training" and "test" datasets into one dataset ===================
## Reading files into R
### Training
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
### Test
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
### Features
features <- read.table("./data/UCI HAR Dataset/features.txt")
### Labels
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

## Assigning column names:
colnames(x_train) <- features[,2]; colnames(x_test) <- features[,2] 
colnames(y_train) <-"activityId"; colnames(y_test) <- "activityId"
colnames(subject_train) <- "subjectId"; colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

## Merging all data in one set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# Extracting measurements of mean and StdDev for each measurement ===========
## Reading column names:
colNames <- colnames(setAllInOne)

## Create vector for defining ID, mean and standard deviation:
mean_std <- (grepl("activityId" , colNames) |
             grepl("subjectId" , colNames) | 
             grepl("mean.." , colNames) | 
             grepl("std.." , colNames) 
             )

## Making nessesary subset from setAllInOne:
        setForMeanAndStd <- setAllInOne[ , mean_std == TRUE]

# name data set with descriptive activities =================================
        setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                              by='activityId',
                                              all.x=TRUE)

# Creating a tidy data set with average of variable, activity & subject =====
## Making second tidy data set
        secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
        secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
## Writing second tidy data set in txt file
        write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
