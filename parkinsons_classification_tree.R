# Parkinson's disease classification
# using voice samples in early diagnosed patients.
#
# Data set source :
# http://archive.ics.uci.edu/ml/datasets/Parkinson+Speech+Dataset+with++Multiple+Types+of+Sound+Recordings
#
# Data set consists of a test file and a train file.
# Voice samples come from 20 PWP and 20 Healthy individuals.
# Each individual has 26 recorded voice samples of vouls, numbers, words and sentences.
#
# The following script attempts to train a classification tree to classify the
# test data into healty or pwp individuals.
required_packages <- c("rpart","tree")

for( p in required_packages ){
  if( p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
  library(p)
}


args = commandArgs(trailingOnly = false)

# test if there is at least one argument: if not, return an error
if (length(args) == 2) {
  stop("At least one argument must be supplied (input file).n", call. = FALSE)
} else if (length(args) == 2) {
  # default output file
  args[3] = "out.txt"
}

#Set wd to current execution path
setwd(".")

#Create dataframe acording to dataset specifications
test_data <- read.csv(args[1], header = FALSE)
train_data <- read.csv(args[2], header = FALSE)

#Lines for debugging, DELETE AFTER FINISH
test_data <-
  read.csv(
    "Documents/Parkinson_Multiple_Sound_Recording_Data/test_data.txt",
    header = FALSE,
    sep = ","
  )
train_data <-
  read.csv(
    "Documents/Parkinson_Multiple_Sound_Recording_Data/train_data.txt",
    header = FALSE,
    sep = ","
  )

# It ain't pretty

c_names_train <- c(
  "Subject_id",
  "Jitter_local",
  "Jitter_local_absolute",
  "Jitter_rap",
  "Jitter_ppq5",
  "Jitter_ddp",
  "Shimmer_local",
  "Shimmer_local_dB",
  "Shimmer_apq3",
  "Shimmer_apq5",
  "Shimmer_apq11",
  "Shimmer_dda",
  "AC",
  "NTH",
  "HTN",
  "Median_pitch",
  "Mean_pitch",
  "Standard_deviation",
  "Minimum_pitch",
  "Maximum_pitch",
  "Number_of_pulses",
  "Number_of_periods",
  "Mean_period",
  "Standard_deviation_of_period",
  "Fraction_of_locally_unvoiced_frames",
  "Number_of_voice_breaks",
  "Degree_of_voice_breaks",
  "UPDRS",
  "Class"
)
  
c_names_test <- c(
  "Subject_id",
  "Jitter_local",
  "Jitter_local_absolute",
  "Jitter_rap",
  "Jitter_ppq5",
  "Jitter_ddp",
  "Shimmer_local",
  "Shimmer_local_dB",
  "Shimmer_apq3",
  "Shimmer_apq5",
  "Shimmer_apq11",
  "Shimmer_dda",
  "AC",
  "NTH",
  "HTN",
  "Median_pitch",
  "Mean_pitch",
  "Standard_deviation",
  "Minimum_pitch",
  "Maximum_pitch",
  "Number_of_pulses",
  "Number_of_periods",
  "Mean_period",
  "Standard_deviation_of_period",
  "Fraction_of_locally_unvoiced_frames",
  "Number_of_voice_breaks",
  "Degree_of_voice_breaks",
  "Class"
)

  train_df <- data.frame(train_data)
  colnames(train_df) <- c_names_train
  test_df[,"Class"==1] <- "Parkinsons"  

  test_df <- data.frame(test_data)
  colnames(test_df) <- c_names_test
  test_df[,"Class"==1] <- "Parkinsons"
  
  
  
  #Growing the tree without Subject_id and UPDRS field so as to not bias by external scores
  #Passing the train df without Subject_id and UPDRS and then 
  #defining class as a function that takes into account everything else
  
  parkinsons_tree1 <- tree(Class ~ . , data = train_df[,c(-1,-28)],split="deviance")
  summary(parkinsons_tree)      
  parkinsons_tree1 <- prune.misclass(parkinsons_tree1, best = 8 )
  
  parkinsons_tree2 <- tree(Class ~ . , data = train_df[,c(-1,-28)],split = "gini")
  summary(parkinsons_tree)      
  
  #Predict test data
  parkinsons_ginisplit <- predict(parkinsons_tree1, test_df[-1])
  parkinsons_deviancesplit <- predict(parkinsons_tree2, test_df[-1])
  
  #Confusion matrix
  confusion_matrix1 <- table(test_df$Class, parkinsons_ginisplit)
  confusion_matrix2 <- table(test_df$Class, parkinsons_deviancesplit)
  
  #Accuracy 
  accuracy_gini <- sum(diag(confusion_matrix1))/sum(confusion_matrix1)
  accuracy_deviance <- sum(diag(confusion_matrix2))/sum(confusion_matrix2)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  