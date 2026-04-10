/*
=============================================================
Script Name: bronze_layer_ddl.sql
Description: Creates Bronze layer tables for CRM and ERP sources.
             This script creates tables in the 'bronze' schema,
             dropping them if they already exist.
Layer: Bronze
Author: Kinley Merenciano
Inspired by: Baraa Selkeni (Data Engineering Content)
Date Created: 2026-04-10
=============================================================
*/

-- Ensure bronze schema exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END;
GO

/*
=============================================================
CRM TABLES
=============================================================
*/

-- Drop table if exists
IF OBJECT_ID('bronze.crm_custo_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_custo_info;
GO

-- Create table
CREATE TABLE bronze.crm_custo_info
(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);
GO

-- Drop table if exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

-- Create table
CREATE TABLE bronze.crm_prd_info
(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);
GO

-- Drop table if exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

-- Create table
CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,   -- stored as INT in raw source (to be transformed in Silver layer)
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
GO

/*
=============================================================
ERP TABLES
=============================================================
*/

-- Drop table if exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

-- Create table
CREATE TABLE bronze.erp_loc_a101
(
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- Drop table if exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

-- Create table
CREATE TABLE bronze.erp_cust_az12
(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);
GO

-- Drop table if exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

-- Create table
CREATE TABLE bronze.erp_px_cat_g1v2
(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO
			
