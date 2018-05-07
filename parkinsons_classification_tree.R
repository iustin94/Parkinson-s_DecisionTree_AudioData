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

#Classification tree with Gini split
classification_tree_gini<- tree(Class~., train_df[,c(-1,-28)], split ="gini")
best_prune <- find_best_prune(classification_tree_gini, test_df)
classification_tree_gini<- prune.misclass(classification_tree_gini, best = best_prune)
summary(classification_tree_gini)
gini_split_classification <- predict(classification_tree_gini, test_df)

#Classification tree with Deviance split
classification_tree_deviance <- tree(Class~., train_df[,c(-1,-28)],split = "deviance")
best_prune <- find_best_prune(classification_tree_deviance, test_df)
classification_tree_deviance <- prune.misclass(classification_tree_deviance, best = best_prune)
summary(classification_tree_deviance)  
deviance_split_classification <- predict(classification_tree_deviance, test_df)

#Regression tree with Gini split
regression_tree_gini <- tree(UPDRS ~., train_df[,c(-1,-29)], split = "gini")
best_prune <- find_best_prune(regression_tree_gini, test_df)
regression_tree_gini <- prune.misclass(regression_tree_gini, best = best_prune)
summary(regression_tree_gini)
gini_split_regression <- predict(regression_tree_gini, test_df[-28])

#Regression tree with Deviance split
regression_tree_deviance <- tree(UPDRS ~., train_df[,c(-1,-29)], split = "deviance")
best_prune <- find_best_prune(regression_tree_gini, test_df)
regression_tree_deviance <- prune.tree(regression_tree_deviance, best = best_prune)
summary(regression_tree_deviance)
deviance_split_regression <- predict(regression_tree_deviance, test_df) 

#Calculate accuracy for Positive classification
gini_TP_accuracy <- calculate_accuracy(gini_split_classification[, "Positive"], test_df[])
deviance_TP_accuracy <- calculate_accuracy(deviance_split_classification[, "Positive"], test_df)

gini_TP_regression <- calculate_accuracy( gini_split_regression[,"Positive"], test_df)

#Calculate accuracy for Negative classifications  
gini_TN_accuracy <- calculate_accuracy(parkinsons_ginisplit[, "Negative"], test_df)
deviance_TN_accuracy <- calculate_accuracy(parkinsons_deviancesplit[, "Negative"], test_df)
  
  
  
  
  
  