--Running total value ,Moving AVG price
SELECT Order_date,Total_sales,
SUM(Total_sales) OVER(ORDER BY Order_date) AS Cumm_Total_sales,
AVG(AVG_price) OVER(ORDER BY Order_date) AS Moving_AVG_price
FROM(
SELECT Order_Date,SUM(Sales_Amount) AS Total_sales,
AVG(Price) AS AVG_price
FROM gold.Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY Order_Date
) t
WHERE year(order_date) =2011