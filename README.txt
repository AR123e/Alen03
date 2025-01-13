Overview
This project involves cleaning, standardizing, and analyzing a dataset related to company layoffs. The dataset is stored in a MySQL database, and the operations performed are aimed at removing duplicates, standardizing the data, handling missing values, and performing exploratory data analysis (EDA).

Steps Performed
1. Setup
Created a staging table to work with the data without affecting the original dataset.
Copied the data from the original table into the staging table.

2. Remove Duplicates

Identified and removed duplicate rows based on key attributes such as company, location, industry, and date.
Ensured that only unique records remain for further analysis.

3. Data Standardization
Trimmed extra spaces and standardized text fields for consistency.
Harmonized industry names by grouping similar values (e.g., variations of "Crypto").
Cleaned country names to ensure uniformity (e.g., removed trailing characters like dots).
Converted date fields to a standard date format.

4. Handle Missing Values
Updated blank fields in critical columns (e.g., industry) by referencing other entries for the same company.
Removed rows where both total_laid_off and percentage_laid_off were null, as they provide no meaningful information.

5. Exploratory Data Analysis (EDA)
Analyzed the cleaned data to extract insights, such as:
Identifying the highest layoffs and percentages.
Aggregating layoffs by company, industry, country, and year.
Analyzing the timeline of layoffs and observing trends over months and years.
Ranking companies with the highest layoffs per year.

6. Rolling Totals
Calculated rolling totals of layoffs over time to observe cumulative trends.

Notes
Indexing was considered to enhance query performance during analysis.
The cleaned data ensures consistency and reliability for downstream tasks, including visualization and reporting.

Tools Used
Database: MySQL
Analysis: SQL queries for data transformation and insights extraction.

