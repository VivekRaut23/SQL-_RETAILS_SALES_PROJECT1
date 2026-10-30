# Retail Sales Analysis SQL Project

## Project Overview
This project demonstrates a comprehensive data analysis workflow using SQL to clean, explore, and analyze retail sales data. The dataset includes transactional records capturing customer demographics, purchasing patterns, item categories, and pricing details. The primary goal is to derive actionable business insights and answer key performance questions.

## Database & Table Setup
The project begins by setting up a dedicated schema and importing the raw data using the database wizard tool.
* **Database Created:** `SQL_Proj_1`
* **Target Table:** `Retail_sales`

```sql
-- Create Database
CREATE DATABASE SQL_Proj_1;
USE SQL_Proj_1;

-- Verify upload and check table structure
SELECT * FROM Retail_sales;
DESCRIBE Retail_sales;
SELECT COUNT(*) FROM Retail_sales; 
```

## Data Cleaning & Preparation
To ensure data integrity, the workflow includes strict checks for missing parameters and a standardized transformation of chronological formats.

### 1. Null Value Check
A query is structured to identify missing values across critical fields like transaction details, demographic info, and pricing columns:
```sql
SELECT * FROM Retail_sales
WHERE transactions_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;
```

### 2. Chronological Data Formatting
The raw date strings (formatted as DD-MM-YY) are converted into official SQL `DATE` objects permanently:
```sql
SET SQL_SAFE_UPDATES = 0;

UPDATE Retail_sales 
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%y');

ALTER TABLE Retail_sales 
MODIFY COLUMN sale_date DATE;

SET SQL_SAFE_UPDATES = 1;
```

## Exploratory Data Analysis (EDA)
Basic metrics are run to check the general volume and distribution of the records:
* **Total Records:** Verifies the full count of transactions.
* **Unique Customers:** Isolates the unique individual buyer base via `DISTINCT customer_id`.
* **Categories:** Counts the distinct structural groups of inventory sold.

## Business Key Problems & Analysis

### Q1: Specific Date Transactions
Retrieves all records for sales that took place on November 5, 2022.
```sql
SELECT * 
FROM Retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2: High-Volume Clothing Sales (Nov 2022)
Identifies larger transactions (quantity of 4 or higher) within the 'Clothing' industry specifically during November 2022.
```sql
SELECT * 
FROM Retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

### Q3: Total Financial Performance by Category
Calculates total gross revenue generated grouped by product categories, sorted from highest to lowest.
```sql
SELECT category, SUM(total_sale) AS Total_sales_by_Category  
FROM Retail_sales
GROUP BY category
ORDER BY Total_sales_by_Category DESC;
```

### Q4: Target Age Demographics for 'Beauty'
Finds the average rounded age of buyers spending money in the 'Beauty' sector.
```sql
SELECT category, ROUND(AVG(age)) AS Avg_Age  
FROM Retail_sales
WHERE category = 'Beauty';
```

### Q5: High-Value Transactions
Filters out all operational orders where the gross total exceeded $1000.
```sql
SELECT * FROM Retail_sales
WHERE total_sale > 1000;
```

### Q6: Transaction Volume by Category and Gender
Breaks down operational order counts across intersecting demographic groups (gender and category types).
```sql
SELECT category, gender, COUNT(transactions_id) AS total_transactions  
FROM Retail_sales
GROUP BY category, gender
ORDER BY total_transactions DESC;
```

### Q7: Peak Performance Months Per Year
Uses window functions (`RANK() OVER`) and subqueries to discover which month yielded the highest average sales for each separate calendar year.
```sql
SELECT year, month_name, avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        MONTHNAME(sale_date) AS month_name,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), MONTH(sale_date), MONTHNAME(sale_date)
) AS t1
WHERE sales_rank = 1;
```

### Q8: Top 5 Highest Spending Customers
Isolates the 5 individual customer IDs responsible for the highest combined monetary purchases.
```sql
SELECT transactions_id, SUM(total_sale) AS Total_sales_ 
FROM Retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### Q9: Unique Customer Footprint by Category
Finds the exact number of distinct consumers engaging with each separate product domain.
```sql
SELECT Category, COUNT(DISTINCT Customer_ID) AS Unique_Customers 
FROM Retail_sales
GROUP BY Category;
```

### Q10: Time-of-Day Traffic Shifts
Leverages Common Table Expressions (CTEs) and operational `CASE` statements to separate transactions into hourly time frames: Morning (<=12), Afternoon (12-17), and Evening (>17) to track workflow concentration.
```sql
WITH SHIFT_SALES AS (
 SELECT *,
  CASE
   WHEN EXTRACT(HOUR FROM Sale_time) <= 12 THEN 'MORNING'
   WHEN EXTRACT(HOUR FROM Sale_time) > 12 AND EXTRACT(HOUR FROM Sale_time) <= 17 THEN 'AFTERNOON'
   ELSE 'EVENING'
  END AS Shift
 FROM Retail_sales
)
SELECT Shift, COUNT(*) AS Total_Order_in_Shift
FROM SHIFT_SALES
GROUP BY Shift;
```

## Key Findings
* **Customer Demographics:** The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
* **High-Value Transactions:** Several transactions had a total sale amount greater than 1000, indicating premium purchases.
* **Sales Trends:** Monthly analysis shows variations in sales, helping identify peak seasons.
* **Customer Insights:** The analysis identifies the top-spending customers and the most popular product categories.

## Generated Reports
* **Sales Summary:** A detailed report summarizing total sales, customer demographics, and category performance.
* **Trend Analysis:** Insights into sales trends across different months and shifts.
* **Customer Insights:** Reports on top customers and unique customer counts per category.

## Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
