Getting and Cleaning Data

coursera assignment1

##Important Information It is especially important to submit this assignment before the deadline, February 11, 11:59 PM PST, because it must be graded by others. If you submit late, there may not be enough classmates around to review your work. This makes it difficult - and in some cases, impossible - to produce a grade. Submit on time to avoid these risks.

It looks like this is your first peer-graded assignment. Learn more

##InstructionsMy submissionDiscussions The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

##Review criterialess *The submitted data set is tidy. *The Github repo contains the required scripts. *GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information. *The README that explains the analysis files is clear and understandable. *The work submitted for this project is the work of the student who submitted it. *Getting and Cleaning Data Course Projectless

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

*Merges the training and the test sets to create one data set. *Extracts only the measurements on the mean and standard deviation for each measurement. *Uses descriptive activity names to name the activities in the data set *Appropriately labels the data set with descriptive variable names. *From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. Good luck!

#run_analysis.R Breakdown

libraries

Additional libraries were required

*data.table * read space delimited files into a data table for easier manipulation

dplyr
for data manipulation
Download and unzip

The URL is hard coded and stored in a variable called fileURL

Check if the file exists, if not download it and unzip the file currrent working directory

if (!file.exists('./Dataset.zip')){
download.file(fileurl,destfile='./Dataset.zip')
unzip("Dataset.zip", exdir = getwd())
}
Load the data into tables

by using data.table able to easily copy the file into a data table EG:

activity_label <- read.table("UCI HAR Dataset/activity_labels.txt",  fill = TRUE , header = FALSE )
Additional parameters were included

*fill *logical. If TRUE then in case the rows have unequal length, blank fields are implicitly added. *header *a logical value indicating whether the file contains the names of the variables as its first line. If missing, the value is determined from the file format: header is set to TRUE if and only if the first row contains one fewer field than the number of columns.

binding rows and setting Names to columns

Using rbind to join the tables together then set the names to be human readabile EG:

subject_data <- rbind(subject_train,subject_test)
setnames(subject_data, "V1", "Subject")
then merge all coloumns together and get dimensions of the table.

mean and std deviation

use regex to grep out the mean and std deavation. find the length

feat_index <- grep("mean\\(\\)|std\\(\\)", features[,2])
print(length(feat_index))
assign labels then clean it up

grab the variables for the names and update the column names with the new values

names <- features[feat_index,2]
names(x_data) <- names
names(subject_data) <- "Subject_ID"
names(y_data) <- "Activity_Type"

clean <- cbind(subject_data, y_data,x_data)
print(head(clean[,c(1:9)]))
write to file tiny.txt

grab the cleaned data using lapply to for the std deviation and mean by subject and activity type

clean <- data.table(clean)
tidydata <- clean[, lapply(.SD, mean), by = 'Subject_ID,Activity_Type']
print(dim(tidydata))

write.table(tidydata,file="Tidy.txt",row.names = FALSE)
