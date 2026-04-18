select * from bronze.ERP_cust_az12
select * from Silver.CRM_cust_info

--check records not matching with crm customer info
SELECT CID 
FROM bronze.ERP_cust_az12
WHERE CID LIKE 'NAS%' or CID = '0'

--check for invalid dates
select BDATE
from bronze.ERP_cust_az12
where BDATE > GETDATE() OR BDATE < '1900-01-01'


--Cleaning and inserting in silver.ERP_cust_az12
INSERT INTO silver.ERP_cust_az12 ( 
CID,
BDATE,
GEN)
SELECT 
CASE 
WHEN CID LIKE 'NAS%' or CID = '0' 
THEN SUBSTRING(TRIM(CID),4,LEN(CID))
ELSE CID
END AS CID,
CASE WHEN  BDATE > GETDATE() OR BDATE < '1900-01-01'
THEN NULL
ELSE BDATE
END AS BDATE,
CASE 
WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'Male'
WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
ELSE 'N/A'
END AS GEN
FROM bronze.ERP_cust_az12

---------------------------------------------------------------------
--cleaning ERP_loc_a101
select * from bronze.ERP_loc_a101


--check for unwanted spaces
SELECT CID 
FROM bronze.ERP_loc_a101
WHERE CID != TRIM(CID)

--check for not complete country names
SELECT DISTINCT CNTRY 
FROM bronze.ERP_loc_a101

INSERT INTO silver.ERP_loc_a101
 (CID,
 CNTRY)
SELECT 
REPLACE(CID,'-','') AS CID,
CASE 
WHEN CNTRY IN ('US','USA') THEN 'United States'
WHEN CNTRY = 'DE' THEN 'Germany'
WHEN CNTRY = '' OR CNTRY IS NULL THEN 'N/A'
ELSE CNTRY
END AS CNTRY

FROM bronze.ERP_loc_a101

-----------------------------------------------------------------
--Cleaning bronze.ERP_px_cat_g1v2
SELECT * FROM bronze.ERP_px_cat_g1v2

--check for unwanted spaces
SELECT * FROM bronze.ERP_px_cat_g1v2
WHERE CAT != TRIM(CAT) OR SUBCAT != TRIM(SUBCAT) OR MAINTENANCE != TRIM(MAINTENANCE) 
--everthing is good

INSERT INTO silver.ERP_px_cat_g1v2
(ID,
CAT,
SUBCAT,
MAINTENANCE)
SELECT ID,CAT,SUBCAT,MAINTENANCE
FROM bronze.ERP_px_cat_g1v2