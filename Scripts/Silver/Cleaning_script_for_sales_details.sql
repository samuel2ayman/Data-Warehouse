
--check for unwanted spaces
SELECT sls_ord_num
FROM bronze.CRM_sales_details
WHERE sls_ord_num != trim(sls_ord_num)

SELECT sls_prd_key
FROM bronze.CRM_sales_details
WHERE sls_prd_key != trim(sls_prd_key)

--check for errors in dates
SELECT sls_order_dt
FROM bronze.CRM_sales_details
WHERE sls_order_dt =0 OR len(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

SELECT sls_ship_dt
FROM bronze.CRM_sales_details
WHERE sls_ship_dt =0 OR len(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101


SELECT sls_due_dt
FROM bronze.CRM_sales_details
WHERE sls_due_dt =0 OR len(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

SELECT sls_order_dt,sls_ship_dt
FROM bronze.CRM_sales_details
WHERE sls_order_dt > sls_ship_dt


--clean and insert into silver sales details table
INSERT INTO silver.CRM_sales_details 
(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE 
WHEN sls_order_dt =0 OR len(sls_order_dt) != 8 THEN NULL
ELSE CAST(CAST(sls_order_dt AS varchar)AS DATE)
END AS sls_order_dt,
CASE 
WHEN sls_ship_dt =0 OR len(sls_ship_dt) != 8 THEN NULL
ELSE CAST(CAST(sls_ship_dt AS varchar)AS DATE)
END AS sls_ship_dt,
CASE 
WHEN sls_due_dt =0 OR len(sls_due_dt) != 8 THEN NULL
ELSE CAST(CAST(sls_due_dt AS varchar)AS DATE)
END AS sls_due_dt,
CASE 
WHEN sls_sales < 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE 
WHEN sls_price < 0 OR sls_price IS NULL OR sls_price!= ABS (sls_sales)/ sls_quantity
	THEN ABS (sls_sales)/ NULLIF(sls_quantity,0)
ELSE sls_price
END AS sls_price

FROM bronze.CRM_sales_details



