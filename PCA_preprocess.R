library(tidyverse)

#Reading in the dataset
OP_Geo <-read_csv("derived_data/Out-patient_Geo.csv")
wide_PRICE <-read_csv("derived_data/State_price.csv")
DEMO <-read_csv("derived_data/Demographics.csv")

# Removing Levels from APC Desc
OP_Geo$APC <- gsub("Level \\d+ ", "", OP_Geo$APC_Desc)

#Creating Region to classify East from west states
OP_Geo$Region2 <- ifelse(OP_Geo$Region5 %in% c("Northeast", "Southeast"), "East", "West")

# Creating dataset that is grouped by APC with average charges per group
OP1 <- OP_Geo %>%
  filter(Rndrng_Prvdr_Geo_Lvl == "State" & Srvc_Lvl == "APC") %>%
  group_by(Year, Rndrng_Prvdr_Geo_Cd,Rndrng_Prvdr_Geo_Desc, APC) %>%
  summarize(Avg_Chrgs = mean(Avg_Tot_Sbmtd_Chrgs, na.rm = TRUE), .groups = "keep") %>%
  distinct(Year,Rndrng_Prvdr_Geo_Cd,Rndrng_Prvdr_Geo_Desc, APC, Avg_Chrgs) %>%
  arrange(Year,Rndrng_Prvdr_Geo_Cd, desc(Avg_Chrgs))

# Creating wide format for OP dataset
OP_wide <- OP1 %>%
  select(Rndrng_Prvdr_Geo_Cd,Rndrng_Prvdr_Geo_Desc, APC,Year,Avg_Chrgs) %>%
  pivot_wider(id_cols=c(Year,Rndrng_Prvdr_Geo_Cd,Rndrng_Prvdr_Geo_Desc),
              names_from = APC, 
              values_from = Avg_Chrgs)

# Joining dataset with external factors
OP_JOIN <- OP_wide %>%
  mutate(Rndrng_Prvdr_Geo_Cd = as.numeric(Rndrng_Prvdr_Geo_Cd)) %>%
  left_join(wide_PRICE, by = c("Rndrng_Prvdr_Geo_Cd" = "Geo_code", "Year" = "Year")) %>%
  left_join(DEMO, by = c("Rndrng_Prvdr_Geo_Cd" = "Statefips", "Year" = "Year")) %>%
  ungroup() %>%
  select(-Rndrng_Prvdr_Geo_Desc);

# Write dataset
write_csv(OP_JOIN,"derived_data/OP_wide.csv")