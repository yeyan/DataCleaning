library(files, unzip)
library(dplyr)

get_data <- function() {
    # If folder UCI HAR Dataset does not exist then try to unpack it, 
    # if data.zip does not exist then download from supplied URI.
    if(!file.exists('UCI HAR Dataset')) {
        if(!file.exists('data.zip')) {
            download('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 'data.zip')
        }
        
        unzip('data.zip')
    }
}

load_data <-function() {
    # Loading Variable information
    #   Only keep names that mentioned mean() or std()
    #   () are removed and - is tranformed into . to construct descriptive variable names
    variable <- read.table('./UCI HAR Dataset/features.txt', 
                           header=F, colClasses=c("integer", "character"), col.names=c('Index', 'Name')) %>%
        filter(grepl('mean\\(\\)|std\\(\\)', Name)) %>%
        mutate(Name=gsub('-', '.', sub('\\(\\)', '', Name)))

    # Load activity labels
    activity <- read.table('./UCI HAR Dataset/activity_labels.txt', 
                           header=F, colClasses=c('integer', 'character'), col.names=c('Index', 'Name'))

    # As the data set is seperated into two sets which are test and train, 
    # but the struct of those sets are resemblant.
    # As a result we only employee one function to read those set.
    read_set <- function(x_file, y_file, sub_file){

        # read all variables collected from phone 
        x <- read.table(x_file, head=FALSE) %>% 
            tbl_df %>%
            select(variable$Index) %>%
            setNames(variable$Name)

        # read activity (manually labeled)
        y <- read.table(y_file, head=FALSE) %>%
            tbl_df %>% 
            setNames(c('Activity')) %>%
            mutate(Activity=factor(Activity, labels=activity$Name))

        # read subject
        subject <- read.table(sub_file, 
                              header=F, 
                              colClasses=c('factor'), 
                              col.names=c('Subject')) %>% 
            tbl_df

        cbind(x, y, subject) %>% tbl_df
    }

    # load test data
    test_data <- read_set('./UCI HAR Dataset/test/X_test.txt', 
                          './UCI HAR Dataset/test/y_test.txt', 
                          './UCI HAR Dataset/test/subject_test.txt')

    # load train data
    train_data <- read_set('./UCI HAR Dataset/train/X_train.txt',
                           './UCI HAR Dataset/train/y_train.txt',
                           './UCI HAR Dataset/train/subject_train.txt')

    # merge those dataframes
    rbind(test_data, train_data) %>% tbl_df
}

# Download and unpack data
get_data()

# Load and clean data
df <- load_data()

write.table(names(df), file='CodeBook.txt', row.names=F)

# Prepare another DataFrame memtioned in requirement 6
another_df <- df %>% 
    group_by(Activity, Subject) %>%
    summarize_each(funs(mean)) %>%
    arrange(Activity, Subject)

# Write the aggregated data to disk as required
write.table(another_df, file='result.txt', row.names=FALSE)
