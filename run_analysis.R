## Course Project, Getting and Cleaning Data
## Username: keslingmj
## Script_Name: run_analysis.R

library(plyr)
library(dplyr)


## check if this script is correctly located relative to "UCI..." directory:
files <- dir()
flag <- length(unique(sort(grepl("UCI\ HAR\ Dataset", files))))
if(flag != 2){
      print("The run_analysis.R script must be located in the same directory as the UCI\ HAR\ Dataset directory")     
}


## STEP 1: Read in files, merge into a single data frame "df":
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

## The resulting data frame "df" is [10,299 x 563] 



## STEP 2: Sub-set the columns to only include those having
## mean() or std() in the name:
varLogical <- grepl("(*mean\\(|*std\\()", varNames)
varLogical[1] <- TRUE; varLogical[2] <- TRUE #keeping 1st 2 cols
colSubset <- df[,varLogical]
## The resulting colSubset data frame is [10299 x 68]

## STEP 3: Make Activity names human-readable
colSubset$Activity <- as.character(colSubset$Activity)
colSubset$Activity[colSubset$Activity == "1"] <- "WALKING"
colSubset$Activity[colSubset$Activity == "2"] <- "WALKING_UPSTAIRS"
colSubset$Activity[colSubset$Activity == "3"] <- "WALKING_DOWNSTAIRS"
colSubset$Activity[colSubset$Activity == "4"] <- "SITTING"
colSubset$Activity[colSubset$Activity == "5"] <- "STANDING"
colSubset$Activity[colSubset$Activity == "6"] <- "LAYING"
colSubset$Activity <- as.factor(colSubset$Activity) 


## STEP 4: Clean up the 66 Variable Names
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



## STEP 5: Calculate Mean across replicates for each of 66 remaining movement 
## variables for each Subject, Activity pair

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


TIDY <- calc_avg(colSubset, newColNames)
View(TIDY)
write.table(TIDY, file="./tidy_dataset.txt", sep=" ", row.name=FALSE)



