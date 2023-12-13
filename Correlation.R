# Install and load the corrplot package
library(corrplot)
library(png)
library(dplyr)
library(tidyverse)

#Read input file
OP_comp <- read_csv("derived_data/OP_utilization.csv");
# Correlation matrix

# Calculate the correlation matrix
correlation_matrix <- cor(OP_comp)

# Create a correlation plot
corrplot(correlation_matrix, method = "color", addrect = 2)

# Save the corrplot image into a png file
png("figures/corrplot_image.png", width=480, height=480)
corrplot(correlation_matrix, method = "color")
dev.off()