
--CTE
WITH yearly_performance AS (
SELECT YEAR(Order_Date) AS order_year,Product_Name,SUM(Sales_Amount) AS Current_Sales
FROM gold.fact_sales f LEFT JOIN
gold.Product_Dim p ON p.Product_Key=f.Product_Key
WHERE YEAR(Order_Date) IS NOT NULL
GROUP BY YEAR(Order_Date),p.Product_Name
)

SELECT order_year,Product_Name, Current_Sales,
AVG(Current_Sales) OVER(PARTITION BY Product_Name ) AS AVG_sales,

CASE WHEN Current_Sales > AVG(Current_Sales) OVER(PARTITION BY Product_Name ) THEN 'Above AVG'
WHEN Current_Sales < AVG(Current_Sales) OVER(PARTITION BY Product_Name ) THEN 'Below AVG'
ELSE 'AVG' 
END AS year_status_to_AVG,
CASE 
WHEN LAG(Current_Sales) OVER(PARTITION BY Product_Name ORDER BY order_year)  IS NULL
THEN 0
ELSE LAG(Current_Sales) OVER(PARTITION BY Product_Name ORDER BY order_year)
END AS Last_Year_sales,
CASE WHEN Current_Sales > LAG(Current_Sales) OVER(PARTITION BY Product_Name ORDER BY order_year)
THEN 'INCREASE'
WHEN Current_Sales < LAG(Current_Sales) OVER(PARTITION BY Product_Name ORDER BY order_year)
THEN 'DECREASE'
ELSE 'SAME'
END AS year_status_to_LastYear
FROM yearly_performance
WHERE order_year IS NOT NULL
ORDER BY product_name,order_year
