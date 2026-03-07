-- =============================================================================
-- STEP 1: Create Database and Warehouse
-- =============================================================================
-- Run this script first to set up the database and compute resources.
-- Requires: ACCOUNTADMIN or a role with CREATE DATABASE and CREATE WAREHOUSE.
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Create database
CREATE DATABASE IF NOT EXISTS SUPPLY_CHAIN_DEMO;

-- Create warehouse (X-Small, auto-suspend after 60s)
CREATE WAREHOUSE IF NOT EXISTS SUPPLY_CHAIN_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

-- Set context
USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;
