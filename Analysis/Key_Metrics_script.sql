--KPIs
SELECT 'Total Sales' AS Measure_Name ,SUM(sales_amount) AS Measure_Value FROM gold.Fact_Sales
UNION ALL
SELECT  'Total_quantity_sold' ,SUM(Quantity) FROM gold.Fact_Sales
UNION ALL
SELECT 'Avg_selling_Price',AVG(price) FROM gold.Fact_Sales
UNION ALL
SELECT 'Total_Orders' , COUNT(DISTINCT Order_Number) FROM gold.Fact_Sales
UNION ALL
SELECT 'Total_customers_placed_orders' , COUNT(DISTINCT Customer_Key) FROM gold.Fact_Sales
UNION ALL
SELECT 'Total_customers',COUNT(Distinct Customer_key) FROM gold.Customer_Dim
UNION ALL
SELECT 'Total_Orders' , COUNT(DISTINCT Order_Number) FROM gold.Fact_Sales
UNION ALL
SELECT  'Total_products' ,COUNT(Distinct product_key) FROM gold.Product_Dim
