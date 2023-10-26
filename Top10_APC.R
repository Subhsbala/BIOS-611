library(tidyverse)
library(dplyr)
library(ggplot2)
library(scales)
library(lubridate)

#Reading our input datasets
IP_Geo <- read_csv("derived_data/In-patient_Geo.csv");
OP_Geo <- read_csv("derived_data/Out-patient_Geo.csv");

OP_Complete <- OP_Geo %>% 
  filter(complete.cases(Avg_Tot_Sbmtd_Chrgs))%>% 
  group_by(Region5,Year) %>% mutate(Avg_Paymt = mean(Avg_Tot_Sbmtd_Chrgs))

#Getting the top 10 APC services provided for each year

# Calculate Total Services for each Year and APC_Desc
OP_apc <- OP_Complete %>%
  group_by(Year, APC_Desc) %>%
  mutate(Tot_Srvcs = sum(CAPC_Srvcs)) %>%
  distinct(Year, APC_Desc, Tot_Srvcs) %>%
  arrange(Year,desc(Tot_Srvcs))


# Get the first 10 rows for each year
top_10_year <- OP_apc %>%
  group_by(Year) %>%
  slice_head(n = 10)

# Create the bar plot
OP_apc_plot <- ggplot(top_10_year, aes(x = APC_Desc, y = Tot_Srvcs)) +
  geom_bar(stat = 'identity', position = 'dodge', aes(fill=as.factor(Year))) +
  scale_y_continuous(labels = comma_format()) +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Top 10 APC Description by Total Services for Each Year",
       x = "APC Description",
       y = "Total Services")+
  theme(plot.title = element_text(size = 10),
        plot.subtitle=element_text(size=9),
        axis.text.x = element_text(size=5))  # Adjust text size here

print(OP_apc_plot);

ggsave("figures/Top10_APC.png",OP_apc_plot);
