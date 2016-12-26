setwd("C:/Users/Rohit/Desktop/Data Science/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
columns= read.table("features.txt") #importing the variable names in R

setwd("C:/Users/Rohit/Desktop/Data Science/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train")
train = read.table("X_train.txt")  #Reading training set in R
colnames(train) = columns$V2       #Giving column names to training set
train$y = read.table("y_train.txt") #Reading activity index in R
train$subject = read.table("subject_train.txt") #Reading subject index in R
train$y = as.numeric(train$y[[1]])    #Converting activity index to numeric form
train$subject = as.numeric(train$subject[[1]])  #Converting subject index to numeric form

setwd("C:/Users/Rohit/Desktop/Data Science/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test")
test = read.table("X_test.txt")   #Reading testing set
colnames(test) = columns$V2      #Giving column names to testing set
test$y = read.table("y_test.txt")   #Reading activity Index to R
test$subject = read.table("subject_test.txt")   #Reading subject index to R
test$y = as.numeric(test$y[[1]])      #Converting activity index to numeric form
test$subject = as.numeric(test$subject[[1]])   #Converting subject index to numeric form

data = rbind(train, test)  #Merging the training and testing data

meanCols <- grep("[Mm]ean", colnames(data))  #Column numbers having 'mean'
stdCols <- grep("[Ss]td", colnames(data))    #Column numbers having 'std'

my_data <- data[, c(meanCols, stdCols)]     #Extracting the mean and std columns  
my_data$y = data$y                       #Adding activity index to extracted data
my_data$subject = data$subject           #Adding subject index to extracted data

setwd("C:/Users/Rohit/Desktop/Data Science/Coursera/Getting and Cleaning Data/UCI HAR Dataset")
activity <- read.table("activity_labels.txt", stringsAsFactors = FALSE) #Reading activity labels in R

for(i in 1:6){
  my_data$activity[c(my_data$y == activity$V1[i])] = activity$V2[i] #Naming the activities in data set
}

for (i in 1:30){                  #Creating tidy_data for each subject and each activity
  for(j in 1:6){
    if(nrow(subset(my_data, subject == i & y == j)) != 0){
      subset_data =  subset(my_data, subject == i & y == j)
      subset_data[1, c(1:86)] = colMeans(subset_data[, c(1:86)])
      if (!exists("tidy_data")){
        tidy_data = subset(subset_data[1, c(88, 89, c(1:86))])
      }
      tidy_data = rbind(tidy_data, subset(subset_data[1, c(88, 89, c(1:86))]))
    }
  }
}
tidy_data = tidy_data[c(2:nrow(tidy_data)), ]
write.table(tidy_data, "tidy data.txt", sep = ",")
