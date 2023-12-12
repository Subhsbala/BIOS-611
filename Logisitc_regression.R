# Logistic Regression
# Load libraries
library(tidyverse)
library(stats)

# Read input file
OP_util <- read_csv("derived_data/OP_utilization.csv",show_col_types = FALSE)

# Fit logistic regression model
glm_model <- glm(formula = utilization ~ obese + falls + pop + white +  
                   hispanic + avg_chrg + avg_allowed + 
                   avg_pymt + avg_outlier + Year + income,
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
plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)
legend("bottomright", legend = paste("AUC =", round(auc_value, 3)), col = "blue", lwd = 2)

# Calculate precision-recall curve
pr_curve <- pr.curve(OP_util$utilization, predictions)

# Plot the precision-recall curve
plot(pr_curve, main = "Precision-Recall Curve", col = "red", lwd = 2)

