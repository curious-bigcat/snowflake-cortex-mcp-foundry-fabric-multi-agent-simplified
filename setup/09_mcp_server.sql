-- =============================================================================
-- STEP 9: Create MCP Server
-- =============================================================================
-- Creates a Snowflake-managed MCP Server that exposes the Cortex Agent
-- as a single tool. External MCP clients (Microsoft Copilot, Claude Desktop,
-- etc.) connect to this server to query supply chain data.
-- =============================================================================

USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;

CREATE OR REPLACE MCP SERVER SUPPLY_CHAIN_MCP_SERVER
FROM SPECIFICATION $$
tools:
  - title: "Supply Chain Intelligence Agent"
    name: "supply-chain-agent"
    identifier: "SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLY_CHAIN_AGENT"
    type: "CORTEX_AGENT_RUN"
    description: "Supply chain intelligence agent that answers questions about suppliers, inventory, purchase orders, shipments, warehouse operations, sales, supplier communications, incident reports, and warehouse inspections. Supports quantitative analysis, document search, and cross-domain operational questions."
$$;

-- Verify MCP server
SHOW MCP SERVERS IN SUPPLY_CHAIN_DEMO.PUBLIC;
DESCRIBE MCP SERVER SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLY_CHAIN_MCP_SERVER;

-- =============================================================================
-- MCP SERVER ENDPOINT
-- =============================================================================
-- The MCP server SSE endpoint follows this format:
--
--   https://<ACCOUNT>.snowflakecomputing.com/api/v2/databases/SUPPLY_CHAIN_DEMO/schemas/PUBLIC/mcp-servers/SUPPLY_CHAIN_MCP_SERVER/sse
--
-- Replace <ACCOUNT> with your Snowflake account identifier (e.g., SFSEAPAC-BSURESH).
--
-- Authentication: Use OAuth or Programmatic Access Token (PAT).
-- See: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-agents-mcp
-- =============================================================================
