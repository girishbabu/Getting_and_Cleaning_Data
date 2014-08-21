This is the codebook for the Peer Assignment of the Getting & Cleaning Data Coursera Program.
It explains how the run_analysis.R script functions.

Facts
=====
Source of data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The actual data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Pre-requisites
==============
1. Download the source data (mentioned above) and extract in the working directory of R.
2. Rename the unzipped folder to 'uci_data'.

Details of the script
=====================
Read 'X_train.txt', 'Y_train.txt' & 'subject_train.txt' from 'uci_data/data/train/' directory.
|
 --> Read 'X_test.txt', 'Y_test.txt' & 'subject_test.txt' from 'uci_data/data/test/' directory.
   |
    --> Concatenate both data frames, along with labels to produce joined_subject.
      |
       --> From 'uci_data/data/features.txt', extract the mean & SD measurements.
         |
          --> Clean to remove '()' and '-' symbols, and make 'M' (of mean) & 'S' (of std).
            |
             --> Flush the 'cleaned_data' frame to 'merged_data.txt'.
               |
                --> Generate another tidy data set of activity & subject measurements, and flush to 'data_with_means.txt'.

