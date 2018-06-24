# Parkinson's disease classification
# using voice samples in early diagnosed patients.
#
# Author: Iustinian Olaru
# Date: 06.052018
# Data set source :
# au
#
# Data set consists of a test file and a train file.
# Voice samples come from 20 PWP and 20 Healthy individuals.
# Each individual has 26 recorded voice samples of vouls, numbers, words and sentences.
#
# The following script attempts to train a classification tree to classify the
# test data into healty or pwp individuals.
required_packages <- c("rpart","tree", "rpart.plot")

for( p in required_packages ){
  if( p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
    print(paste("Installing ",p,"..."))
  }
  else{
    print(paste("Package ",p," already installed" ))
  }
  library(p, character.only = TRUE)
}

setwd("/home/iustinian/Documents/Parkinson_Multiple_Sound_Recording_Data/")
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
remove(test_data)
remove(train_data)  

train_df <- train_df[ , !(names(train_df) %in% c("Subject_id", "UPDRS"))]

#Rpart
tree<- rpart(Class~., data= train_df, method = "class")

prediction <- predict(tree, test_df, type = "class")

tmp_confusion_matrix <- table(test_df$Class, prediction )
accuracy <- 1- sum(diag(tmp_confusion_matrix))/sum(tmp_confusion_matrix)

#Prune tree based on xerror given by the cross validation analysis
pfit<- prune(tree, cp= tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"])

#Calculate accuracy
prediction <- predict(pfit, test_df, type="class")
tmp_confusion_matrix <- table(test_df$Class, prediction )
accuracy <-1- sum(diag(tmp_confusion_matrix))/sum(tmp_confusion_matrix)
