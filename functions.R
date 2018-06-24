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

calculate_accuracy <- function(prediction, test_df){
  
  tmp_confusion_matrix <- table(test_df$Class, prediction )
  accuracy <- sum(diag(tmp_confusion_matrix))/sum(tmp_confusion_matrix)
  
  return(accuracy)
}

