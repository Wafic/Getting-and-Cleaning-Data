#Getting and Cleaning Data

##Introduction

The R script Run_Analysis should achieve the following:

-Step 1: Merges the training and the test sets to create one data set.
-Step 2: Extracts only the measurements on the mean and standard deviation for 
each measurement. 
-Step 3: Uses descriptive activity names to name the activities in the data set
-Step 4: Appropriately labels the data set with descriptive variable names. 
-Step 5: From the data set in step 4, creates a second, independent tidy data set 
with the average of each variable for each activity and each subject.

##Variables:

-The variables `xtrain`, `ytrain`, `strain`, `xtest`, `ytest`, `stest` read the measurements, 
subject ID and activity number data respectively
-The variables `features` and `activity` read the features and activity labels files
respectively
-The variables `xbind`, `ybind`, and `sbind` combine the measurement, activity and subject
data repectively by rows
-The `step1table` combines `xbind`, `ybind` and `sbind` together
-The `mean_sd` varible greps the fields of interest (mean and standard deviation) 
from `step1table`
-The `clean` variable merges the dataframe `xxx` (vector mean_sd converted to dataframe) 
and `mean_sd` to lookup the names of the selected fields in mean_sd
-The `extralabels` adds names to the list of names in `clean`
-The `step2table` binds `extralabels` to the `clean` dataset
-The `step3table` merges `step1table` with `activty` to look up acitivty names
-The `step3btable` presents the `step3table` through ordering by the variable Volunteer
-The `step3ctable` tidies the `step3btable` by removing unnecessary fields
-The `step4table` removes the variables that are not needed as per the content of the 
`step2table` 
-The `step5table` uses `ddply` from the `plyr` to calculate mean per activity per subject 
