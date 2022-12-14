# libraries

library(tidyverse)
library(rio)
library(dplyr)
library(naniar)  # missing pattern visualization
library(psych)
library(lavaan) # sem
library(lavaanPlot) 
library(semPlot) # nice graphical representations of SEM


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

# Removing participants that did not finish the sosci survey OR gave consent
data <- filter(data_merged, data_merged$FINISHED == "1" & data_merged$IN03 == "1")


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

# Missing Values (NA) are specified as 0s 

data_TPACK[is.na(data_TPACK)] <- 0

# sumscores of TPACK
data_TPACK <- mutate(data_TPACK, TPACK_sum_scores = TPACK_1_SUMME+
                     TPACK_2_SUMME+
                     TPACK_3_SUMME+
                     TPACK_4_SUMME+
                     TPACK_5_SUMME+
                     TPACK_6_SUMME+
                     TPACK_7_SUMME+
                     TPACK_8_SUMME)

# self-reported TPACK ("SE_1", etc.) from chr to numeric


data$SE_1 <- as.numeric(data$SE_1)
data$SE_2 <- as.numeric(data$SE_2)
data$SE_3 <- as.numeric(data$SE_3)
data$SE_4 <- as.numeric(data$SE_4)
data$SE_5 <- as.numeric(data$SE_5)


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
# PCK_13: Answer is correct if == 14

# Information on correct TK-answers
# TK_spread_1 correct if ==1
# TK_spread_2 correct if ==1
# TK_spread_3 correct if ==4
# TK_spread_4 correct if == 1 
# TK_whiteboard_1 correct if == 2
# TK_whiteboard_2 correct if == 1
# TK_whiteboard_3 correct if == 3
# TK_collab_1   correct if == 2
# TK_collab_2   correct if == 1
# TK_present_1  correct if = 3
# TK_present_2    correct if == 2
# TK_present_3 correct if == 4
# TK_webbrowser correct if == 2








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
data$PCK_6a <- ifelse(data$PCK_6a == "1",1,0)
data$PCK_6b <- ifelse(data$PCK_6b == "1",1,0)
data$PCK_7a <- ifelse(data$PCK_7a == "2",1,0)
data$PCK_7b <- ifelse(data$PCK_7b == "1",1,0)
data$PCK_8a <- ifelse(data$PCK_8a == "2",1,0)
data$PCK_8b <- ifelse(data$PCK_8b == "1",1,0)
data$PCK_9  <- ifelse(data$PCK_9 == "1",1,0)
data$PCK_10a  <- ifelse(data$PCK_10a == "1",1,0)
data$PCK_10b <- ifelse(data$PCK_10b == "2",1,0)
data$PCK_10c  <- ifelse(data$PCK_10c == "2",1,0)
data$PCK_11a  <- ifelse(data$PCK_11a == "2",1,0)
data$PCK_11b  <- ifelse(data$PCK_11b == "3",1,0)
data$PCK_11c  <- ifelse(data$PCK_11c == "4",1,0)
data$PCK_11d  <- ifelse(data$PCK_11d == "1",1,0)
data$PCK_12   <- ifelse(data$PCK_12 == "3",1,0)
data$PCK_13  <- ifelse(data$PCK_13 == "14",1,0)

# Recoding each TK_Item to binary variables
data$TK_spread_1     <- ifelse(data$TK_spread_1 == "1",1,0)
data$TK_spread_2     <- ifelse(data$TK_spread_2 == "1",1,0)
data$TK_spread_3     <- ifelse(data$TK_spread_3 == "4",1,0)
data$TK_spread_4     <- ifelse(data$TK_spread_4 == "1",1,0)
data$TK_whiteboard_1 <- ifelse(data$TK_whiteboard_1 == "2",1,0)
data$TK_whiteboard_2 <- ifelse(data$TK_whiteboard_2 == "1",1,0)
data$TK_whiteboard_3 <- ifelse(data$TK_whiteboard_3 == "3",1,0)
data$TK_collab_1     <- ifelse(data$TK_collab_1 == "2",1,0)
data$TK_collab_2     <- ifelse(data$TK_collab_2 == "1",1,0)
data$TK_present_1    <- ifelse(data$TK_present_1 == "3",1,0)
data$TK_present_2    <- ifelse(data$TK_present_2 == "2",1,0)
data$TK_present_3    <- ifelse(data$TK_present_3 == "4",1,0)
data$TK_webbrowser   <- ifelse(data$TK_webbrowser == "2",1,0)

# df data_TK consisting of each TK_ item
data_TK <- select(data, TK_spread_1,    
                        TK_spread_2,
                        TK_spread_3,  
                        TK_spread_4,  
                        TK_whiteboard_1,
                        TK_whiteboard_2,
                        TK_whiteboard_3,
                        TK_collab_1,  
                        TK_collab_2,  
                        TK_present_1, 
                        TK_present_2, 
                        TK_present_3, 
                        TK_webbrowser)

# df containing each 26 PCK items
data_PCK <- select(data, PCK_1a, 
                         PCK_1b, 
                         PCK_1c, 
                         PCK_2a, 
                         PCK_2b, 
                         PCK_2c, 
                         PCK_3, 
                         PCK_5a, 
                         PCK_5b, 
                         PCK_5c, 
                         PCK_6a, 
                         PCK_6b, 
                         PCK_7a, 
                         PCK_7b, 
                         PCK_8a, 
                         PCK_8b, 
                         PCK_9,
                         PCK_10a,
                         PCK_10b,
                         PCK_10c,
                         PCK_11a,
                         PCK_11b,
                         PCK_11c,
                         PCK_11d,
                         PCK_12 ,
                         PCK_13)

######## CFA for TPACK & PCK ########

# creating dataframe including knowledge constructs (PCK and TPACK and TK variables)
data_TPACK <- mutate(data_TPACK, CASE= data$CASE)
data_PCK <- mutate(data_PCK, CASE=data$CASE)
data_TK <- mutate(data_TK, CASE=data$CASE)
data1 <- merge(data_TPACK, data_PCK, by = "CASE")
data_knowledge <-merge(data1, data_TK, by = "CASE")

###################### Deskriptiver ??berblick ??ber die Datan #################
summary(data_knowledge)




# Measurement model
mod1 <- 'TPACK =~ TPACK_1_SUMME+TPACK_2_SUMME+TPACK_3_SUMME+TPACK_4_SUMME+TPACK_5_SUMME+TPACK_6_SUMME+TPACK_7_SUMME+TPACK_8_SUMME
          PCK  =~ PCK_1a+PCK_1b+PCK_1c+PCK_2a+PCK_2b+PCK_2c+PCK_3+PCK_5a+PCK_5b+PCK_5c+PCK_6a+PCK_6b+PCK_7a+PCK_7b+PCK_8a+PCK_8b+PCK_9+PCK_10a+PCK_10b+PCK_10c+PCK_11a+PCK_11b+PCK_11c+PCK_11d+PCK_12+PCK_13
          TK   =~ TK_spread_1  + TK_spread_2+TK_spread_3+TK_spread_4+TK_whiteboard_1+TK_whiteboard_2+TK_whiteboard_3+TK_collab_1+TK_collab_2+TK_present_1+TK_present_2+TK_present_3+TK_webbrowser'


# fitting mod1
fit_mod1 <-cfa(mod1, data = data,                         # Model-Name siehe oben, Datensatz wie oben
                     estimator="MLR",
                     missing = "ML")                      # Spezifizierung des Sch?tzers und des Umgangs mit Missing Values     

# results
summary(fit_mod1, fit.measures=T, standardized=T, rsquare = TRUE)
lavaanPlot(model = fit_mod1, 
           node_options = list(shape = "box", fontname = "Helvetica"), 
           edge_options = list(color = "grey"), 
           coefs = T,covs = T, stars = T, stand = T)

############## SEM ####################

# model 2: TPACK ~ PCK + TK
mod2 <- 'TPACK =~ TPACK_1_SUMME+TPACK_2_SUMME+TPACK_3_SUMME+TPACK_4_SUMME+TPACK_5_SUMME+TPACK_6_SUMME+TPACK_7_SUMME+TPACK_8_SUMME
          PCK  =~ PCK_1a+PCK_1b+PCK_1c+PCK_2a+PCK_2b+PCK_2c+PCK_3+PCK_5a+PCK_5b+PCK_5c+PCK_6a+PCK_6b+PCK_7a+PCK_7b+PCK_8a+PCK_8b+PCK_9+PCK_10a+PCK_10b+PCK_10c+PCK_11a+PCK_11b+PCK_11c+PCK_11d+PCK_12+PCK_13
          TK   =~ TK_spread_1  + TK_spread_2+TK_spread_3+TK_spread_4+TK_whiteboard_1+TK_whiteboard_2+TK_whiteboard_3+TK_collab_1+TK_collab_2+TK_present_1+TK_present_2+TK_present_3+TK_webbrowser #measurment model
          TPACK ~ PCK + TK
          '
fit_mod2 <-sem(mod2, data = data,                         # Model-Name siehe oben, Datensatz wie oben
               estimator="MLR",
               missing = "ML") 

summary(fit_mod2, fit.measures=T, standardized=T, rsquare = TRUE)

# model 3: TPACK ~ SE
mod3 <- 'TPACK =~ TPACK_1_SUMME+TPACK_2_SUMME+TPACK_3_SUMME+TPACK_4_SUMME+TPACK_5_SUMME+TPACK_6_SUMME+TPACK_7_SUMME+TPACK_8_SUMME
          SE   =~ SE_1 + SE_2 + SE_3 + SE_4 + SE_5
          TPACK ~ SE
          '
fit_mod3 <-sem(mod3, data = data,                         # Model-Name siehe oben, Datensatz wie oben
               estimator="MLR",
               missing = "ML") 

#### model 4: TPACK ~ PCK ########
mod4 <- 'TPACK =~ TPACK_1_SUMME+TPACK_2_SUMME+TPACK_3_SUMME+TPACK_4_SUMME+TPACK_5_SUMME+TPACK_6_SUMME+TPACK_7_SUMME+TPACK_8_SUMME
            PCK  =~ PCK_1a+PCK_1b+PCK_1c+PCK_2a+PCK_2b+PCK_2c+PCK_3+PCK_5a+PCK_5b+PCK_5c+PCK_6a+PCK_6b+PCK_7a+PCK_7b+PCK_8a+PCK_8b+PCK_9+PCK_10a+PCK_10b+PCK_10c+PCK_11a+PCK_11b+PCK_11c+PCK_11d+PCK_12+PCK_13
            '

fit_mod4 <-cfa(mod4, data = data,                         # Model-Name siehe oben, Datensatz wie oben
               estimator="MLR",
               missing = "ML") 
