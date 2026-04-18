USE datawarehouse
GO
EXEC bronze.load_bronze
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;
	SET @batch_start = GETDATE();

	BEGIN TRY
		PRINT '=============================================================';
		PRINT 'LOADING BRONZE DATA';
		PRINT '=============================================================';

		PRINT '-------------------------------------------------------------';
		PRINT 'LOADING FROM CRM';
		PRINT '-------------------------------------------------------------';

		-- CRM Customer Info
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE bronze.CRM_cust_info table';
		TRUNCATE TABLE bronze.CRM_cust_info;

		PRINT '-- inserting into bronze.CRM_cust_info table';
		BULK INSERT bronze.CRM_cust_info
		FROM 'E:\projects\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );
		
		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13); 

		-- CRM Product Info
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE bronze.CRM_prd_info table';
		TRUNCATE TABLE bronze.CRM_prd_info;

		PRINT '-- inserting into bronze.CRM_prd_info table';
		BULK INSERT bronze.CRM_prd_info
		FROM 'E:\projects\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		-- CRM Sales Details
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE bronze.CRM_sales_details table';
		TRUNCATE TABLE bronze.CRM_sales_details;

		PRINT '-- inserting into bronze.CRM_sales_details table';
		BULK INSERT bronze.CRM_sales_details
		FROM 'E:\projects\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		PRINT '-------------------------------------------------------------';
		PRINT 'LOADING FROM ERP';
		PRINT '-------------------------------------------------------------';

		-- ERP Customer AZ12
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE bronze.ERP_cust_az12 table';
		TRUNCATE TABLE bronze.ERP_cust_az12;

		PRINT '-- inserting into bronze.ERP_cust_az12 table';
		BULK INSERT bronze.ERP_cust_az12
		FROM 'E:\projects\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		-- ERP Location
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE bronze.ERP_Loc_a101 table';
		TRUNCATE TABLE bronze.ERP_Loc_a101;

		PRINT '-- inserting into bronze.ERP_Loc_a101 table';
		BULK INSERT bronze.ERP_Loc_a101
		FROM 'E:\projects\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		PRINT CHAR(13);

		-- ERP Category
		SET @start_time = GETDATE();
		PRINT '-- TRUNCATE bronze.ERP_px_cat_g1v2 table';
		TRUNCATE TABLE bronze.ERP_px_cat_g1v2;

		PRINT '-- inserting into bronze.ERP_px_cat_g1v2 table';
		BULK INSERT bronze.ERP_px_cat_g1v2
		FROM 'E:\projects\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

		SET @end_time = GETDATE();
		PRINT 'Insertion ended'
		PRINT '>> Insertion time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS varchar(50)) + ' Seconds';
		
		SET @batch_end = GETDATE();

		PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
		PRINT 'Insertion to bronze layer completed';
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