
# step1: Merge or rbind the data file in Training and Test directory's

X_Test <- read.table("./UCI HAR Dataset/test/X_test.txt",  header = FALSE)
X_Train <- read.table("./UCI HAR Dataset/train/X_train.txt",  header = FALSE)
X_data <- rbind(X_Test,X_Train)

# step 2: keep only std() and mean() measurement.

features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
meanStdFeatures <- features[grep("mean|std", features[ ,2]), ]
Keep_data <- X_data[ ,meanStdFeatures[ ,1]]

# Step 3 - Read subject and activity data sets from both Train and Test dir's
Subj_Test <- read.table("./UCI HAR Dataset/test/subject_test.txt",  header = FALSE)
Act_Test <- read.table("./UCI HAR Dataset/test/y_test.txt",  header = FALSE)
Subj_Train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
Act_Train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

# merge subject and activity data files
subj_data <- rbind(Subj_Test, Subj_Train)
act_data <- rbind(Act_Test, Act_Train)

bind_data <- cbind(Keep_data, subj_data, act_data)
names(bind_data) <- c(as.vector(meanStdFeatures[,2]), "Subject", "Activity")

# step 4:  Replace the Activity ID's with names in "activity_labels.txt" file

library(plyr)
activitiesIds <- bind_data[,"Activity"]
activitiesFactors <- as.factor(activitiesIds)
activitiesFactors = revalue(activitiesFactors, c("1"="WALKING", "2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING"))
bind_data[,"Activity"] = activitiesFactors

# step 5: set column names to the bind_data set

names(bind_data) <- c(as.vector(meanStdFeatures[,2]), "Subject", "Activity")

# step 6: Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 

library("data.table", lib.loc="~/R/win-library/3.1")

tidy_dataset <- data.table(bind_data)

avgTidyDataTable <- tidy_dataset[, lapply(.SD,mean), by=c("Activity","Subject")]

newColNames = sapply(names(avgTidyDataTable)[-(1:2)], function(name) paste("mean(", name, ")", sep=""))

setnames(avgTidyDataTable, names(avgTidyDataTable), c("Activity", "Subject", newColNames))

write.csv(avgTidyDataTable, file="Tidy_Avg_dataset.txt", row.names = FALSE)