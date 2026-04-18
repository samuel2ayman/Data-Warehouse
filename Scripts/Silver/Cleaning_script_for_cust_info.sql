--check for uniqueness and not null for Primary Key
SELECT cst_id,COUNT(*) 
FROM bronze.CRM_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Ceck for unwanted spaces 
SELECT cst_firstname 
FROM  bronze.CRM_cust_info
WHERE TRIM(cst_firstname) != cst_firstname

SELECT cst_lastname 
FROM  bronze.CRM_cust_info
WHERE TRIM(cst_lastname) != cst_lastname

--Apply cleaning and inserting into silver layer table
INSERT INTO silver.CRM_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_martial_status,
cst_gndr,
cst_create_date)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname, --remove unwanted spaces
TRIM(cst_lastname) AS cst_larstname, --remove unwanted spaces
CASE 
WHEN UPPER(cst_martial_status) = 'M' THEN 'Married' --Mapping to readable format
WHEN UPPER(cst_martial_status) = 'S' THEN 'Single'
ELSE 'UNKOWN' --handling NULL
END AS cst_martial_status,
CASE 
WHEN UPPER(cst_gndr) = 'M' THEN 'Male' --Mapping to readable format
WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
ELSE 'UNKOWN' --handling NULL
END AS cst_gndr,
cst_create_date
FROM 
( SELECT *,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Ranked
FROM bronze.CRM_cust_info) t 
WHERE Ranked = 1 AND cst_id IS NOT NULL;



