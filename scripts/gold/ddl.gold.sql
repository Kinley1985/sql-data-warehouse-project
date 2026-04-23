/*
=======================================================================================
DDL Script: Create Gold Views
=======================================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.

    The Gold layer represents the final dimension and fact tables (Star Schema),
    designed for analytics and reporting.

    Each view performs transformations and combines data from the Silver layer
    to produce clean, enriched, and business-ready datasets.

Layers:
    - Source: Silver Layer
    - Output: Gold Layer (dimensional model)

Usage:
    - These views can be queried directly for analytics and reporting.

Author: Kinley Merenciano
Date: 2026-04-23
Version: 1.0
=======================================================================================
*/


-- ====================================================================================
-- Dimension: Customers
-- Description: Provides customer master data enriched from CRM and ERP systems
-- ====================================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    -- Surrogate key (generated for dimension table)
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key, 

    -- Business keys
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,

    -- Customer basic information
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    CONCAT(ci.cst_firstname, ' ', ci.cst_lastname) AS full_name,

    -- Location data from ERP
    la.cntry AS country,

    -- Demographics
    ci.cst_marital_status AS marital_status,

    -- Gender logic: prioritize CRM, fallback to ERP if missing
    CASE 
        WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    -- Additional attributes
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date        

FROM silver.crm_custo_info AS ci

-- Join ERP customer data (additional attributes)
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid

-- Join location data
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;
GO


-- ====================================================================================
-- Dimension: Products
-- Description: Provides product details with category and pricing information
-- ====================================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    -- Surrogate key
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    -- Business keys
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,

    -- Product details
    pn.prd_nm AS product_name,

    -- Category mapping
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,

    -- Pricing and classification
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,

    -- Validity
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn

-- Join category reference table
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id

-- Keep only active products (exclude historical records)
WHERE pn.prd_end_dt IS NULL;
GO


-- ====================================================================================
-- Fact Table: Sales
-- Description: Contains transactional sales data linked to customers and products
-- ====================================================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
    -- Transaction identifiers
    sd.sls_ord_num AS order_number,

    -- Foreign keys (link to dimensions)
    pr.product_key,
    cu.customer_key,

    -- Dates
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,

    -- Measures
    sd.sls_sales AS sales,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price,

    -- Derived metric
    sd.sls_quantity * sd.sls_price AS total_amount

FROM silver.crm_sales_details sd

-- Join product dimension
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

-- Join customer dimension
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
