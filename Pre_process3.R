# Compiling and Loading all required libraries

library(tidyverse)
library(dplyr)

## Reading in the Part D Prescription Drug files from 2016-2021

PD_16 <- read_csv("Data source/Pat D Drug/MUP_DPR_RY21_P04_V10_DY16_GEO_0.CSV",show_col_types = FALSE);

#Converting character variables to numeric to match the format of other files

PD_17 <- read_csv("Data source/Pat D Drug/MUP_PTD_R19_P16_V10_D17_GEO.CSV",show_col_types = FALSE);
PD_17$Tot_Drug_Cst <- gsub("[$,]", "",PD_17$Tot_Drug_Cst)%>%  as.numeric();
PD_17$GE65_Tot_Drug_Cst <- gsub("[$,]", "",PD_17$GE65_Tot_Drug_Cst)%>%  as.numeric();
PD_17$LIS_Bene_Cst_Shr <- gsub("[$,]", "",PD_17$LIS_Bene_Cst_Shr)%>%  as.numeric();
PD_17$NonLIS_Bene_Cst_Shr <- gsub("[$,]", "",PD_17$NonLIS_Bene_Cst_Shr)%>%  as.numeric();

PD_18 <- read_csv("Data source/Pat D Drug/MUP_DPR_RY21_P04_V10_DY18_GEO.CSV",show_col_types = FALSE);
PD_19 <- read_csv("Data source/Pat D Drug/MUP_DPR_RY21_P04_V10_DY19_GEO.CSV",show_col_types = FALSE);
PD_20 <- read_csv("Data source/Pat D Drug/MUP_DPR_RY22_P04_V10_DY20_GEO.CSV",show_col_types = FALSE);
PD_21 <- read_csv("Data source/Pat D Drug/MUP_DPR_RY23_P04_V10_DY21_GEO.CSV",show_col_types = FALSE);

## Combine all the IP, OP and PD datasets along with the Year column
Bind <- function(data1,data2,data3,data4,data5,data6){
  bind_rows(
    data1 %>% mutate(Year = 2016),
    data2 %>% mutate(Year = 2017),
    data3 %>% mutate(Year = 2018),
    data4 %>% mutate(Year = 2019),
    data5 %>% mutate(Year = 2020),
    data6 %>% mutate(Year = 2021)
  )
}

PD <- Bind(PD_16,PD_17,PD_18,PD_19,PD_20,PD_21);

write_csv(PD, "derived_data/Part_D.csv");
