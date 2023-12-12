# Compiling and Loading all required libraries

library(tidyverse)
library(dplyr)

## Reading in the Out-patient files from 2016-2021

OP_16 <- read_csv("Data source/Out-patient/MUP_OHP_R19_P04_V40_D16_GEO.CSV",show_col_types = FALSE);
OP_17 <- read_csv("Data source/Out-patient/MUP_OHP_R19_P04_V40_D17_GEO.CSV",show_col_types = FALSE);
OP_18 <- read_csv("Data source/Out-patient/MUP_OHP_R20_P04_V10_D18_GEO.CSV",show_col_types = FALSE);
OP_19 <- read_csv("Data source/Out-patient/MUP_OUT_RY21_P04_V10_DY19_GEO.CSV",show_col_types = FALSE);
OP_20 <- read_csv("Data source/Out-patient/MUP_OUT_RY22_P04_V10_DY20_GEO.CSV",show_col_types = FALSE);
OP_21 <- read_csv("Data source/Out-patient/MUP_OUT_RY23_P04_V10_DY21_GEO.CSV",show_col_types = FALSE);

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

OP <- Bind(OP_16,OP_17,OP_18,OP_19,OP_20,OP_21) %>% 
  filter(Srvc_Lvl == "APC") %>%
  mutate(Rndrng_Prvdr_Geo_Cd = as.numeric(Rndrng_Prvdr_Geo_Cd));

write_csv(OP, "derived_data/Out-patient.csv");
