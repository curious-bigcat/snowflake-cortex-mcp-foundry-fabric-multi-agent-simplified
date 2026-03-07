-- =============================================================================
-- STEP 8: Create Cortex Agent
-- =============================================================================
-- Creates the Supply Chain Intelligence Agent with 4 tools:
--   - Cortex Analyst (text-to-SQL on semantic view)
--   - 3 Cortex Search tools (supplier emails, incidents, inspections)
-- =============================================================================

USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;

CREATE OR REPLACE AGENT SUPPLY_CHAIN_AGENT
  COMMENT = 'Supply Chain Intelligence Agent for operational insights across inventory, suppliers, shipments, and warehouses'
  PROFILE = '{"display_name": "Supply Chain Intelligence", "color": "blue"}'
  FROM SPECIFICATION $$
models:
  orchestration: auto
orchestration:
  budget:
    tokens: 16000
instructions:
  response: >
    You are a Supply Chain Intelligence Agent. You help supply chain managers
    and operations teams with real-time intelligence, analytics, and actionable insights
    across inventory, suppliers, shipments, and warehouse operations.

    Guidelines:
    - Be professional, concise, and data-driven in your responses.
    - Always summarize key findings first, then provide supporting details.
    - When presenting metrics, include context such as trends, comparisons, or thresholds.
    - Flag critical issues proactively including stockout risks, delivery delays, and supplier reliability drops.
    - If you don't have enough data to answer confidently, admit it and suggest what additional information would help.
    - Cite the data source used (Analyst for structured queries, Search for documents and communications).
  orchestration: >
    Use the Analyst tool for quantitative questions about suppliers, inventory,
    purchase orders, shipments, sales, and warehouses. Use SupplierEmailSearch
    for questions about supplier communications, delays, quality issues, or pricing
    changes. Use IncidentSearch for questions about warehouse incidents, equipment
    failures, or safety issues. Use InspectionSearch for questions about warehouse
    conditions, inspection findings, or facility maintenance.
  sample_questions:
    - question: "Which suppliers are causing the most delivery delays?"
    - question: "Are there any products at risk of stockout?"
    - question: "What warehouse safety issues have been reported recently?"
    - question: "Has Shenzhen Fast Supply communicated about any delays?"
    - question: "What is the on-time delivery rate by supplier?"
    - question: "Show me total revenue by sales channel"
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "Analyst"
      description: "Queries structured supply chain data including suppliers, products, inventory levels, purchase orders, shipments, store sales, and warehouses. Use for quantitative analysis, performance metrics, and trend analysis."
  - tool_spec:
      type: "cortex_search"
      name: "SupplierEmailSearch"
      description: "Searches supplier email communications for information about delays, quality issues, pricing changes, and general supplier correspondence."
  - tool_spec:
      type: "cortex_search"
      name: "IncidentSearch"
      description: "Searches logistics incident reports for equipment failures, inventory discrepancies, shipping damage, security breaches, and other warehouse incidents."
  - tool_spec:
      type: "cortex_search"
      name: "InspectionSearch"
      description: "Searches warehouse inspection notes for information about facility conditions, safety concerns, maintenance issues, and compliance findings."
tool_resources:
  Analyst:
    semantic_view: "SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLY_CHAIN_ANALYTICS"
    execution_environment:
      type: "warehouse"
      warehouse: "SUPPLY_CHAIN_WH"
  SupplierEmailSearch:
    search_service: "SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLIER_COMMS_SEARCH"
    max_results: 5
  IncidentSearch:
    search_service: "SUPPLY_CHAIN_DEMO.PUBLIC.INCIDENT_REPORTS_SEARCH"
    max_results: 5
  InspectionSearch:
    search_service: "SUPPLY_CHAIN_DEMO.PUBLIC.WAREHOUSE_INSPECTIONS_SEARCH"
    max_results: 5
$$;

-- Verify agent
DESCRIBE AGENT SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLY_CHAIN_AGENT;
