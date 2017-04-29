# Instructions

### Dependencies

The following packages must be installed to be able to run the script:
    
 * files
 * unzip
 * dplyr

### Behavior

The script will check if there is a directory named 'UCI HAR Dataset' avaiable in current working directory. If the directory does not exist then the script will try to unpack it from a zip file named `data.zip` in current working directory. If `data.zip` does not exist either it will try to download it from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`

The script then will try to read the following files in `UCI HAR Dataset` directory:

```
./UCI HAR Dataset/features.txt                       -- Used to extract meaningful variable names
./UCI HAR Dataset/activity_labels.txt                -- Used to convert actity variable from numeric to factor
./UCI HAR Dataset/test/X_test.txt                    -- Test data sensor variables
./UCI HAR Dataset/test/y_test.txt                    -- Test data actitity variable 
./UCI HAR Dataset/test/subject_test.txt              -- Test data subject variable
./UCI HAR Dataset/train/X_train.txt                  -- Train data sensor variables
./UCI HAR Dataset/train/y_train.txt                  -- Train data actitity variable
./UCI HAR Dataset/train/subject_train.txt            -- Train data subject variable
```

Sensor variables and activity variables are combined using rbind, test data and train data are combined using rbind.

The merged data is processed by grouping activity and subject then summarize using mean on each variable, then sorted by Activity and Subject.

After process data set described by step 5 will be saved with write.table and row.names=False into a text file named `result.txt`.
