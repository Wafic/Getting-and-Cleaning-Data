#Step1: Merges the training and the test sets to create one data set.
####################################################################################

#Read the training and test datasets

library(plyr)

xtrain <- read.table(file = "train/X_train.txt")
ytrain <- read.table(file = "train/Y_train.txt")
strain <- read.table(file = "train/subject_train.txt")

stest <- read.table(file = "test/subject_test.txt")
xtest <- read.table(file = "test/X_test.txt")
ytest <- read.table(file = "test/Y_test.txt")

#Read the features dataset and change name of column 1

features <- read.table(file = "features.txt")
colnames(features)[1]<-"ID"

#bind the data, subject and activity in one table. Change the name of subject to volunteer
#and that of activities to activity number

xbind <- rbind(xtrain, xtest)
sbind <- rbind(strain, stest)
ybind <- rbind(ytrain, ytest)
step1table <- cbind(sbind, xbind, ybind)
colnames(step1table)[1] <- "Volunteer" 
colnames(step1table)[563] <- "activity_number" 

#Step2: Extracts only the measurements on the mean and standard deviation for each measurement. 
####################################################################################

#Extract column number of mean and sd fields from features using grep. Escape to include parantheses.

mean_sd <- grep(pattern = "-mean\\(\\)|-std\\(\\)", features[,2])

#Add name to column numbers

xxx <- as.data.frame(mean_sd)
clean <- merge(features, xxx, by.x = "ID", by.y = "mean_sd")
colnames(clean)[2]<-"m_sd"

#add the two names (volunteer and activity_name) to the dataframe for use in step 4

extralabels <- data.frame(999:1000,c("Volunteer","activity_name"))
colnames(extralabels)[1] <- "ID" 
colnames(extralabels)[2] <- "m_sd" 
step2table <- rbind(clean, extralabels)

#Step3: Uses descriptive activity names to name the activities in the data set
####################################################################################

#use appropriate names for each field in activity_labels file

activity <- read.table(file = "activity_labels.txt")
colnames(activity)[2] <- "activity_name"
colnames(activity)[1] <- "activity_number"

#create table through matching activity number with name

step3table <- merge( step1table, activity, by.x = "activity_number", by.y = "activity_number")

#order table by subject

attach(step3table)
step3btable <- step3table[order(Volunteer),]

#clean table and add names to all remaining unnamed columns from features dataset

step3ctable <- step3btable[2:564]
rownames(step3ctable) <- NULL

transpose <- t(features)
rownames(transpose) <- NULL
dftranspose <- as.data.frame(transpose)

names <- transpose[2,]
colnames(step3ctable)[2:562] <- names

#Step4: Appropriately labels the data set with descriptive variable names. 
####################################################################################

#Drop fields that are not a mean or standard deviation by cross checking with step2table

step4table <- step3ctable[, (colnames(step3ctable)) %in% (step2table$m_sd)] 

#Step5: From the data set in step 4, creates a second, independent tidy data set with 
        #the average of each variable for each activity and each subject.
####################################################################################

#use ddply from plyr to calculate mean per subject and acitivty name

step5table <- ddply(step4table, .(Volunteer, activity_name), function(x) colMeans(x[, 2:67]))

#write out table in .txt format

write.table(step5table, "Clean_Data.txt", row.name=FALSE, sep='\t')
