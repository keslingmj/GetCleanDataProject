## GetCleanDataProject
Holds Data for Evaluating the Coursera Getting and Cleaning Data Project

This document describes:
* how to run the program run_analysis.R,
* how to view the results of that program
* the process by which the tidy dataset was created

The purpose of this project is to start with the raw data from the Human
Activity Recognition Project using Smartphone Data from the University
of Genova, and from that, create a tidy dataset having merged their training
data and their test data.

The dataset was downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and decompressed, which creates a primary directory called "UCI\ HAR\ Dataset"
in which all data files and folders reside.


The script merges the data from the Training Set and the Test Set.  It
should be noted that the data that reside in the "Inertial Signals/"
folders were not used in the creation of this tidy dataset.  Not all
columns that had the string 'mean' or 'std' were kept.  Only those
ending with 'mean()' or 'std()' were kept.  Thus, there are 66 and not
79?  data-fields (plus a Subject field and Activity field).  From
those 66 movement variables, a mean was calculated for each Subject,
Activity pair.  These means are what appear in the Tidy Dataset.


In order to evaluate my run_analysis.R script and to evaluate my tidy dataset,
you should:

1. In RStudio, go to the directory THAT HOLDS your copy of "UCI HAR Dataset"
   directory.  Note that you are not going to the "UCI HAR Dataset" directory,
   but rather its parent directory.  You can use setwd() command or by using
   Session -> Set Working Directory -> Choose Directory

2. In RStudio, create new R script, copy the run_analysis.R script from my 
   GitHub repository (keslingmj/GetCleanDataProject), paste it into RStudio,
   and save it as run_analysis_keslingmj.R so that it does not interfere
   with other copies of this script.

3. Execute script in RStudio: Code -> Source
   It is assumed that both the "plyr" and "dplyr" packages are installed

4. The script outputs 2 things:
       a. a file called "tidy_dataset.txt" which resides in the same directory
       	  as the run_analysis_keslingmj.R script
       b. a table in RStudio called TIDY.
   Both of these outputs contain the same tidy dataset, but it should be easier
   to read in the RStudio table.

5. If the reviewer (marker) is interested in reviewing data frames created
   part-way through the script, then from the RStudio command-line one should
   type: View(name_of_dataframe)

   Relevant data frames:
   	    df		entire merged dataframe (step 1): [10299 x 563]
	    		(step 1)
	    colSubset	subset of df that contained columns ENDING with
	    		mean() or std() (see above).  (step 2, 3, and 4)
	    TIDY	final product (step 5)


