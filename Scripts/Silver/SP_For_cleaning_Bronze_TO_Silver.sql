USE datawarehouse
GO
EXEC silver.load_silver
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;
	SET @batch_start = GETDATE();

	BEGIN TRY
		PRINT '=============================================================';
		PRINT 'LOADING SILVER DATA';
		PRINT '=============================================================';

		PRINT '-------------------------------------------------------------';
		PRINT 'LOADING FROM CRM';
		PRINT '-------------------------------------------------------------';

		-- CRM Customer Info
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE silver.CRM_cust_info';
		TRUNCATE TABLE silver.CRM_cust_info;

		PRINT '-- inserting into silver.CRM_cust_info table';
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
		
		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13); 

		-- CRM Product Info
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE silver.CRM_prd_info';
		TRUNCATE TABLE silver.CRM_prd_info;

		PRINT '-- inserting into silver.CRM_prd_info table';
		
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


		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		-- CRM Sales Details
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE silver.CRM_sales_details table';
		TRUNCATE TABLE silver.CRM_sales_details;

		PRINT '-- inserting into silver.CRM_sales_details table';
		

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


		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		PRINT '-------------------------------------------------------------';
		PRINT 'LOADING FROM ERP';
		PRINT '-------------------------------------------------------------';

		-- ERP Customer AZ12
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE silver.ERP_cust_az12 table';
		TRUNCATE TABLE silver.ERP_cust_az12;

		PRINT '-- inserting into silver.ERP_cust_az12 table';
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

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		-- ERP Location
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE silver.ERP_loc_a101 table';
		TRUNCATE TABLE silver.ERP_loc_a101;

		PRINT '-- inserting into silver.ERP_loc_a101 table';
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

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		-- ERP Category
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE silver.ERP_px_cat_g1v2 table';
		TRUNCATE TABLE silver.ERP_px_cat_g1v2;

		PRINT '-- inserting into silver.ERP_px_cat_g1v2 table';
		INSERT INTO silver.ERP_px_cat_g1v2
		(ID,
		CAT,
		SUBCAT,
		MAINTENANCE)
		SELECT ID,CAT,SUBCAT,MAINTENANCE
		FROM bronze.ERP_px_cat_g1v2

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		
		SET @batch_end = GETDATE();

		PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT 'Insertion to silver layer completed';
		PRINT 'Total Batch Time: ' + CAST(DATEDIFF(second, @batch_start, @batch_end) AS varchar(50)) + ' Seconds';
		PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';

	END TRY

	BEGIN CATCH
		PRINT '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
		PRINT 'ERROR OCCURRED DURING LOADING';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS varchar(20));
		PRINT '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
	END CATCH
END;