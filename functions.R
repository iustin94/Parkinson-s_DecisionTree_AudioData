require(tree)

# It ain't pretty
c_names_train <- c("Subject_id","Jitter_local","Jitter_local_absolute","Jitter_rap",
  "Jitter_ppq5","Jitter_ddp","Shimmer_local","Shimmer_local_dB","Shimmer_apq3","Shimmer_apq5",
  "Shimmer_apq11","Shimmer_dda","AC","NTH","HTN","Median_pitch","Mean_pitch",
  "Standard_deviation","Minimum_pitch","Maximum_pitch","Number_of_pulses","Number_of_periods",
  "Mean_period","Standard_deviation_of_period","Fraction_of_locally_unvoiced_frames",
  "Number_of_voice_breaks","Degree_of_voice_breaks","UPDRS","Class"
)

c_names_test <- c("Subject_id","Jitter_local","Jitter_local_absolute","Jitter_rap",
  "Jitter_ppq5","Jitter_ddp","Shimmer_local","Shimmer_local_dB","Shimmer_apq3","Shimmer_apq5",
  "Shimmer_apq11","Shimmer_dda","AC","NTH","HTN","Median_pitch","Mean_pitch",
  "Standard_deviation","Minimum_pitch","Maximum_pitch","Number_of_pulses","Number_of_periods",
  "Mean_period","Standard_deviation_of_period","Fraction_of_locally_unvoiced_frames",
  "Number_of_voice_breaks","Degree_of_voice_breaks","Class"
)

#Process the data files into a data frame, adjust Class values to positive and negative
preprocess_data <- function(data_table, col_names){
  
  f <- factor(c("Positive", "Negative"))
  
  tmp_df <- data.frame(data_table)
  colnames(tmp_df) <- col_names
  
  tmp_df$Class[tmp_df$Class==1] <- "Positive"
  tmp_df$Class[tmp_df$Class==0] <- "Negative"
  tmp_df$Class <- as.factor(tmp_df$Class)
  
  
  return(tmp_df)
}

#Growing the tree without Subject_id and UPDRS field so as to not bias by external scores
#Passing the train df without Subject_id and UPDRS and then 
#defining class as a function that takes into account everything else
grow_and_prune_tree <- function(train_frame,test_frame, split_type){
  
  tmp_tree <- tree(Class ~. , data = data_frame, split = split_type )
  tmp_tree <- prune.misclass(tmp_tree, best = find_best_prune(tmp_tree, test_frame))
  return(tmp_tree)
}

calculate_accuracy <- function(prediction, test_df){
  
  tmp_confusion_matrix <- table(test_df$Class, prediction)
  accuracy <- sum(diag(tmp_confusion_matrix))/sum(tmp_confusion_matrix)
  
  return(accuracy)
}

tree_report <- function(tree, test_df, name){
  
  p<-predict(tree, test_df)
  
  jpeg("./reports/tree_plot%03d.jpeg")
  plot(tree)
  text(tree)
  title(tree)
  dev.off()
  
  sink("./reoprts/tree_report%03d.txt")
  print(summary(tree))
  print(paste("Accuracy:", calculate_accuracy(p, test_df)))
  sink()
}

find_best_prune<- function(tree, test_frame){
  
  tmp_tree <- tree
  best_prune <-0
  best_accuracy <- 0
  
  cv <- cv.tree(tmp_tree)
  for(i in cv$size[cv$size>1])
  {
    #Prune tree
    if(class(tree$y)=="factor"){
      tmp_tree <- prune.tree(tmp_tree, best = i)
      tmp_pred <- predict(tmp_tree, test_frame)
      acc <- calculate_accuracy(tmp_pred[,"Positive"], test_df)
    }
    else{
      tmp_tree <- prune.tree(tmp_tree, best = i, method = "deviance")
      tmp_pred <- predict(tmp_tree, test_frame)
      acc <- calculate_accuracy(tmp_pred, test_df)
    }
    
    #If better remember prune value
    if(acc > best_accuracy){
      best_accuracy <- acc
      best_prune <- i
    }
  }
  
  return(c(best_prune,best_accuracy))
}

