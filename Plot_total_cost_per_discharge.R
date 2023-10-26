library(tidyverse)
library(dplyr)
library(ggplot2)
library(scales)

#Reading our input datasets
IP_Geo <- read_csv("derived_data/In-patient_Geo.csv");
OP_Geo <- read_csv("derived_data/Out-patient_Geo.csv");

OP_Complete <- OP_Geo %>% 
  filter(complete.cases(Avg_Tot_Sbmtd_Chrgs))%>% 
  group_by(Region5,Year) %>% mutate(Avg_Paymt = mean(Avg_Tot_Sbmtd_Chrgs))

#Now let's look into the dataset even further and check the average charges billed to Medicare per discharge event

IP_perdisc <- IP_Geo %>% 
  group_by(Region5,Year) %>% 
  mutate(Avg_Paymt_disc = mean(sum(Avg_Submtd_Cvrd_Chrg)/sum(Tot_Dschrgs)))

OP_perdisc <- OP_Complete %>% 
  group_by(Region5,Year) %>% 
  mutate(Avg_Paymt_disc = mean(sum(Avg_Tot_Sbmtd_Chrgs)/sum(CAPC_Srvcs)))

## Plotting IP and OP curve for total amount per discharge

#Plotting for line graph 
region_plot <- function(data,subtitle){
  IP1 <- filter(data.frame(data),Rndrng_Prvdr_Geo_Lvl == "State") %>%
    arrange(Region5,Year);

  plot <- ggplot(data = IP1, aes(x = Year, y = Avg_Paymt_disc, color = Region5)) +
  geom_line() +  # Line plot
  scale_y_continuous(labels = dollar_format()) +
  labs(title = "Time Series Plot for average cost per discharge over the years 2016-2021 by region",
       subtitle = subtitle,
       x = "Year",
       y = "Average Cost Incurred for services provided per discharge")+
  theme(plot.title = element_text(size = 10),
        plot.subtitle=element_text(size=9),
        axis.title.y = element_text(size = 8))  # Adjust text size here

  print(plot)
}

IP_disc <- region_plot(IP_perdisc,subtitle="In-patient records");
ggsave("figures/total_cost_perdisc_IP.png",IP_disc);

OP_disc <- region_plot(OP_perdisc,subtitle="Out-patient records");
ggsave("figures/total_cost_perdisc_OP.png",OP_disc);