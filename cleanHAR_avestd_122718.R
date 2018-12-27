
###############################################################################################################
##Course project for data cleaning course
##12/27/18

##DOWNLOAD DATA
getwd()
setwd("C:/Users/rnowak/Documents/Coursera/datacleaningcourse/HARfinal")
library(downloader)
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, dest="HAR.zip")
unzip("HAR.zip")
dir()
setwd("C:/Users/rnowak/Documents/Coursera/datacleaningcourse/HARfinal/UCI HAR Dataset")
dir()
list.files("./train")
list.files("./test")

##IMPORT TRAINING AND TEST DATA AND LABEL
library(plyr)

xtrain<-read.table("train/X_train.txt")
xtest<-read.table("test/X_test.txt")
x<-rbind(xtrain, xtest)
features<-read.table("features.txt")
names(x)<-features[,2]
mean_std<-grep("-mean\\(\\)|-std\\(\\)", features[,2])
X_sub<-x[,mean_std]


ytrain<-read.table("train/y_train.txt")
ytest<-read.table("test/y_test.txt")
y<-rbind(ytrain, ytest)
activities<-read.table("activity_labels.txt")
activities[,2]=gsub("_", "", tolower(as.character(activities[,2])))
y[,1]=activities[y[,1],2]
names(y)<-"activity"

subjtrain<-read.table("train/subject_train.txt", col.names=c("subject"))
subjtest<-read.table("test/subject_test.txt", col.names=c("subject"))
subject<-rbind(subjtrain, subjtest)

##CREATE MASTER DATASET
HARsub<-cbind(subject, y, X_sub)
write.table(HARsub, "merged_subsetted_HAR_WK4_122718.txt")

##SUBSET INDEPENDENT TIDY DATA WITH AVERAGE FOR EACH VARIABLE
HARsubave<-aggregate(. ~subject + activity, HARsub, mean)
HARsubave<-HARsubave[order(HARsubave$subject, HARsubave$activity),]
write.table(HARsubave, file="merged_subset_ave_HAR_Wk4_122718.txt", row.name=FALSE)
