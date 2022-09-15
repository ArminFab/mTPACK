# libraries

library(tidyverse)
library(rio)
library(dplyr)
library(naniar)  # missing pattern visualization


# data import
data_sosci <- rio::import("data\\data_TPACK_Studie_2022-07-29_10-12.xlsx")  # raw-data from Sosci
data_coding_TPACK <- rio::import("data\\TPACK_Kodierung_ab1307.xlsx")    # raw-data from coding TPACK

# merge the two raw data sets by "CASE"
data_merged <- merge(data_sosci, data_coding_TPACK, by = "CASE")


################## data cleaning #############################


# remove last row (as it depicts headers)
data_merged <- slice(data_merged, 1: (n()) - 1)


# Gender: String -> numeric (1=weiblich, 2=männlich, 3=divers)
data_merged$GEN <- as.numeric(data_merged$GEN)

# Removing SERIAL, REF as they have only missings
data_merged <- data_merged[ , !names(data_merged) %in% c("SERIAL", "REF")]

# Removing participants that did not finish the sosci survey
data <- filter(data_merged, data_merged$FINISHED == "1")

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

