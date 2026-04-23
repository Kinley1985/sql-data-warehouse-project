#  Data Warehouse Project

##  Data Dictionary – Gold Layer

### Overview

The Gold Layer represents the **business-ready data model** designed for analytical and reporting purposes. It contains **cleaned, transformed, and structured data** derived from the Silver Layer.

This layer is organized into:

- **Dimension Tables** – provide descriptive context (e.g., customers, products)
- **Fact Tables** – store measurable business events (e.g., sales transactions)

###  Objectives

- Ensure consistent business definitions  
- Maintain high data quality  
- Optimize performance for reporting (Power BI)

###  Data Model

The Gold Layer follows a **star schema design**:

- `dim_customers`
- `dim_products`
- `fact_sales`

---

##  Table: gold.dim_customers

**Purpose:**  
Stores customer details enriched with demographic and geographic information.

### Columns

| Column Name     | Data Type | Description                                                                         |
|-----------------|----------|--------------------------------------------------------------------------------------| 
| customer_key    | INT        | Surrogate key for each customer.                                                   |
| customer_id     | INT        | Unique numerical identifier.                                                       |
| customer_number |NVARCHAR(50 | Alphanumeric identifier represnting the customer, used for tracking nd referencing.|
| first_name      |NVARCHAR(50 | The customer's first name, as recorded in the system.                              |
| last_name       |NVARCHAR(50)| The customers's Last name or family name.                                          |
| country         |NVARCHAR(50)| Customer country                                                                   |
| marital_satatus |NVARCHAR(50)| Customer marital status                                                            |
| gender          |NVARCHAR(50)| Customer gender                                                                    |
| city            |NVARCHAR(50)| Customer city                                                                      |

---

##  Table: gold.dim_products

**Purpose:**  
   Provides information about the products and their attributes. 

### Columns

| Column Name  | Data Type | Description                                                                                                  |
|--------------|----------|---------------------------------------------------------------------------------------------------------------|
| product_key         | INT          | Surrogate key for each product                                                                     |
| product_id          | INT          | Original product ID from source                                                                    |
| product_number      |NVARCHAR(50)  | A stuctured alphanumeric code reprsenting the product, often used for categorization or inventory. |
| product_name        |NVARCHAR(50)  | Descriptive name of the product, including key details, such as type, color and size.              |
| category_id         |NVARCHAR(50)  | Unique identifier for product category.                                                            |                    
| maintenance_required|NVARCHAR(50)  | Indicates whether the product requires maintennace (eg.,'Yes', 'No').                              |
| subcategory         |NVARCHAR(50)  |A more detailed  classification of the product within the category, such as product type.           |
| cost                | INT          | Standard price of the product                                                                      |
| product_line        |NVARCHAR(50)  | The specific product line or series to which the product belongs (eg., Road, Mountain, Other Sales, and Touring|
| start_date          | DATE         | The date when product  became available for sale or use, stored in.                                 |

---

##  Table: gold.fact_sales

**Purpose:**  
Stores transactional sales data used for business analysis and reporting.

### Columns

| Column Name   | Data Type | Description                                  |
|--------------|----------|----------------------------------------------|
| order_number |NVARCHAR(50)| Unique order identifier (natural key)        |
| product_key  | INT      | Foreign key to dim_products                  |
| customer_key | INT      | Foreign key to dim_customers                 |
| order_date   | DATE     | Date when the order was placed               |
| shipping_date| DATE     | Date when the order was shipped              |
| due_date     | DATE     | Expected delivery date                       |
| sales        | INT      | Total sales amount                           |
| quantity     | INT      | Number of items sold                         |
| price        | INT      | Price per item                               |

###  Grain
One row represents a single product within an order.

###  Notes
This table captures measurable business events and is joined with dimension tables for analysis.
