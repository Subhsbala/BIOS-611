library(tidyverse)

#Importing external dataset

PRICE <- read_csv("Data Source/state_stdprices.csv");
AGE_SEX <- read_csv("Data Source/Pop_by_Age_Sex.csv");
RACE <- read_csv("Data Source/Pop_by_Race.csv");
INCOME <- read_csv("Data Source/Pop_by_Income.csv");

# Joining datasets

DEMO <- AGE_SEX %>%
  full_join(RACE, by = c("Statefips", "Countyfips", "Year")) %>%
  full_join(INCOME, by = c("Statefips", "Countyfips", "Year"))

#Converting to wide format

wide_PRICE <- PRICE %>%
  filter(cohort_web_label == "Reimbursements") %>%
  distinct(Geo_code, Year,Population, Short_label, Adjusted_Rate) %>%
  select(Geo_code, Year, Population, Short_label, Adjusted_Rate) %>%
  pivot_wider(names_from = Short_label, values_from = Adjusted_Rate) %>%
  mutate(Geo_code = as.numeric(Geo_code));

#Writing datasets

write_csv(DEMO,"derived_data/Demographics.csv")
write_csv(wide_PRICE,"derived_data/State_price.csv")
