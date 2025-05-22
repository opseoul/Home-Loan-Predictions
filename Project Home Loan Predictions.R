---
title: "Home Loan Predictions"
author: "Daniel Tae"
date: "2025-03-05"
output:
  html_document:
    df_print: paged
---


```{r}
# **1. Business Problem and Question**
## **Business Problem**
# The manual loan approval process is inefficient and time-consuming


# **2. Data Understanding and Preparation**
## **2.1 Load Required Libraries**

install.packages(c("caTools", "randomForest", "e1071", "GGally"), repos = "http://cran.rstudio.com/")

library(tidyverse)
library(caret)
library(randomForest)
library(caTools)
library(e1071)
library(GGally)



```
#Load data
```{r}

# Load dataset (update the path as necessary)
loan_data <- read.csv("Test_Loan_Home.csv", stringsAsFactors = TRUE)

# View first few rows
head(loan_data)

# Check structure
str(loan_data)

# Summary statistics
summary(loan_data)


# Summary statistics
summary(loan_data)

```

# Check for missing values
```{r}
# Count missing values in each column
colSums(is.na(loan_data))

```

# Data Cleaning
```{r}
# Impute missing values in Credit_History
loan_data$Credit_History[is.na(loan_data$Credit_History)] <- 1 

# Impute missing Loan Amount with median value
loan_data$LoanAmountThousands[is.na(loan_data$LoanAmountThousands)] <- 
  median(loan_data$LoanAmountThousands, na.rm = TRUE)

# Check data after imputation
summary(loan_data)

 # Find the most common loan term
most_common_term <- as.numeric(names(sort(table(loan_data$Loan_Amount_Term_Months), decreasing = TRUE)[1]))

# Fill missing Loan Term values with the most common value
loan_data$Loan_Amount_Term_Months[is.na(loan_data$Loan_Amount_Term_Months)] <- most_common_term

# Should have 0 Na's
colSums(is.na(loan_data))


```

# Encode Categorical Variables
```{r}
# Convert categorical variables to factors
loan_data$Gender <- as.factor(loan_data$Gender)
loan_data$Married <- as.factor(loan_data$Married)
loan_data$Self_Employed <- as.factor(loan_data$Self_Employed)
loan_data$Property_Area <- as.factor(loan_data$Property_Area)
loan_data$Credit_History <- as.factor(loan_data$Credit_History)

```

# Identify the Target variable
```{r}
# Create a synthetic Loan_Status variable
loan_data$Loan_Status <- ifelse(loan_data$Credit_History == 1 & 
                                  loan_data$ApplicantIncomeMonthly > 4000, 
                                "Approved", "Not Approved")
loan_data$Loan_Status <- as.factor(loan_data$Loan_Status)

# Check Loan_Status distribution
table(loan_data$Loan_Status)

```
# Exploratory Data Analysis
## Income distribution
```{r}
ggplot(loan_data, aes(x = ApplicantIncomeMonthly)) + 
  geom_histogram(fill = "blue", bins = 30) + 
  theme_minimal() +
  labs(title = "Distribution of Applicant Income", x = "Monthly Income", y = "Count")

```

## Credit History Impact on Loan status
```{r}
ggplot(loan_data, aes(x = Credit_History, fill = Loan_Status)) +
  geom_bar(position = "fill") +
  theme_minimal() +
  labs(title = "Loan Status by Credit History", x = "Credit History", y = "Proportion")

```

## Correlation Matrix
```{r}
ggpairs(loan_data %>% select(ApplicantIncomeMonthly, CoapplicantIncomeMonthly, LoanAmountThousands, Loan_Amount_Term_Months))

```

# Model Training and Evaluation
## Split Data for Training and Testing
```{r}
# Remove Loan_ID column
loan_data <- loan_data %>% select(-Loan_ID)

# Split data into training (70%) and testing (30%)
set.seed(123)
split <- sample.split(loan_data$Loan_Status, SplitRatio = 0.7)
train_data <- subset(loan_data, split == TRUE)
test_data <- subset(loan_data, split == FALSE)


```

## Logistic Regression
```{r}
# Standardize numeric columns
train_data$ApplicantIncomeMonthly <- scale(train_data$ApplicantIncomeMonthly)
train_data$CoapplicantIncomeMonthly <- scale(train_data$CoapplicantIncomeMonthly)
train_data$LoanAmountThousands <- scale(train_data$LoanAmountThousands)

test_data$ApplicantIncomeMonthly <- scale(test_data$ApplicantIncomeMonthly)
test_data$CoapplicantIncomeMonthly <- scale(test_data$CoapplicantIncomeMonthly)
test_data$LoanAmountThousands <- scale(test_data$LoanAmountThousands)

# Re-run the model
logistic_model <- glm(Loan_Status ~ ., data = train_data, family = "binomial")


# Train Logistic Regression model
logistic_model <- glm(Loan_Status ~ . -Credit_History, data = train_data, family = "binomial")


# Make Predictions
logistic_preds <- predict(logistic_model, test_data, type = "response")
test_data$Predicted_Status <- ifelse(logistic_preds > 0.5, "Approved", "Not Approved")

# Convert to factor
test_data$Predicted_Status <- as.factor(test_data$Predicted_Status)

# Model Evaluation
logistic_cm <- confusionMatrix(test_data$Predicted_Status, test_data$Loan_Status)
logistic_cm

```

## Random Forest Model
```{r}
# Train Random Forest model
rf_model <- randomForest(Loan_Status ~ ., data = train_data, ntree = 500, mtry = 3)

# Make Predictions
rf_preds <- predict(rf_model, test_data)

# Model Evaluation
rf_cm <- confusionMatrix(rf_preds, test_data$Loan_Status)
rf_cm



```

## Feature Importance
```{r}
varImpPlot(rf_model)

```

