/*
========================================================================================
Quality Checks – Gold Layer
========================================================================================
Script Purpose:
    This script performs data quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer.

    These checks ensure:
    - Uniqueness of surrogate keys in dimension tables
    - Referential integrity between fact and dimension tables
    - Valid relationships within the data model for analytical purposes

Usage Notes:
    - Run these checks after loading the Silver Layer and before publishing the Gold Layer
    - Investigate and resolve any discrepancies found during validation
========================================================================================
*/




-- ====================================================================================
-- DATA QUALITY TESTS: gold.dim_customers
-- ====================================================================================

-- 1. Check for duplicate customers (should be ZERO)
SELECT 
    customer_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2. Check for NULL or missing surrogate keys (should be ZERO)
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;


-- 3. Check for NULL business keys (should be ZERO)
SELECT *
FROM gold.dim_customers
WHERE customer_id IS NULL;


-- 4. Validate gender values (check consistency)
SELECT DISTINCT gender
FROM gold.dim_customers
ORDER BY gender;


-- 5. Check for 'n/a' fallback usage (data completeness insight)
SELECT 
    gender,
    COUNT(*) AS total
FROM gold.dim_customers
GROUP BY gender
ORDER BY total DESC;


-- 6. Check for missing country values
SELECT *
FROM gold.dim_customers
WHERE country IS NULL;


-- 7. Validate full_name generation
SELECT *
FROM gold.dim_customers
WHERE full_name IS NULL
   OR full_name = ' ';


-- 8. Record count check (compare with source)
SELECT COUNT(*) AS gold_count FROM gold.dim_customers;

SELECT COUNT(*) AS source_count 
FROM silver.crm_custo_info;

-- ====================================================================================
-- DATA QUALITY TESTS: gold.dim_products
-- ====================================================================================

-- 1. Check for duplicate product business keys (should be ZERO)
SELECT 
    product_number,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;


-- 2. Check for NULL surrogate keys (should be ZERO)
SELECT *
FROM gold.dim_products
WHERE product_key IS NULL;


-- 3. Check for NULL business keys (should be ZERO)
SELECT *
FROM gold.dim_products
WHERE product_number IS NULL;


-- 4. Validate active products only (no historical records)
SELECT *
FROM gold.dim_products
WHERE start_date IS NULL;


-- 5. Check for missing category mapping
SELECT *
FROM gold.dim_products
WHERE category IS NULL;


-- 6. Check cost validity (no negative values)
SELECT *
FROM gold.dim_products
WHERE cost < 0;


-- 7. Record count validation (Gold vs Source active records)
SELECT COUNT(*) AS gold_count 
FROM gold.dim_products;

SELECT COUNT(*) AS source_count
FROM silver.crm_prd_info
WHERE prd_end_dt IS NULL;


-- ====================================================================================
-- DATA QUALITY TESTS: gold.fact_sales
-- ====================================================================================

-- 1. Check for missing product keys (FK integrity)
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL;


-- 2. Check for missing customer keys (FK integrity)
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL;


-- 3. Alternative (optimized): FK integrity using NOT EXISTS
SELECT *
FROM gold.fact_sales f
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM gold.dim_products p
        WHERE p.product_key = f.product_key
    )
    OR 
    NOT EXISTS (
        SELECT 1 
        FROM gold.dim_customers c
        WHERE c.customer_key = f.customer_key
    );


-- 4. Check for NULL measures
SELECT *
FROM gold.fact_sales
WHERE sales IS NULL
   OR quantity IS NULL
   OR price IS NULL;


-- 5. Check for negative or invalid values
SELECT *
FROM gold.fact_sales
WHERE quantity <= 0
   OR price < 0
   OR sales < 0;


-- 6. Validate derived metric (if applicable)
SELECT *,
       (quantity * price) AS expected_sales
FROM gold.fact_sales
WHERE sales <> quantity * price;


-- 7. Check for missing dates
SELECT *
FROM gold.fact_sales
WHERE order_date IS NULL;



