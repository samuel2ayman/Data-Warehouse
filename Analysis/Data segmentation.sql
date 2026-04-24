WITH price_segments AS (
SELECT Product_Name,Cost,
CASE WHEN Cost < 100 THEN 'Below 100'
WHEN Cost < 500 THEN '100-500'
WHEN Cost < 1000 THEN '500-1000'
ELSE 'Over 1000'
END AS Cost_segment
FROM gold.Product_Dim)

SELECT cost_segment,COUNT(product_name) As Products_count
FROM price_segments
GROUP BY Cost_segment
ORDER BY  Products_count DESC

----------------------------------------------------------------
WITH customers_cat AS (
SELECT Customer_Key,DATEDIFF(month,min(order_date),max(order_date)) AS customer_lifespan
FROM gold.Fact_Sales
GROUP BY customer_key
),
customer_segments AS(
SELECT c.customer_key,concat(c.First_Name,' ',c.Last_Name) AS Full_Name,SUM(Sales_Amount) as Total_spent,
CASE WHEN SUM(Sales_Amount) > 5000 then 'over 5000'
ELSE 'Below 5000'
END AS Customer_spent_segment
FROM gold.Fact_Sales f LEFT JOIN 
gold.Customer_Dim c ON c.Customer_Key=f.Customer_Key
GROUP BY c.Customer_Key,concat(c.First_Name,' ',c.Last_Name)
),
Customer_classes AS (
SELECT Full_Name,
CASE WHEN Customer_spent_segment ='over 5000' AND customer_lifespan >= 12 THEN 'VIP'
WHEN Customer_spent_segment ='Below 5000' AND customer_lifespan >= 12 THEN 'Regular'
ELSE 'New'
END AS customer_class
FROM customer_segments s JOIN 
Customers_cat c on c.customer_key=s.customer_key)

SELECT customer_class,count(Full_Name) AS customers_number
FROM Customer_classes
GROUP BY customer_class
