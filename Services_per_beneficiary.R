library(dplyr)

# Read in input files
OP_Musc <- read_csv("derived_data/OP_Musculoskeletal.csv")


# Calculate number of services received per beneficiary in each state
OP_ser <- OP_Musc %>% 
  filter(complete.cases(CAPC_Srvcs,MDCR_BENES))%>% 
  group_by(Year, Rndrng_Prvdr_Geo_Desc) %>% 
  summarize(srvc_per_bene = sum(CAPC_Srvcs)*1000/sum(MDCR_BENES), .groups = "drop")


# Plotting bar graph
region_plot <- function(data, yr){
  IP1 <- filter(data.frame(data)) %>%
    filter(Year == yr)%>%
    arrange(Rndrng_Prvdr_Geo_Desc);
  
  # Reorder the State variable based on the Count variable in descending order
  IP1$Rndrng_Prvdr_Geo_Desc <- reorder(IP1$Rndrng_Prvdr_Geo_Desc, -IP1$srvc_per_bene)
  
  plot <- ggplot(data = IP1, aes(y = Rndrng_Prvdr_Geo_Desc, x = srvc_per_bene, fill = srvc_per_bene > 4)) +
    geom_bar(stat = "identity") +  # Specify stat = "identity" for actual values
    labs(title = "Bar graph for no. of services per 1000 beneficiaries",
         subtitle = paste("Out-patient records -", yr),
         y = "State",
         x = "Number of services provided per 1000 beneficiary") +
    scale_fill_manual(values = c("FALSE" = "lightgreen", "TRUE" = "darkred"), guide = "none") +  # Adjust colors
    theme(axis.text.x = element_text(angle = 90)) +
    theme(plot.title = element_text(size = 10),
          plot.subtitle = element_text(size = 9),
          axis.title.y = element_text(size = 8))  # Adjust text size here
  
  print(plot)
  ggsave(str_c("figures/service_per_bene_", yr, ".png"), plot)
}


# Try doing the whole thing by region to see anything odd 

OP_ser16 <- region_plot(OP_ser,yr=2016)
OP_ser17 <- region_plot(OP_ser,yr=2017)
OP_ser18 <- region_plot(OP_ser,yr=2018)
OP_ser19 <- region_plot(OP_ser,yr=2019)
OP_ser20 <- region_plot(OP_ser,yr=2020)
OP_ser21 <- region_plot(OP_ser,yr=2021)

