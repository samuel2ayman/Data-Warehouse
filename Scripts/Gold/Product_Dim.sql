CREATE VIEW  gold.Product_Dim AS

SELECT 
ROW_NUMBER() Over(ORDER BY prd_start_dt, prd_key ) AS Product_Key,
pi.prd_id AS Product_ID,
pi.prd_key AS Product_Number,
pi.prd_nm AS Product_Name,
pi.prd_cat AS Category_ID,
pc.CAT AS Category,
pc.SUBCAT As Sub_Category,
pc.MAINTENANCE AS Maintenance,
pi.prd_cost AS Cost,
pi.prd_line as Product_Line,
pi.prd_start_dt AS Start_Date
FROM silver.CRM_prd_info AS pi
LEFT JOIN  silver.ERP_px_cat_g1v2 AS pc ON pi.prd_cat=pc.ID
WHERE pi.prd_end_date IS NULL