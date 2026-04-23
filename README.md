# 📊 SQL Data Warehouse Project

## 🚀 Overview
This project demonstrates the design and implementation of a modern data warehouse using a multi-layer architecture (Bronze, Silver, Gold).

The goal is to transform raw data from multiple sources into a clean, structured, and analytics-ready data model.

---

## 🏗️ Architecture

The project follows a layered approach:

- **Bronze Layer** – Raw data ingestion from source systems (CRM & ERP)
- **Silver Layer** – Data cleaning, validation, and standardization
- **Gold Layer** – Business-ready data modeled using a Star Schema

---

## ⭐ Data Model (Gold Layer)

- `fact_sales` – transactional sales data
- `dim_customers` – customer information
- `dim_products` – product details

---

## 🔍 Data Quality Checks

- Duplicate detection
- Null value validation
- Referential integrity checks
- Business rule validation (e.g., gender fallback logic)

---

## 🛠️ Tools & Technologies

- SQL Server
- T-SQL

---

## 📌 Key Learnings

- Data warehouse design (Bronze → Silver → Gold)
- Data modeling (Star Schema)
- Data transformation and validation
- Building analytics-ready datasets

---

## 📎 Author
**Kinley Merenciano**
