Studies have shown that early Parkinson's disease
can be observed by analyzing the natural connected 
speech of an individual. By using the raw audio
and processed audio data in 
http://archive.ics.uci.edu/ml/datasets/Parkinson+Speech+Dataset+with++Multiple+Types+of+Sound+Recordings
this script aims to train a classification or regression
tree capable of identifying patiens with diagnosed Parkinson's disease.:

For this mini experiment, I chose to apply a decision tree algorithm to identify patients that are likelly to be diagnosed with Parkinson's disease.﻿﻿﻿﻿﻿﻿﻿﻿﻿
The data set that I used was provided at http://archive.ics.uci.edu/ml/datasets/Parkinson+Speech+Dataset+with++Multiple+Types+of+Sound+Recordings.
The data consists of a training set and a data set. It's structure is describe at the download link. Some preprocessing was necessary such as defining the column names and switching the labeling so that the decission tree could be applied to it.
The numbers in the set represent audio biomarkers for each patient's voice recordings and a final label indicating weather or not the subject was diagnosed with parkinson's disease. Another column in the training set represented a score to the subjects voice patterns attributed by a trained professional in recognizing specific features. This made the data set ideal for applying a classification or a regression algorithm.
As a first attempt, I grew a tree with the standard R libraries "tree" and "rpart". As a splitting method for the nodes, I used both a gini split and a deviance based split to be able to compare the accuracy of the two approaches. 

Gini tree no pruning :
Classification tree:
tree(formula = Class ~ ., data = train_df[, c(-1, -28)], split = "gini")
Variables actually used in tree construction:
 [1] "Number_of_voice_breaks"              "Fraction_of_locally_unvoiced_frames" "Mean_pitch"                         
 [4] "Median_pitch"                        "Jitter_local"                        "Maximum_pitch"                      
 [7] "Standard_deviation_of_period"        "Mean_period"                         "Jitter_ppq5"                        
[10] "AC"                                  "Jitter_rap"                          "NTH"                                
[13] "Shimmer_apq5"                        "Number_of_pulses"                    "Shimmer_local_dB"                   
[16] "Shimmer_apq3"                        "Shimmer_apq11"                       "HTN"                                
[19] "Minimum_pitch"                       "Standard_deviation"                  "Shimmer_local"                      
[22] "Jitter_local_absolute"               "Degree_of_voice_breaks"             
Number of terminal nodes:  119 
Residual mean deviance:  0.5757 = 530.2 / 921 
Misclassification error rate: 0.1394 = 145 / 1040 


Deviance tree no pruning:
Classification tree:
tree(formula = Class ~ ., data = train_df[, c(-1, -28)], split = "deviance")
Variables actually used in tree construction:
[1] "Maximum_pitch"                       "Median_pitch"                        "Jitter_local_absolute"              
[4] "Fraction_of_locally_unvoiced_frames" "AC"                                  "Shimmer_apq11"                      
[7] "Shimmer_apq5"                        "HTN"                                
Number of terminal nodes:  11 
Residual mean deviance:  1.133 = 1166 / 1029 
Misclassification error rate: 0.3279 = 341 / 1040 

						To identify the most accurate prune on the tree, I ran a for loop for all the possible number of nodes the tree could have. For the Gini split tree, 

