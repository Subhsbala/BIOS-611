# Compiling and Loading all required libraries

library(tidyverse)
library(dplyr)

## Reading in the In-patient files from 2016-2021
IP_16 <- read_csv("Data source/In-patient/MUP_IHP_RY23_P03_V10_DY16_GEO.CSV",show_col_types = FALSE);
IP_17 <- read_csv("Data source/In-patient/MUP_IHP_RY23_P03_V10_DY17_GEO.CSV",show_col_types = FALSE);
IP_18 <- read_csv("Data source/In-patient/MUP_IHP_RY23_P03_V10_DY18_GEO.CSV",show_col_types = FALSE);
IP_19 <- read_csv("Data source/In-patient/MUP_IHP_RY23_P03_V10_DY19_GEO.CSV",show_col_types = FALSE);
IP_20 <- read_csv("Data source/In-patient/MUP_IHP_RY23_P03_V10_DY20_GEO.CSV",show_col_types = FALSE);
IP_21 <- read_csv("Data source/In-patient/MUP_IHP_RY23_P03_V10_DY21_GEO.CSV",show_col_types = FALSE);

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

IP <- Bind(IP_16,IP_17,IP_18,IP_19,IP_20,IP_21);

write_csv(IP, "derived_data/In-patient.csv");

