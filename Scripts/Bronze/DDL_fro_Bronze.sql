/*
create tables for bronze layer for sources CRM and ERP
*/


USE datawarehouse

CREATE TABLE bronze.CRM_cust_info(
cst_id INT ,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_martial_status NVARCHAR(10),
cst_gndr NVARCHAR(10),
cst_create_date DATE
);

CREATE TABLE bronze.CRM_prd_info(
prd_id INT ,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(10),
prd_start_dt DATE,
prd_end_date DATE
);


CREATE TABLE bronze.CRM_sales_details(
sls_ord_num NVARCHAR(50) ,
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

CREATE TABLE bronze.ERP_cust_az12 (
CID NVARCHAR(20),
BDATE DATE,
GEN NVARCHAR(20),

);

CREATE TABLE bronze.ERP_loc_a101 (
CID NVARCHAR(20),
CNTRY NVARCHAR(20),
);

CREATE TABLE bronze.ERP_px_cat_g1v2 (
ID NVARCHAR(20),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(20)
);