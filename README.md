# 🏠 Home Loan Predictions

**Author:** Daniel Tae  
**Date:** March 5, 2025

## 📌 Project Overview

This project aims to streamline the home loan approval process using machine learning models. The manual loan approval process is often inefficient and time-consuming. By training classification models on historical applicant data, we can help automate decision-making and improve efficiency in financial institutions.

## ❓ Business Problem

Financial institutions often face delays and inconsistencies in approving loans due to manual processes. The goal of this project is to build predictive models that determine whether an applicant should be approved for a loan, based on various features such as income, credit history, education, and employment status.

## 📊 Dataset

The dataset includes 367 records and 12 features, including:

- **Categorical variables**: `Gender`, `Married`, `Dependents`, `Education`, `Self_Employed`, `Property_Area`
- **Numerical variables**: `ApplicantIncomeMonthly`, `CoapplicantIncomeMonthly`, `LoanAmountThousands`, `Loan_Amount_Term_Months`, `Credit_History`
- **Target variable** (created): `Loan_Status` (Approved / Not Approved)

## 🧼 Data Preparation

- Handled missing values in `Credit_History`, `LoanAmountThousands`, and `Loan_Amount_Term_Months` using imputation.
- Created a synthetic binary target variable `Loan_Status`.
- Converted categorical variables to factors.
- Scaled numeric features for logistic regression.
- Split the dataset into training (70%) and testing (30%).

## 📈 Exploratory Data Analysis (EDA)

- Histogram of applicant income distribution
- Bar plot showing loan status proportion by credit history
- Correlation matrix of numerical variables using `GGally`

## 🤖 Models Used

### 1. Logistic Regression
- Accuracy: **~16.4%**
- Struggled due to linear separability and imbalanced data
- Low predictive power for real-world use

### 2. Random Forest
- Accuracy: **~90.9%**
- Strong performance in both sensitivity and specificity
- Highlighted the most influential features with feature importance plot

## ✅ Conclusion

The Random Forest model greatly outperformed the logistic regression model, making it more suitable for deployment in loan approval automation. This project demonstrates how machine learning can enhance efficiency and consistency in financial decision-making.

## 📁 Repository Contents

- `Home_Loan_Predictions.Rmd` – R Markdown file containing the full code and analysis
- `Home_Loan_Predictions.html` – Rendered HTML report
- `Test_Loan_Home.csv` – Sample dataset used in the analysis
- `README.md` – Project summary and documentation (this file)

## 🔧 Dependencies

This project uses R (version 4.4.x) and the following packages:

```r
install.packages(c("tidyverse", "caret", "randomForest", "caTools", "e1071", "GGally"))
