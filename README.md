# README #

## GetData-005 Submission Overview ##

This git repository contains:

* GetDataCourseProject.R
  R Studio Project file containing the working environment
* [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
  Data set drawn from the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
* run_analysis.R
  R Script which performs the loading, merging, grouping, aggregation and exporting of the cleansed data set.
  A detailed description is detailed below
* cleanseddata folder
  Contains ouput.csv the cleansed data set who's schema is described in CodeBook.md
  
## run_analysis.R Overview ##

1. Loads in the required library reshape2 which is required for the functions melt and dcast.
2. Defines the operating directory for the source data.
3. Imports the common tables Activity and Features (note: *features requires transposing for later use.*)
4. Imports both Train and Test data sets using the following routine.
  * Reads the Train/Test feature values from X
  * Sets the column names using the transposed features table
  * Imports the Train/Test subjects
  * Imports the Train/Test activities, column binding them onto the subjects
  * Column binds the feature data to the subject and activity data
5. Combines the completed Train and Test data frames top and bottom
6. Using a grep for mean() and std() drops the unwanted columns
7. Substitutes the activity_id in the combined set by looking up the activity in the activities table and renames column.
8. Create a melted data set around subject and activity
9. DCast the melted data set with subject and activity as variables and aggregate function mean
10. Write the newly cleansed data set out to output.csv in cleanseddata folder


