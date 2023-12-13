# Load US state map data
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

states_map <- map_data("state")

# Read in input file
OP_Musc <- read_csv("derived_data/OP_Musculoskeletal.csv")

# Calculate number of services received per beneficiary in each state
OP_ser <- OP_Musc %>% 
  filter(complete.cases(CAPC_Srvcs,MDCR_BENES))%>% 
  group_by(Year, Rndrng_Prvdr_Geo_Desc) %>% 
  summarize(srvc_per_bene = sum(CAPC_Srvcs)*1000/sum(MDCR_BENES), .groups = "drop")

# Convert to lowercase
OP_ser$Rndrng_Prvdr_Geo_Desc <- tolower(OP_ser$Rndrng_Prvdr_Geo_Desc)

# Now join both the OP and maps dataset 
OP_ser_map <- left_join(states_map, OP_ser, 
                        by = c("region" = "Rndrng_Prvdr_Geo_Desc"))

map_region <- function(Yr){
  OP_map <- OP_ser_map %>%
    filter(Year == Yr);
  
  #Plot map
  plot <- ggplot(OP_map, aes(long, lat, group = group, fill = srvc_per_bene > 4)) +
    geom_polygon(color="white", size=0.1) + 
    labs(title = "Services per Beneficiary",
         subtitle = str_c("Outpatient Musculoskeletal Care - ", Yr),
         fill = "High utilization") +
    theme_minimal() +
    theme(plot.title = element_text(face="bold")) +
    scale_fill_manual(values = c("TRUE" = "blue", "FALSE" = "grey"))
  
  print(plot)
  ggsave(str_c("figures/services_USmap", Yr, ".png"), plot)
}

OP_map1 <- map_region(Yr=2016)
OP_map2 <- map_region(Yr=2017)
OP_map3 <- map_region(Yr=2018)
OP_map4 <- map_region(Yr=2019)
OP_map5 <- map_region(Yr=2020)
OP_map6 <- map_region(Yr=2021)

