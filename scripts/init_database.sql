/*
====================================================================
Create Database and Schemas
====================================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse'.
    If the database already exists, it will be dropped and recreated.
    The script also creates three schemas: bronze, silver, and gold.
====================================================================
Script: init_database.sql
Description: Initialize Data Warehouse database and schemas
Author: Kinley Merenciano (inspired by Baraa)
Date: 2026
====================================================================
WARNING:
    Running this script will drop the entire 'DataWarehouse' database 
    if it exists. All data will be permanently deleted.
    Proceed with caution and ensure you have proper backups.
====================================================================
*/

USE master;
GO

-- Drop database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create database
CREATE DATABASE DataWarehouse;
GO

-- Use database
USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
