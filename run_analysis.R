## Course Project, Getting and Cleaning Data
## Username: keslingmj
## Script_Name: run_analysis.R

## to do: make warnings if they don't have the necessary packages
## installed.

files <- dir()
flag <- length(unique(sort(grepl("UCI\ HAR\ Dataset", files))))
if(flag != 2){
      print("The run_analysis.R script must be located in the same directory as the UCI\ HAR\ Dataset directory")     
}

## include read.table(fileName); View(tidy_dataset) command s.t.
## markers can see my table in Rstudio very easily.

## Need to output tidy data to file

## Files and What is in them:
## ./UCI\ HAR\ Dataset/
      # activity_labels.txt
      # README.txt
      #features_info.txt
      #features.txt
      #test/
            #Inertial Signals
            #subject_test.txt
            #X_test.txt
            #y_test.txt
      #train/
            #Inertial Signals
            #subject_test.txt
            #X_test.txt
            #y_test.txt    

# Each vector is a 561-element numerical vector.  There are 7352 rows
# in X_train, each having a 561-element vector
# X_test has 2947 rows, each having a 561-element vector.
# X_... lacks a header row.  This will come from features.txt, which
# has 561 rows with one word each corresponding to the headers in X_...

# features_info.txt explains what the headers in features.txt are

# train/subject_train.txt has 21 different subjects (people) who
# had data collected on them.  This file is simply 1 column with 7352
# rows, which is the same number of rows as in the X_train data

# train/y_train.txt is very similar to subject_train.txt, but the labels
# refer not to subjects, but rather to the 6 activities the people
# engaged in. It also has 7352 lines.  Just what these activities are
# is enumerated in activity_labels.txt

# test/y_test.txt and /subject_test.txt both had 2947 lines.
# subject_test.txt had 9 subjects that did not overlap with the training
# set

# train/Inertial Signals/*.txt has 9 files, each with 7352 lines and
# 128 columns.  I don't know what these 128 columns are.
# INERTIAL DATA NOT INCLUDED -- DAVID HOOD

# The final file is a tidy dataset with 1 column per variable:
# I'm currently not sure if I'm pulling data from the Inertial direct-y
# Each subject/activity is a unique pair (30 x 6 = 180), however,
# there are a total of 7352 + 2947 = 10,299 lines in the X_... files
# which does not add up.  First I need to see if there is redundancy
# in subject-activity pair(s)

# Yes, there is redundancy, so they are talking about mean / std for
# all replicates of each subject/activity pair.  Not sure about
# all columns, which would be 561.  NO, David Hood says explicity that
# we're dealing with mean (not std) of only the 66 (or 79 if you choose) that
# end with mean/std.

# subject
# activity: want to put this in words
# 1 tBodyAcc-mean()-X
# 2 tBodyAcc-mean()-Y
# 3 tBodyAcc-mean()-Z
# 4 tBodyAcc-std()-X
# 5 tBodyAcc-std()-Y
# 6 tBodyAcc-std()-Z
# 41 tGravityAcc-mean()-X
# 42 tGravityAcc-mean()-Y
# 43 tGravityAcc-mean()-Z
# 44 tGravityAcc-std()-X
# 45 tGravityAcc-std()-Y
# 46 tGravityAcc-std()-Z
#81 tBodyAccJerk-mean()-X
#82 tBodyAccJerk-mean()-Y
#83 tBodyAccJerk-mean()-Z
#84 tBodyAccJerk-std()-X
#85 tBodyAccJerk-std()-Y
#86 tBodyAccJerk-std()-Z
#121 tBodyGyro-mean()-X
#122 tBodyGyro-mean()-Y
#123 tBodyGyro-mean()-Z
#124 tBodyGyro-std()-X
#125 tBodyGyro-std()-Y
#126 tBodyGyro-std()-Z
#161 tBodyGyroJerk-mean()-X
#162 tBodyGyroJerk-mean()-Y
#163 tBodyGyroJerk-mean()-Z
#164 tBodyGyroJerk-std()-X
#165 tBodyGyroJerk-std()-Y
#166 tBodyGyroJerk-std()-Z
#201 tBodyAccMag-mean()
#202 tBodyAccMag-std()
#214 tGravityAccMag-mean()
#215 tGravityAccMag-std()
#227 tBodyAccJerkMag-mean()
#228 tBodyAccJerkMag-std()
#240 tBodyGyroMag-mean()
#241 tBodyGyroMag-std()
#253 tBodyGyroJerkMag-mean()
#254 tBodyGyroJerkMag-std()
#266 fBodyAcc-mean()-X
#267 fBodyAcc-mean()-Y
#268 fBodyAcc-mean()-Z
#269 fBodyAcc-std()-X
#270 fBodyAcc-std()-Y
#271 fBodyAcc-std()-Z
#345 fBodyAccJerk-mean()-X
#346 fBodyAccJerk-mean()-Y
#347 fBodyAccJerk-mean()-Z
#348 fBodyAccJerk-std()-X
#349 fBodyAccJerk-std()-Y
#350 fBodyAccJerk-std()-Z
#424 fBodyGyro-mean()-X
#425 fBodyGyro-mean()-Y
#426 fBodyGyro-mean()-Z
#427 fBodyGyro-std()-X
#428 fBodyGyro-std()-Y
#429 fBodyGyro-std()-Z
#503 fBodyAccMag-mean()
#504 fBodyAccMag-std()
#516 fBodyBodyAccJerkMag-mean()
#517 fBodyBodyAccJerkMag-std()
#529 fBodyBodyGyroMag-mean()
#530 fBodyBodyGyroMag-std()
#542 fBodyBodyGyroJerkMag-mean()
#543 fBodyBodyGyroJerkMag-std()

library(plyr)
library(dplyr)

#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, destfile= "/Users/mjk/coursera/get_clean_data/dataset.zip", method = "curl")

# dirInfo <- dir().  Do something here that gives warning if script
# not placed in same directory as UCI HAR Dataset

## I'm going to do something quick here to see about replicates.
txt <- c("Subject","Activity")
tmp<- read.table("./UCI HAR Dataset/features.txt")
txt2 <- as.character(tmp$V2)
varNames <- c(txt, txt2)

xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
subjTmp <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjTrain <- as.character(subjTmp$V1)
subjTmp2 <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjTest <- as.character(subjTmp2$V1)
activTmp <- read.table("./UCI HAR Dataset/train/y_train.txt")
activTrain <- as.character(activTmp$V1)
activTmp2 <- read.table("./UCI HAR Dataset/test/y_test.txt")
activTest <- as.character(activTmp2$V1)
actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

subj <- c(subjTrain, subjTest)
activ <- c(activTrain, activTest)
x <- rbind(xTrain, xTest)

df <- cbind(subj, activ, x)
colnames(df) <- varNames

## AT this point, I have confirmed that my 10,299 x 563 data.frame
## has the full dataset, and that there are 180 unique subj/activity
## combinations

## so Step 1 is finished

## can use write.table(df, file="./testFile) to output & test with unix

## Now to sub-set the columns to only include those having
## mean() or std() in the name:
varLogical <- grepl("(*mean\\(|*std\\()", varNames)
varLogical[1] <- TRUE; varLogical[2] <- TRUE #keeping 1st 2 cols

colSubset <- df[,varLogical]

## step 2 done
colSubset$Activity <- as.character(colSubset$Activity)
colSubset$Activity[colSubset$Activity == "1"] <- "WALKING"
colSubset$Activity[colSubset$Activity == "2"] <- "WALKING_UPSTAIRS"
colSubset$Activity[colSubset$Activity == "3"] <- "WALKING_DOWNSTAIRS"
colSubset$Activity[colSubset$Activity == "4"] <- "SITTING"
colSubset$Activity[colSubset$Activity == "5"] <- "STANDING"
colSubset$Activity[colSubset$Activity == "6"] <- "LAYING"
colSubset$Activity <- as.factor(colSubset$Activity)  # not sure if needed

#step 3 done.  
#step 4: I'm going to clean up the "() in each col name
colNames <- colnames(colSubset)
newColNames <- vector("character", length = 0)
for(i in colNames){
      i2 <- gsub("\\(\\)","",i)
      i3 <- gsub("\\-", "_", i2) 
      i4 <- gsub("mean", "MEAN", i3) 
      j <- gsub("std","STD", i4)
      newColNames <- c(newColNames, j)
}
colnames(colSubset) <- newColNames

#step 4 done
# STEP 5

library(plyr)
library(dplyr)

calc_avg <- function(colSubset, newColNames){
      df_final <- data.frame()
      k <- 0
      for(i in newColNames){
            if(grepl("Subject", i)){
                  next
            }
            if(grepl("Activity", i)){
                  next
            }
            rslt <- colSubset %>% group_by(Subject, Activity) %>% summarise_each(funs(mean), matches(i))
            newCol <- rslt[3]
            
            if(k != 0){
                  df_final <- cbind(df_final, newCol) 
            }
            if(k == 0){
                  df_final <- rslt
                  k <- k + 1
            }
      }
      return(df_final)
}


df_FINAL <- calc_avg(colSubset, newColNames)
View(df_FINAL)





#cbind(df_final, rslt[[3]], deparse.level = 1, stringsAsFactors = TRUE)
#cbind(df_final, rslt[3])
#      string <- newColNames[i]
#      ddply(colSubset, .(Subject, Activity), plyr::summarise, 
#val=mean(as.numeric(x)))  
#            (string) = mean(string))

# had to use plyr::summarise due to Hmisc::summarize being higher priority
# than plyr::ddply in search() list in Rstudio
#new2 <- ddply(colSubset, .(Subject, Activity), 
     # vect_mean(colSubset$"tBodyAcc-mean-X"))
# previous problem was within "summarize" within ddply, not with ddply
# itself.  I followed advice at:
# http://stackoverflow.com/questions/12927468/parameterize-ddply-in-r
#tbl <- tbl_df(df)