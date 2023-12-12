library(tidyverse)
library(dplyr)

## Regrouping states to Regions

region <- function(data){
  data %>% 
    mutate(REGION = case_when( # add a 'region' column, based on the state,
      Rndrng_Prvdr_Geo_Desc %in% c('Illinois', 'Indiana', 'Michigan', 'Ohio', 'Wisconsin') ~ 'East Midwest',
      Rndrng_Prvdr_Geo_Desc %in% c('Minnesota', 'Iowa', 'Missouri', 'Kansas', 'Nebraska', 'South Dakota', 'North Dakota') ~ 'West Midwest',
      Rndrng_Prvdr_Geo_Desc %in% c('Colorado', 'Idaho', 'Montana', 'Wyoming','Utah', 'Nevada') ~ 'Mountain',
      Rndrng_Prvdr_Geo_Desc %in% c('Massachusetts', 'Maine', 'New Hampshire', 'Rhode Island', 'Vermont') ~ 'New England',
      Rndrng_Prvdr_Geo_Desc %in% c('New York', 'Pennsylvania', 'Connecticut', 'New Jersey') ~ 'Middle Atlantic',
      Rndrng_Prvdr_Geo_Desc %in% c('Georgia', 'North Carolina', 'South Carolina', 'Florida','Virginia','West Virginia','Delaware','Maryland','District of Columbia') ~ 'South Atlantic',
      Rndrng_Prvdr_Geo_Desc %in% c('Texas', 'Oklahoma','New Mexico','Arizona') ~ 'Southwest',
      Rndrng_Prvdr_Geo_Desc %in% c('Alabama', 'Kentucky','Mississippi','Tennessee','Arkansas','Louisiana') ~ 'Southeast',
      Rndrng_Prvdr_Geo_Desc %in% c('California', 'Oregon', 'Washington','Hawaii','Alaska') ~ 'Pacific'
    )
    ) %>% 
    mutate(Region5 = case_when(
      REGION %in% c('Pacific','Mountain') ~ 'West',
      REGION %in% c('Southeast', 'South Atlantic') ~ 'Southeast',
      REGION %in% c('Southwest') ~ 'Southwest',
      REGION %in% c('West Midwest','East Midwest') ~ 'Midwest',
      REGION %in% c('Middle Atlantic','New England') ~ 'Northeast'
    )
    )
}


OP <- read_csv("derived_data/Out-patient.csv");

OP_Geo <- region(OP);

write_csv(OP_Geo,"derived_data/Out-patient_Geo.csv");

