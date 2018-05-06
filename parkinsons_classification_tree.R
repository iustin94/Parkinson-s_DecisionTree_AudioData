# Parkinson's disease classification
# using voice samples in early diagnosed patients.
#
# Author: Iustinian Olaru
# Date: 06.052018
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
    print(paste("Installing ",p,"..."))
  }
  else{
    print(paste("Package ",p," already installed" ))
  }
  require(p)
}

setwd(".")
source("functions.R")

DEBUG <- TRUE

if(!DEBUG){
args = commandArgs(trailingOnly = false)

# Test if there is at least one argument: if not, return an error
if (length(args) == 2) {
    stop("At least one argument must be supplied (input file).n", call. = FALSE)
  } else if (length(args) == 2) {
    # default output file
    args[3] = "out.txt"
  }

  #Create dataframe acording to dataset specifications
  test_data <- read.csv(args[1], header = FALSE)
  train_data <- read.csv(args[2], header = FALSE)
}

#Lines for debugging, DELETE AFTER FINISH
test_data <-read.csv("data/test_data.txt",header = FALSE,sep = ",")
train_data <- read.csv("data/train_data.txt", header = FALSE,sep = ",")

  train_df <- preprocess_data(train_data, c_names_train)
  test_df <- preprocess_data(test_data, c_names_test)
  
  
  #Growing the tree without Subject_id and UPDRS field so as to not bias by external scores
  #Passing the train df without Subject_id and UPDRS and then 
  #defining class as a function that takes into account everything else
  parkinsons_tree1<- grow_and_prune_tree(train_df[,c(-1,-28)], split_type ="deviance", 8)
  parkinsons_tree2 <- grow_and_prune_tree(train_df[,c(-1)],split = "gini", 8)
     
  #Predict test data
  parkinsons_ginisplit <- predict(parkinsons_tree1, test_df[-1])
  parkinsons_deviancesplit <- predict(parkinsons_tree2, test_df[-1])
  
  #Confusion matrix
  confusion_matrix1 <- table(test_df$Class, parkinsons_ginisplit)
  confusion_matrix2 <- table(test_df$Class, parkinsons_deviancesplit)
  
  #Accuracy 
  accuracy_gini <- sum(diag(confusion_matrix1))/sum(confusion_matrix1)
  accuracy_deviance <- sum(diag(confusion_matrix2))/sum(confusion_matrix2)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  