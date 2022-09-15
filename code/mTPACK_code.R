# libraries

library(tidyverse)
library(rio)
library(dplyr)
library(naniar)  # missing pattern visualization
library(psych)

# data import
data_sosci <- rio::import("data\\data_TPACK_Studie_2022-07-29_10-12.xlsx")  # raw-data from Sosci
data_coding_TPACK <- rio::import("data\\TPACK_Kodierung_ab1307.xlsx")    # raw-data from coding TPACK

# merge the two raw data sets by "CASE"
data_merged <- merge(data_sosci, data_coding_TPACK, by = "CASE")


################## inital data cleaning #############################


# remove last row (as it depicts headers)
data_merged <- slice(data_merged, 1: (n()) - 1)


# Gender: String -> numeric (1=female, 2=male, 3=diverse)
data_merged$GEN <- as.numeric(data_merged$GEN)

# Removing SERIAL, REF as they have  missings only
data_merged <- data_merged[ , !names(data_merged) %in% c("SERIAL", "REF")]

# Removing participants that did not finish the sosci survey
data <- filter(data_merged, data_merged$FINISHED == "1")



####### Preparing variables for analysis #################

################# TPACK ##################################

# Creating sum scores for TPACK_5, ... , TPACK_8
data <- mutate(data, TPACK_5_SUMME = TPACK_5_UQ + TPACK_5_POT + TPACK_5_EXPL,
                     TPACK_6_SUMME = TPACK_6_UQ + TPACK_6_POT + TPACK_6_EXPL,
                     TPACK_7_SUMME = TPACK_7_UQ + TPACK_7_POT + TPACK_7_EXPL,
                     TPACK_8_SUMME = TPACK_8_UQ + TPACK_8_POT + TPACK_8_EXPL)

# creating a df that contains TPACK-scores only
data_TPACK <- select(data, TPACK_1_SUMME,
                           TPACK_2_SUMME,
                           TPACK_3_SUMME,
                           TPACK_4_SUMME,
                           TPACK_5_SUMME,
                           TPACK_6_SUMME,
                           TPACK_7_SUMME,
                           TPACK_8_SUMME)

# Missing pattern visual
print(vis_miss(data_TPACK))

# correlations between TPACK items using FIML (library psych)
print (corFiml(data_TPACK, covar = FALSE,show=FALSE))

###################### PCK ###############################################

# Information on correctedness regarding the PCK items
# PCK_1a: Answer is correct if PCK_1a == 1
# PCK_1b: Answer is correct if PCK_1b == 2
# PCK_1c: Answer is correct if PCK_1c == 2
# PCK_2a: Answer is correct if == 2
# PCK_2b: Answer is correct if == 1
# PCK_2c: Answer is correct if == 3
# PCK_3: Answer is correct if == 2
# PCK_5a: Answer is correct if == 1
# PCK_5b: Answer is correct if == 2
# PCK_5c: Answer is correct if == 3
# PCK_6a: Answer is correct if == 1
# PCK_6b: Answer is correct if == 1
# PCK_7a: Answer is correct if == 2
# PCK_7a: Answer is correct if == 1
# PCK_8a: Answer is correct if == 2
# PCK_8b: Answer is correct if == 1
# PCK_9:  Answer is correct if == 1
# PCK_10a:  Answer is correct if == 1
# PCK_10b:  Answer is correct if == 2
# PCK_10c:  Answer is correct if == 2
# PCK_11a:  Answer is correct if == 2
# PCK_11b:  Answer is correct if == 3
# PCK_11c:  Answer is correct if == 4
# PCK_11d:  Answer is correct if == 1
# PCK_12: Answer is correct if == 3
# PCK_13: Answer is correct if == 2

# Recoding each PCK_item to binary variables (1, if the correct answer was given, 0 otherwise)

data$PCK_1a <- ifelse(data$PCK_1a == "1",1,0) # If PCK_1a was answered correctly, assign value 1; otherwise 0
data$PCK_1b <- ifelse(data$PCK_1b == "2",1,0) 
data$PCK_1c <- ifelse(data$PCK_1c == "2",1,0) 
data$PCK_2a <- ifelse(data$PCK_2a == "2",1,0)
data$PCK_2b <- ifelse(data$PCK_2b == "1",1,0) 
data$PCK_2c <- ifelse(data$PCK_2c == "3",1,0)
data$PCK_3  <- ifelse(data$PCK_3  == "2",1,0)
data$PCK_5a <- ifelse(data$PCK_5a == "1",1,0)
data$PCK_5b <- ifelse(data$PCK_5b == "2",1,0) 
data$PCK_5c <- ifelse(data$PCK_5c == "3",1,0)










