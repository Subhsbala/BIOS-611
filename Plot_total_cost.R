library(tidyverse)
library(dplyr)
library(ggplot2)
library(scales)

#Reading our input datasets
OP_Geo <- read_csv("derived_data/Out-patient_Geo.csv");

## Getting the dataset ready for plotting
#Calculating the average of Total payment across the regions
OP_Complete <- OP_Geo %>% 
  filter(complete.cases(Avg_Tot_Sbmtd_Chrgs))%>% 
  group_by(Region5,Year) %>% mutate(Avg_Paymt = mean(Avg_Tot_Sbmtd_Chrgs))

## Plotting IP and OP curve for total average expenditure

#Plotting for line graph 
region_plot <- function(data,subtitle){
  IP1 <- filter(data.frame(data),Rndrng_Prvdr_Geo_Lvl == "State") %>%
    arrange(Region5,Year);
  
  plot <- ggplot(data = IP1, aes(x = Year, y = Avg_Paymt, color = Region5)) +
    geom_line() +  # Line plot
    scale_y_continuous(labels = dollar_format()) +
    labs(title = "Time Series Plot for total average cost over the years 2016-2021 by region",
         subtitle = subtitle,
         x = "Year",
         y = "Average Cost Incurred for services provided")+
    theme(plot.title = element_text(size = 10),plot.subtitle=element_text(size=9))  # Adjust title size here

  print(plot);
}

OP_Yr <- region_plot(OP_Complete,subtitle = "Out-patient records");
ggsave("figures/total_cost_OP.png",OP_Yr);