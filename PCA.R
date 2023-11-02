library(tidyverse)

#Read in the dataset
OP_JOIN <- read_csv("derived_data/OP_wide.csv")
OP_Geo <-read_csv("derived_data/Out-patient_Geo.csv")

#Creating Region to classify East from west states
OP_Geo$Region2 <- ifelse(OP_Geo$Region5 %in% c("Northeast", "Southeast"), "East", "West")

## PCA Analysis
# Creating base dataset with only non missing varying variables
OP_PCA <- OP_JOIN %>%
  #filter(Year == 2018) %>%
  select(where(~!all(is.na(.)))) %>%
  mutate(across(everything(), ~ifelse(is.na(.), 0, .)))

OP_matrix <- OP_PCA %>%
  select(-Countyfips) %>%
  as.matrix()

# Checking if columns don't have missing values
colSums(is.na(OP_matrix));

# Performing PCA
results <- prcomp(OP_matrix, scale=TRUE);
results$x;

PCA_table <- results$x %>% as_tibble();

# Joining dataset with Region to color code
OP_PCA_R <- OP_PCA %>%
  inner_join(OP_Geo %>%
               select(Rndrng_Prvdr_Geo_Cd,Rndrng_Prvdr_Geo_Desc,Region5,Region2) %>%
               distinct() %>%
               mutate(Rndrng_Prvdr_Geo_Cd = as.numeric(Rndrng_Prvdr_Geo_Cd)),
             by=c("Rndrng_Prvdr_Geo_Cd")) %>%
  select(c(1,2,3,57,58,59))

OP_Color <- cbind(OP_PCA_R,PCA_table)

# Plotting the PC1 across PC2 colored by Region2
ggplot(OP_Color,aes(PC1,PC2,color=Region2)) +
  geom_point();

ggsave("figures/PCA_Region2.png")

# Plotting the PC1 across PC2 colored by Year
ggplot(OP_Color,aes(PC1,PC2,color=Year)) +
  geom_point();

ggsave('figures/PCA_Year.png')

# Variance explained
variance <- results$sdev^2 / sum(results$sdev^2) 

# Plot variance explained

# Create a data frame for the variance values
variance_data <- data.frame(
  PC = 1:length(variance),
  VarianceExplained = variance
)

# Create the ggplot visualization
ggplot(variance_data, aes(x = PC, y = VarianceExplained)) +
  geom_line() +
  geom_point() +
  labs(
    x = "Principal Component",
    y = "Variance Explained",
    title = "Variance Explained by Principal Component"
  ) +
  ylim(0, 1)

ggsave("figures/PCA.png")

# Select PCs to retain 
# e.g. retain PCs explaining 80% variance
cumsum(variance) < 0.80 

# Extract selected PCs
OP_SELECT <- results$x[,1:5]
