CREATE VIEW gold.Fact_Sales AS
SELECT 
ss.sls_ord_num AS Order_Number,
gc.Customer_Key AS Customer_Key,
gp.Product_Key AS Product_Key,
ss.sls_order_dt AS Order_Date,
ss.sls_ship_dt AS Ship_Date,
ss.sls_due_dt AS Due_Date,
ss.sls_sales AS Sales_Amount,
ss.sls_quantity AS Quantity,
ss.sls_price AS Price

FROM silver.CRM_sales_details ss
LEFT JOIN gold.Customer_Dim gc ON ss.sls_cust_id=gc.Customer_ID
LEFT JOIN gold.Product_Dim gp ON ss.sls_prd_key=gp.Product_Number