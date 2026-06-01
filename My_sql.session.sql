SHOW PROCESSLIST;


select * from cleaned_sales_data limit 5;

-- high revenue products

SELECT Description ,
SUM(Quantity * UnitPrice) AS Total_revenue
FROM cleaned_sales_data
GROUP BY Description
ORDER BY Total_revenue DESC
LIMIT 10;

SELECT Description ,
SUM(Quantity * UnitPrice) AS Total_revenue
FROM cleaned_sales_data
WHERE Month = 11 AND Year = 2011
GROUP BY Description
ORDER BY Total_revenue DESC
LIMIT 10;


-- top 5 customers by revenue in november 2011

SELECT CustomerID ,
SUM(Quantity * UnitPrice) AS Total_revenue
FROM cleaned_sales_data


GROUP BY CustomerID
ORDER BY Total_revenue DESC
LIMIT 5;



-- While a regular customer buys a gift in December, a retailer (your customer) must buy those gifts in October and November to have them on their shelves in time.

-- top 5 customers by revenue all time

SELECT CustomerID ,
SUM(Quantity * UnitPrice) AS Total_revenue
FROM cleaned_sales_data
WHERE CustomerID != 'Guest'

GROUP BY CustomerID
ORDER BY Total_revenue DESC
LIMIT 5;


-- top 5 customers regestred  by revenue in november 2011 

SELECT CustomerID ,
SUM(Quantity * UnitPrice) AS Total_revenue
FROM cleaned_sales_data
WHERE CustomerID != 'Guest' AND Month = 11 AND Year = 2011

GROUP BY CustomerID
ORDER BY Total_revenue DESC
LIMIT 5;



-- top contries by revenue 

SELECT Country ,
SUM(Quantity * UnitPrice) AS Total_revenue
FROM cleaned_sales_data
GROUP BY Country
ORDER BY Total_revenue DESC
LIMIT 10;

--  Retention & Loyalty (The "Repeat Buyer" KPI)

SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(Quantity * UnitPrice) AS Total_Spent,
    SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo) AS Average_Order_Value
FROM cleaned_sales_data
WHERE CustomerID != 'Guest'
GROUP BY CustomerID
ORDER BY Total_Spent DESC
LIMIT 10;



-- Product Popularity vs. Profitability

SELECT Description
    , SUM(Quantity) AS Total_Units_Sold
    , SUM(Quantity * UnitPrice) AS Total_Revenue

FROM cleaned_sales_data
GROUP BY Description
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Average Order Value (AOV)

SELECT 
     YEAR, Month,
   ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 2)  AS AOV


FROM cleaned_sales_data
GROUP BY  YEAR, Month
ORDER BY AOV DESC
LIMIT 10; 

-- Basket Size (Average Items per Order) 

SELECT 
     YEAR, Month,
   ROUND(SUM(Quantity ) / COUNT(DISTINCT InvoiceNo), 2)  AS Basket_Size 


FROM cleaned_sales_data
GROUP BY  YEAR, Month
ORDER BY Basket_Size DESC
LIMIT 10; 




SELECT 
    YEAR, 
    Month,
    ROUND(SUM(Quantity) / COUNT(DISTINCT InvoiceNo), 2) AS Avg_Basket_Size
FROM cleaned_sales_data
GROUP BY YEAR, Month
ORDER BY YEAR ASC, Month ASC;

-- Product Affinity (Market Basket Analysis)
WITH product_affinity AS (
  SELECT DISTINCT
    p1.Description AS Product1, 
    p2.Description AS Product2
  FROM cleaned_sales_data p1
  JOIN cleaned_sales_data p2 ON p1.InvoiceNo = p2.InvoiceNo 
  WHERE p1.Description < p2.Description
)
SELECT Product1, Product2, COUNT(*) AS Co_Purchase_Count
FROM product_affinity
GROUP BY Product1, Product2
ORDER BY Co_Purchase_Count DESC
LIMIT 10;

