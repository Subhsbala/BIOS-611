library(tidyverse)

#Importing external dataset

# Age and Sex
AGE_SEX <- read_csv("Data Source/Pop_by_Age_Sex.csv",show_col_types = FALSE) %>%
  select(c(1,3,8));

# Race 
RACE <- read_csv("Data Source/Pop_by_Race.csv",show_col_types= FALSE) %>%
  select(c(1,3,13,14,15,16,17,18,19,20));

# Income
INCOME <- read_csv("Data Source/Pop_by_Income.csv",show_col_types = FALSE) %>%
  select(c(1,3,4)) %>%
  filter(Year != c(2020, 2021));

#Medicare Enrollees
ENROLL <- read_csv("Data Source/Medicare_Enrollees.csv",show_col_types = FALSE) %>%
  select(c(1,5,7,8,9)) %>%
  mutate(TOT_BENES = as.numeric(TOT_BENES)) %>%
  mutate(MDCR_BENES = as.numeric(ORGNL_MDCR_BENES)) ;

# Obesity
OBESITY <- read_csv("Data Source/BRFSS.csv",show_col_types = FALSE) %>%
  filter(Question == "Percent of adults aged 18 years and older who have obesity", 
         Age == "65 or older",
         YearStart > 2015) %>%
  select(c(1,11,29))%>%
  rename(Obesity=Data_Value);

# Death by fall
FALL <- read_csv("Data Source/Death_by_fall.csv",show_col_types = FALSE) %>%
  filter(Year > 2015) %>%
  mutate(Death_rate = as.numeric(Death_rate))

# Joining datasets

DEMO <- AGE_SEX %>%
  full_join(RACE, by = c("Statefips", "Year")) %>%
  full_join(INCOME, by = c("Statefips", "Year")) %>%
  full_join(ENROLL, by = c("Statefips" = "BENE_FIPS_CD", "Year"= "YEAR")) %>%
  full_join(OBESITY,by = c("Statefips" = "LocationID", "Year"= "YearStart")) %>%
  full_join(FALL, by = c("BENE_STATE_DESC" = "State", "Year" = "Year"))

#Writing datasets

write_csv(DEMO,"derived_data/Demographics.csv")
