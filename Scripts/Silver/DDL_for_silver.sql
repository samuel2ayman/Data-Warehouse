/*
create tables for silver layer
*/

USE datawarehouse

CREATE TABLE silver.CRM_cust_info(
cst_id INT ,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_martial_status NVARCHAR(10),
cst_gndr NVARCHAR(10),
cst_create_date DATE,
Created_Date DATETIME2 DEFAULT GETDATE()
);

DROP TABLE IF EXISTS silver.CRM_prd_info;
CREATE TABLE silver.CRM_prd_info(
prd_id INT ,
prd_cat NVARCHAR(50),
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_date DATE,
Created_Date DATETIME2 DEFAULT GETDATE()
);

DROP TABLE IF EXISTS silver.CRM_sales_details;
CREATE TABLE silver.CRM_sales_details(
sls_ord_num NVARCHAR(50) ,
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
Created_Date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.ERP_cust_az12 (
CID NVARCHAR(20),
BDATE DATE,
GEN NVARCHAR(20),
Created_Date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.ERP_loc_a101 (
CID NVARCHAR(20),
CNTRY NVARCHAR(20),
Created_Date DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE silver.ERP_px_cat_g1v2 (
ID NVARCHAR(20),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(20),
Created_Date DATETIME2 DEFAULT GETDATE()
);