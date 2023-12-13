library(tidyverse)
library(dplyr)

# Joining base OP dataset with Demo dataset

# Read in input files
DEMO <- read_csv("derived_data/Demographics.csv",show_col_types = FALSE);
OP_Geo <- read_csv("derived_data/Out-patient_Geo.csv",show_col_types = FALSE);

OP_DEMO <- OP_Geo %>%
  left_join(DEMO, by = c("Rndrng_Prvdr_Geo_Cd" = "Statefips", "Year" = "Year")) %>%
  filter(Rndrng_Prvdr_Geo_Desc != "National");

# Filter dataset for one type of APC
OP_Musc <- OP_DEMO %>%
  filter(grepl("Musculoskeletal", APC_Desc, ignore.case = TRUE));

write_csv(OP_Musc,"derived_data/OP_Musculoskeletal.csv");