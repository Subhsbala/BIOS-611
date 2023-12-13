#Load libraries
library(tidyverse)
library(dplyr)

# Read input file
OP_Musc <- read_csv("derived_data/OP_Musculoskeletal.csv");

# Calculate number of services received per beneficiary in each state
OP_log <- OP_Musc %>% 
  filter(Year < 2020) %>%
  filter(complete.cases(CAPC_Srvcs,MDCR_BENES))%>% 
  group_by(Year, Rndrng_Prvdr_Geo_Cd) %>% 
  summarize(srvc_per_bene = sum(CAPC_Srvcs)*1000/sum(MDCR_BENES), 
            avg_chrg = mean(Avg_Tot_Sbmtd_Chrgs),
            avg_allowed = mean(Avg_Mdcr_Alowd_Amt),
            avg_pymt = mean(Avg_Mdcr_Pymt_Amt),
            #avg_outlier = mean(Outlier_Srvcs),
            hispanic =  mean(`Hispanic %`),
            asian = mean(`Asian %`),
            white = mean(`White %`),
            black = mean(`Balck %`),
            hawai = mean(`Hawiian %`),
            pop = mean(`Pop 65+ %`),
            income = mean(`BEA Per Capita Personal Income`),
            obese = mean(Obesity),
            falls = mean(Death_rate), .groups = "drop")

# Check for missingness
missing_count <- colSums(is.na(OP_log))
print(missing_count)

#Remove rows with missing data
OP_comp <- OP_log %>% na.omit(obese);

# Create variable for utilization status
OP_util <- OP_log %>%
  mutate(utilization = case_when(
    srvc_per_bene > 4 ~ 1,
    TRUE ~ 0  )) %>%
  na.omit(obese)

write_csv(OP_util,"derived_data/OP_utilization.csv");