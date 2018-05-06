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
  
  tmp_df <- data.frame(data_table)
  colnames(tmp_df) <- col_names
  tmp_df[,"Class"==1] <- "Positive"
  tmp_df[,"Class"==0] <- "Negative"
  
  return(tmp_df)
}

#Growing the tree without Subject_id and UPDRS field so as to not bias by external scores
#Passing the train df without Subject_id and UPDRS and then 
#defining class as a function that takes into account everything else
grow_and_prune_tree <- function(data_frame, split_type, prune_best){
  
  tmp_tree <- tree(Class ~., data = data_frame, split = split_type )
  tmp_tree <- prune.misclass(tmp_tree, best = prune_best)
  summary(parkinsons_tree1)
  
  return(tmp_tree)
}

calculate_accuracy <- function(){
  
}