-- Create the project database

CREATE DATABASE RetailSalesDB;

USE RetailSalesDB;

-- Check total number of records

SELECT COUNT(*) AS Total_Rows
FROM dbo.SampleSuperstore;


-- Display sample records

SELECT TOP 10 *
FROM dbo.SampleSuperstore;


-- Check column names and data types

SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SampleSuperstore';

-- Business Question:
-- Are there any completely duplicate records?

SELECT
    Ship_Mode,
    Segment,
    Country,
    City,
    State,
    Postal_Code,
    Region,
    Category,
    Sub_Category,
    Sales,
    Quantity,
    Discount,
    Profit,
    COUNT(*) AS Duplicate_Count
FROM dbo.SampleSuperstore
GROUP BY
    Ship_Mode,
    Segment,
    Country,
    City,
    State,
    Postal_Code,
    Region,
    Category,
    Sub_Category,
    Sales,
    Quantity,
    Discount,
    Profit
HAVING COUNT(*) > 1;

-- Remove exact duplicate rows
WITH DuplicateRows AS
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                Ship_Mode,
                Segment,
                Country,
                City,
                State,
                Postal_Code,
                Region,
                Category,
                Sub_Category,
                Sales,
                Quantity,
                Discount,
                Profit
            ORDER BY (SELECT NULL)
        ) AS RowNum
    FROM dbo.SampleSuperstore
)
DELETE FROM DuplicateRows
WHERE RowNum > 1;


-- Check missing values in all columns

SELECT
    SUM(CASE WHEN Ship_Mode IS NULL THEN 1 ELSE 0 END)
        AS Ship_Mode_Nulls,

    SUM(CASE WHEN Segment IS NULL THEN 1 ELSE 0 END)
        AS Segment_Nulls,

    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END)
        AS Country_Nulls,

    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END)
        AS City_Nulls,

    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END)
        AS State_Nulls,

    SUM(CASE WHEN Postal_Code IS NULL THEN 1 ELSE 0 END)
        AS Postal_Code_Nulls,

    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END)
        AS Region_Nulls,

    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END)
        AS Category_Nulls,

    SUM(CASE WHEN Sub_Category IS NULL THEN 1 ELSE 0 END)
        AS Sub_Category_Nulls,

    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END)
        AS Sales_Nulls,

    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END)
        AS Quantity_Nulls,

    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END)
        AS Discount_Nulls,

    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END)
        AS Profit_Nulls

FROM dbo.SampleSuperstore;


-- Check invalid or unusual numeric values

SELECT *
FROM dbo.SampleSuperstore
WHERE
    Sales < 0
    OR Quantity <= 0
    OR Discount < 0
    OR Discount > 1;

-- Business Question:
-- What is the overall sales performance?

-- Business Objective:
-- Calculate total sales, profit, quantity and profit margin.

-- Business Insight:
-- Provides a quick overview of business performance.

SELECT
    COUNT(*) AS Total_Records,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    CAST(
        SUM(Profit) * 100.0 / SUM(Sales)
        AS DECIMAL(10,2)
    ) AS Profit_Margin
FROM dbo.SampleSuperstore;

-- Business Question:
-- Which product categories generate the highest sales?

-- Business Objective:
-- Compare sales performance across product categories.

-- Business Insight:
-- Helps identify the categories contributing most to revenue.

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM dbo.SampleSuperstore
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Business Question:
-- Which product categories generate the highest profit?

-- Business Objective:
-- Compare profit across product categories.

-- Business Insight:
-- Helps identify the most profitable product categories.

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM dbo.SampleSuperstore
GROUP BY Category
ORDER BY Total_Profit DESC;

-- Business Question:
-- Which customer segment generates the highest profit?

-- Business Objective:
-- Compare profit across customer segments.

-- Business Insight:
-- Helps understand which customer segment contributes most to profit.

SELECT
    Segment,
    SUM(Profit) AS Total_Profit
FROM dbo.SampleSuperstore
GROUP BY Segment
ORDER BY Total_Profit DESC;

-- Business Question:
-- Which sub-categories generate the highest sales?

-- Business Objective:
-- Identify the best-selling product sub-categories.

-- Business Insight:
-- Helps identify products that contribute most to sales.

SELECT
    Sub_Category,
    SUM(Sales) AS Total_Sales
FROM dbo.SampleSuperstore
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

-- Business Question:
-- Which region generates the highest profit?

-- Business Objective:
-- Compare profit performance across regions.

-- Business Insight:
-- Helps identify strong and weak regional performance.

SELECT
    Region,
    SUM(Profit) AS Total_Profit
FROM dbo.SampleSuperstore
GROUP BY Region
ORDER BY Total_Profit DESC;


-- Business Question:
-- Which sub-categories are generating losses?

-- Business Objective:
-- Identify sub-categories with negative total profit.

-- Business Insight:
-- Helps identify areas that may need pricing or discount review.

SELECT
    Sub_Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.SampleSuperstore
GROUP BY Sub_Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;
