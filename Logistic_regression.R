# Logistic Regression
# Load libraries
library(tidyverse)
library(stats)

# Read input file
OP_util <- read_csv("derived_data/OP_utilization.csv");

#Normalize the variables before performing the glm model
normalize_cols <- c("obese", "falls", "pop", "white", "hispanic", "black", "asian", "hawai",
                    "avg_chrg", "avg_allowed", "avg_pymt", "Year", "income")

# normalize the data using the scale() function
OP_util[, normalize_cols] <- scale(OP_util[, normalize_cols])

# Fit logistic regression model
glm_model <- glm(formula = utilization ~ obese + falls + pop + white + black + hawai + asian + 
                  hispanic + avg_chrg + Year + income,
                 data = OP_util, 
                 family = "binomial")

# View model summary
summary(glm_model) 

# Make predictions
predictions <- predict(glm_model, type = "response") 

# Create a confusion matrix
conf_matrix <- table(OP_util$utilization, ifelse(predictions > 0.5, 1, 0))
print(conf_matrix)

# Calculate accuracy, sensitivity, and specificity
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
sensitivity <- conf_matrix[2, 2] / sum(conf_matrix[2, ])
specificity <- conf_matrix[1, 1] / sum(conf_matrix[1, ])

cat("Accuracy:", accuracy, "\n")
cat("Sensitivity:", sensitivity, "\n")
cat("Specificity:", specificity, "\n")

# Install the pROC package (if not installed)
if (!requireNamespace("pROC", quietly = TRUE)) {
  install.packages("pROC")
}

# Load the pROC package
library(pROC)

# Create a ROC curve
roc_curve <- roc(OP_util$utilization, predictions)
auc_value <- auc(roc_curve)

# Plot the ROC curve
png("figures/ROC_curve.png", width = 800, height = 600, res = 72)
plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)
legend("bottomright", legend = paste("AUC =", round(auc_value, 3)), col = "blue", lwd = 2)

dev.off()
