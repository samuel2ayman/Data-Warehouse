DROP VIEW IF EXISTS gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH Basic_CTE AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(YEAR, c.Birth_Date, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.Customer_Dim c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

Aggregated_CTE AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(product_key) AS total_products,
        MAX(order_date) AS last_order,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM Basic_CTE
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,

    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_class,

    DATEDIFF(MONTH, last_order, GETDATE()) AS recency,

    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM Aggregated_CTE;