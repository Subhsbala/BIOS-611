library(dplyr)

# Read in input files
OP_Musc <- read_csv("derived_data/OP_Musculoskeletal")

# Calculate number of services received per beneficiary in each state
OP_region <- OP_Musc %>% 
  filter(complete.cases(CAPC_Srvcs,MDCR_BENES))%>% 
  group_by(Year, Region5) %>% 
  summarize(srvc_per_bene = sum(CAPC_Srvcs)*1000/sum(MDCR_BENES), .groups = "drop")


# Plotting bar graph
region_plot <- function(data){
  IP1 <- filter(data.frame(data)) %>%
    arrange(Region5);

  plot <- ggplot(data = IP1, aes(x = Year, y = srvc_per_bene,color=Region5)) +
    geom_line() +  # Specify stat = "identity" for actual values
    labs(title = "Time sereis graph for no. of services per 1000 beneficiaries",
         subtitle = paste("Out-patient records"),
         x = "Year",
         y = "Number of services provided per 1000 beneficiary") +
    theme(axis.text.x = element_text(angle = 90)) +
    theme(plot.title = element_text(size = 10),
          plot.subtitle = element_text(size = 9),
          axis.title.y = element_text(size = 8))  # Adjust text size here
  
  print(plot)
}

# Try doing the whole thing by region to see anything odd 

OP_reg <- region_plot(OP_region)
ggsave("figures/service_per_bene_OP.png",OP_reg);
