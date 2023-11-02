## Clustering
library(tidyverse)
library(factoextra)
library(cluster)
library(corrplot)

#Read in the dataset
OP_JOIN <- read_csv("derived_data/OP_wide.csv")

# Select the dataset of specific year
# Remove the Year and all NA columns
OP_cluster <- OP_JOIN %>%
  #filter(Year == 2018) %>%
  select(-Countyfips) %>% 
  ungroup() %>%
  #select(-Year) %>%
  select(where(~!all(is.na(.)))) %>%
  mutate(across(everything(), ~ifelse(is.na(.), 0, .)))

# Convert to matrix format
OP_cluster_matrix <- OP_cluster %>%
  as.matrix()

# Correlation matrix plot
corrplot(cor(OP_cluster), method = "number",
         type = "lower",tl.cex=0.2)

# K-means clustering
kmeans_fit <- kmeans(OP_cluster_matrix, 4, nstart = 25)

# Rejoin with original data
OP_ex1 <- cbind(OP_cluster, cluster = kmeans_fit$cluster)

# Plot the K-means cluster
cluster_plot <- fviz_cluster(kmeans_fit, data = OP_ex1,
                palette=c("red", "blue", "black", "darkgreen"),
                ellipse.type = "euclid",
                star.plot = T,
                repel = T,
                ggtheme = theme())

ggsave("figures/cluster_plot.png")
