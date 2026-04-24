--sales change over time day granuality
SELECT  Order_Date, SUM(Sales_Amount) AS Total_sales,
COUNT(DISTINCT Customer_Key) AS Total_customers
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY Order_Date   
ORDER BY Order_Date

--sales change over time month dranuality
SELECT  MONTH(Order_Date), SUM(Sales_Amount) AS Total_sales,
COUNT(DISTINCT Customer_Key) Total_customers
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY MONTH(Order_Date)   
ORDER BY MONTH(Order_Date)

--sales change over time year dranuality
SELECT  Year(Order_Date), SUM(Sales_Amount) AS Total_sales,
COUNT(DISTINCT Customer_Key) Total_customers
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY Year(Order_Date)   
ORDER BY Year(Order_Date)
