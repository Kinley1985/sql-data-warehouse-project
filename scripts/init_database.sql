/*
====================================================================
Create Database and Schemas
====================================================================
Sript Purpose:
    This script creates a new database named 'DataWarehouse' after
    checking if ti already ecists. If the databse exists, it is 
    dropped and recreated. Additionally, the script sets up three
    schemas within the database: 'bronze', 'silver', and 'gold'.
====================================================================
Script: init_database.sql
    Description: Initialize Data Warehouse database and schemas
    Author: Kinley Merenciano (inspired by Baraa)
    Date: 2026
====================================================================
WARNING:
    Running this script will drop the entire 'DataWarehouse' database 
    if it exists. All data in the database will be permanently deleted.
    Proceed with caution and ensure have proper backups before running
    the script.
====================================================================
*/

USE master;
GO


-- Drop and recreate the 'DataWarehouse' database
IF NOT EXISTS (SELECT 1 name FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Datawarehouse
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- Use Database
USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
