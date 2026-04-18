SELECT * FROM bronze.CRM_prd_info

--check for uniqueness and not null for Primary Key
SELECT prd_id,COUNT(*) 
FROM bronze.CRM_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL  
--Result no null or duplicate

--check if price is negative or null
SELECT prd_id,prd_cost
FROM bronze.CRM_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--Ceck for unwanted spaces 
SELECT prd_nm
FROM  bronze.CRM_prd_info
WHERE TRIM(prd_nm) != prd_nm
--no unwanted spaces

/*
1-i need to split prd key into prd_cat and prd_key
2-replace null values in price to 0 (according to bussiness)
3-mapping prd_line to readable format
4-
*/
INSERT INTO silver.CRM_prd_info
(
prd_id,
prd_cat,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_date
)
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key,1,5) ,'-','_') AS prd_cat,
SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
prd_nm,
ISNULL(prd_cost,0) AS prd_cost,
CASE UPPER(prd_line)
    WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'M' THEN 'Mountain'
    WHEN 'T' THEN 'Touring'
END AS prd_line,
CAST(prd_start_dt AS DATE),
DATEADD(DAY, -1,
    LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)
) AS prd_end_date
FROM bronze.CRM_prd_info;
