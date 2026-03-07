-- =============================================================================
-- STEP 6: Create Cortex Search Services
-- =============================================================================
-- Creates 3 Cortex Search services for unstructured text search:
--   1. Supplier email communications
--   2. Logistics incident reports
--   3. Warehouse inspection notes
-- These services enable semantic search over unstructured data.
-- =============================================================================

USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;

-- -----------------------------------------------------------------------------
-- 1. Supplier Communications Search
-- Searches supplier emails for delay notices, quality issues, pricing changes
-- -----------------------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE SUPPLIER_COMMS_SEARCH
  ON EMAIL_BODY
  ATTRIBUTES SUPPLIER_NAME, SUBJECT, DATE_SENT, SENDER, PRIORITY
  WAREHOUSE = SUPPLY_CHAIN_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT
      EMAIL_ID,
      SUPPLIER_NAME,
      SUPPLIER_ID,
      SUBJECT,
      EMAIL_BODY,
      DATE_SENT::VARCHAR AS DATE_SENT,
      SENDER,
      PRIORITY
    FROM SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLIER_EMAILS
  );

-- -----------------------------------------------------------------------------
-- 2. Incident Reports Search
-- Searches logistics incident reports for equipment failures, safety incidents
-- -----------------------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE INCIDENT_REPORTS_SEARCH
  ON REPORT_TEXT
  ATTRIBUTES INCIDENT_TYPE, SEVERITY, REPORT_DATE, REPORTED_BY, STATUS
  WAREHOUSE = SUPPLY_CHAIN_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT
      REPORT_ID,
      INCIDENT_TYPE,
      WAREHOUSE_ID,
      SEVERITY,
      REPORT_DATE::VARCHAR AS REPORT_DATE,
      REPORTED_BY,
      REPORT_TEXT,
      STATUS,
      RESOLUTION_DATE::VARCHAR AS RESOLUTION_DATE
    FROM SUPPLY_CHAIN_DEMO.PUBLIC.LOGISTICS_INCIDENT_REPORTS
  );

-- -----------------------------------------------------------------------------
-- 3. Warehouse Inspections Search
-- Searches warehouse inspection notes for facility conditions, safety concerns
-- -----------------------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE WAREHOUSE_INSPECTIONS_SEARCH
  ON INSPECTION_NOTES
  ATTRIBUTES INSPECTION_DATE, INSPECTOR, OVERALL_RATING, FOLLOW_UP_REQUIRED
  WAREHOUSE = SUPPLY_CHAIN_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT
      INSPECTION_ID,
      WAREHOUSE_ID,
      INSPECTION_DATE::VARCHAR AS INSPECTION_DATE,
      INSPECTOR,
      INSPECTION_NOTES,
      OVERALL_RATING,
      FOLLOW_UP_REQUIRED
    FROM SUPPLY_CHAIN_DEMO.PUBLIC.WAREHOUSE_INSPECTION_NOTES
  );

-- Verify services are created and indexing
SHOW CORTEX SEARCH SERVICES IN SUPPLY_CHAIN_DEMO.PUBLIC;
