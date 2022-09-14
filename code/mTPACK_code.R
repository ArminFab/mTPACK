# libraries

library(tidyverse)
library(rio)
library(dplyr)

# data import

data_sosci <- rio::import("data_TPACK_Studie_2022-07-29_10-12.xlsx")  # raw-data from Sosci

data_coding_TPACK <- rio::import("TPACK_Kodierung_ab1307.xlsx")    # raw-data from coding TPACK

# merge the two raw data sets by "CASE"

data_merged <- merge(data_sosci, data_coding_TPACK, by = "CASE")

