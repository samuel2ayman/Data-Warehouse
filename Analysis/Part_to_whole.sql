--the most performing categories in sales
SELECT Category,
CAST(CAST(ROUND(SUM(f.Sales_Amount) * 100.0 / SUM(SUM(f.Sales_Amount)) OVER (), 2) 
AS DECIMAL(10,2)) AS VARCHAR) + '%' AS category_sales_percent
FROM gold.Fact_Sales f LEFT JOIN 
gold.Product_Dim p ON p.Product_Key=f.Product_Key
GROUP BY Category
Order BY category_sales_percent DESC

--Top 10 performing Products in sales
SELECT Top 10 Product_Name,
CAST(CAST(ROUND(SUM(f.Sales_Amount) * 100.0 / SUM(SUM(f.Sales_Amount)) OVER (), 2) 
AS DECIMAL(10,2)) AS VARCHAR) + '%' AS Product_sales_percent
FROM gold.Fact_Sales f LEFT JOIN 
gold.Product_Dim p ON p.Product_Key=f.Product_Key
GROUP BY Product_Name
Order BY Product_sales_percent DESC

