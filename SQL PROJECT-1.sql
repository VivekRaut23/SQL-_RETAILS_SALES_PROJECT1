-- SQL PROJECT-1 : Retail Sales Analysis
-- STEP 1: Create Database
Create Database SQL_Proj_1
Use SQL_Proj_1;

-- STEP 2: Upload table from Table Import wizard
Select * from Retail_sales;
DESCRIBE Retail_sales;

SELECT Count(*) from Retail_sales; 

-- STEP 2: CHECK FOR NULL VALUES
-- DATA CLEANING:
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

-- Data Exploration:

-- Q. How many Sales we have?
SELECT Count(*) as total_sale from Retail_sales; 

-- Q. How many Unique Customers we have?
SELECT Count(Distinct customer_id) as Total_Customers from Retail_sales; 

-- Q. How many  Categories we have ?
SELECT Count(Distinct category) as Total_category from Retail_sales; 

-- Data Analysis OR Buisnes Key Problems:
-- My Analysis & Findings

-- 1. Ensure safe updates are disabled
SET SQL_SAFE_UPDATES = 0;

-- 2. Convert using the exact pattern matching your data ('05-11-22')
UPDATE Retail_sales 
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%y');

-- 3. Modify the column type to DATE permanently
ALTER TABLE Retail_sales 
MODIFY COLUMN sale_date DATE;

-- 4. Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM Retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than  in the month of Nov-2022
SELECT * 
FROM Retail_sales
WHERE category = 'Clothing'
  AND quantiy >=4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as Total_sales_by_Category  FROM Retail_sales
Group by category
Order by Total_sales_by_Category Desc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, ROUND(AVG(age)) as Avg_Age  FROM Retail_sales
Where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM Retail_sales
Where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender, Count(transactions_id) as total_transactions  FROM Retail_sales
GROUP by category,gender
Order by total_transactions desc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT  -- Using SUBQUERRY
    year,
    month_name,
    avg_sale
FROM 
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        MONTHNAME(sale_date) AS month_name, -- Extracts name (e.g., 'November')
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), MONTH(sale_date), MONTHNAME(sale_date)
) AS t1
WHERE sales_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT  transactions_id, SUM(total_sale) as Total_sales_ FROM Retail_sales
GROUP by 1
Order by 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECt Category, COUNT(DISTINCT Customer_ID) as Uniue_Customers from Retail_sales
Group by Category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- we will use CASE STAEMENT and CTE
WITH SHIFT_SALES 
AS (
 SELECT * ,
  CASE
   WHEN Extract(Hour from Sale_time) <= 12 THEN 'MORNING'
   WHEN Extract(Hour from Sale_time) > 12 AND Extract(Hour from Sale_time) <= 17 THEN 'AFTERNOON'
   ELSE 'EVENING'
  END AS Shift
 FROM Retail_sales
 )
 SELECT
  Shift, 
  Count(*) AS Total_Order_in_Shift
 FROM SHIFT_SALES
 GROUP BY Shift;

-- ------------------- END OF PROJECT ------------------ --



