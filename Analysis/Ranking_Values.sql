--Top 5 products generates highest revenue
SELECT TOP 5 p.Product_Name , SUM(f.Sales_Amount) AS Total_revenue
FROM gold.Fact_Sales f Left JOIN  
gold.Product_Dim p ON p.Product_Key=f.Product_Key
GROUP BY p.Product_Name
ORDER BY Total_revenue DESC

--Top 5 worst-performing products of sales
SELECT TOP 5 p.Product_Name , SUM(f.Sales_Amount) AS Total_revenue
FROM gold.Fact_Sales f Left JOIN  
gold.Product_Dim p ON p.Product_Key=f.Product_Key
GROUP BY p.Product_Name
ORDER BY Total_revenue ASC

--Top 10 Customers who generated highest revenue
SELECT TOP 10 c.customer_key,concat(c.First_Name,c.Last_Name) AS Full_Name , SUM(f.Sales_Amount) AS Total_revenue
FROM gold.Fact_Sales f Left JOIN  
gold.Customer_Dim c ON c.Customer_Key=f.Customer_Key
GROUP BY c.customer_key,concat(c.First_Name,c.Last_Name) 
ORDER BY Total_revenue DESC

--The 3 customers with fewest orders placed 
SELECT TOP 10 c.customer_key,concat(c.First_Name,c.Last_Name) AS Full_Name , COUNT(DISTINCT f.Order_Number) AS Total_orders
FROM gold.Fact_Sales f Left JOIN  
gold.Customer_Dim c ON c.Customer_Key=f.Customer_Key
GROUP BY c.customer_key,concat(c.First_Name,c.Last_Name) 
ORDER BY Total_orders ,c.Customer_Key ASC

