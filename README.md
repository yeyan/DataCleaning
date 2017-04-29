# Instructions

### Dependencies

The following packages must be installed to be able to run the script:
    
 * files
 * unzip
 * dplyr

### Behavior

The script will check if there is a directory named 'UCI HAR Dataset' avaiable in current working directory. If the directory does not exist then the script will try to unpack it from a zip file named `data.zip` in current working directory. If `data.zip` does not exist either it will try to download it from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

After process data set described by step 5 will be saved with write.table and row.names=False into a text file named 'result.txt'.
