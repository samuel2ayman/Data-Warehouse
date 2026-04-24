CREATE VIEW gold.Customer_Dim AS
SELECT 
ROW_NUMBER() OVER(ORDER BY cst_id) AS Customer_Key,
ci.cst_id AS Customer_ID,
ci.cst_key AS Customer_Number,
ci.cst_firstname AS First_Name,
ci.cst_lastname AS Last_Name,
CASE WHEN ci.cst_gndr!= 'UNKOWN' THEN ci.cst_gndr --assuming cust_gndr is the master
ELSE COALESCE(ca.GEN,'N/A')
END AS Gender,
ci.cst_martial_status AS Maritial_Status,
CASE WHEN la.CNTRY IS NULL THEN 'N/A'
ELSE la.CNTRY 
END AS Country,
ca.BDATE AS Birth_Date,
ci.cst_create_date
FROM silver.CRM_cust_info AS ci
LEFT JOIN silver.ERP_cust_az12 AS ca ON ci.cst_key=ca.CID
LEFT JOIN silver.ERP_loc_a101 AS la ON ca.CID=la.CID

