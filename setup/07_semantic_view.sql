-- =============================================================================
-- STEP 7: Create Semantic View (Cortex Analyst)
-- =============================================================================
-- Creates the semantic view that powers Cortex Analyst text-to-SQL.
-- Defines 7 tables, 8 relationships, 20 facts, 38 dimensions, 16 metrics,
-- and 5 verified queries for supply chain analytics.
-- =============================================================================

USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;

CREATE OR REPLACE SEMANTIC VIEW SUPPLY_CHAIN_ANALYTICS
  TABLES (
    SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLIERS
      PRIMARY KEY (SUPPLIER_ID)
      UNIQUE (SUPPLIER_NAME)
      COMMENT = 'Supplier master data including contact information, region, lead times, and reliability scores. Used to analyze supplier performance and identify problematic suppliers.',

    SUPPLY_CHAIN_DEMO.PUBLIC.PRODUCTS
      PRIMARY KEY (PRODUCT_ID)
      UNIQUE (PRODUCT_NAME)
      COMMENT = 'Product catalog with pricing, categorization, reorder points, and supplier linkage. Used to analyze product performance and inventory planning.',

    SUPPLY_CHAIN_DEMO.PUBLIC.INVENTORY
      UNIQUE (INVENTORY_ID)
      COMMENT = 'Current inventory levels by product and warehouse, including reserved quantities and days of supply. Used for stockout risk analysis.',

    SUPPLY_CHAIN_DEMO.PUBLIC.PURCHASE_ORDERS
      PRIMARY KEY (PO_ID)
      COMMENT = 'Purchase orders placed with suppliers, including expected and actual delivery dates, delays, and order values. Key table for supplier performance analysis.',

    SUPPLY_CHAIN_DEMO.PUBLIC.SHIPMENTS
      PRIMARY KEY (SHIPMENT_ID)
      COMMENT = 'Shipment tracking data including carriers, dates, and delivery status. Used for logistics and carrier performance analysis.',

    SUPPLY_CHAIN_DEMO.PUBLIC.STORE_SALES
      PRIMARY KEY (SALE_ID)
      COMMENT = 'Store-level sales transactions including quantities, revenue, and sales channels. Used for demand analysis and revenue reporting.',

    SUPPLY_CHAIN_DEMO.PUBLIC.WAREHOUSES
      PRIMARY KEY (WAREHOUSE_ID)
      UNIQUE (WAREHOUSE_NAME)
      COMMENT = 'Warehouse master data including location, capacity, and type.'
  )
  RELATIONSHIPS (
    PRODUCTS_TO_SUPPLIERS AS PRODUCTS(SUPPLIER_ID) REFERENCES SUPPLIERS(SUPPLIER_ID),
    INVENTORY_TO_PRODUCTS AS INVENTORY(PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
    INVENTORY_TO_WAREHOUSES AS INVENTORY(WAREHOUSE_ID) REFERENCES WAREHOUSES(WAREHOUSE_ID),
    PURCHASE_ORDERS_TO_PRODUCTS AS PURCHASE_ORDERS(PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
    PURCHASE_ORDERS_TO_SUPPLIERS AS PURCHASE_ORDERS(SUPPLIER_ID) REFERENCES SUPPLIERS(SUPPLIER_ID),
    SHIPMENTS_TO_PURCHASE_ORDERS AS SHIPMENTS(PO_ID) REFERENCES PURCHASE_ORDERS(PO_ID),
    SHIPMENTS_TO_WAREHOUSES AS SHIPMENTS(DESTINATION_WAREHOUSE_ID) REFERENCES WAREHOUSES(WAREHOUSE_ID),
    STORE_SALES_TO_PRODUCTS AS STORE_SALES(PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID)
  )
  FACTS (
    -- Supplier facts
    SUPPLIERS.LEAD_TIME_DAYS AS LEAD_TIME_DAYS
      WITH SYNONYMS = ('lead time', 'delivery lead time')
      COMMENT = 'Average number of days from order placement to delivery',
    SUPPLIERS.RELIABILITY_SCORE AS RELIABILITY_SCORE
      WITH SYNONYMS = ('reliability', 'supplier score', 'vendor score')
      COMMENT = 'Supplier reliability score from 0 to 1, where 1 is perfectly reliable',

    -- Product facts
    PRODUCTS.UNIT_COST AS UNIT_COST
      WITH SYNONYMS = ('cost', 'purchase cost')
      COMMENT = 'Cost per unit from the supplier',
    PRODUCTS.UNIT_PRICE AS UNIT_PRICE
      WITH SYNONYMS = ('price', 'selling price', 'retail price')
      COMMENT = 'Selling price per unit',
    PRODUCTS.REORDER_POINT AS REORDER_POINT
      WITH SYNONYMS = ('reorder level', 'min stock')
      COMMENT = 'Inventory level at which a reorder should be triggered',
    PRODUCTS.REORDER_QTY AS REORDER_QTY
      WITH SYNONYMS = ('reorder quantity', 'order quantity')
      COMMENT = 'Standard quantity to order when restocking',
    PRODUCTS.WEIGHT_KG AS WEIGHT_KG
      WITH SYNONYMS = ('weight')
      COMMENT = 'Weight per unit in kilograms',

    -- Inventory facts
    INVENTORY.QUANTITY_ON_HAND AS QUANTITY_ON_HAND
      WITH SYNONYMS = ('stock on hand', 'current stock', 'qty on hand', 'inventory level')
      COMMENT = 'Total quantity currently in the warehouse',
    INVENTORY.QUANTITY_RESERVED AS QUANTITY_RESERVED
      WITH SYNONYMS = ('reserved stock', 'allocated stock')
      COMMENT = 'Quantity reserved for pending orders',
    INVENTORY.QUANTITY_AVAILABLE AS QUANTITY_AVAILABLE
      WITH SYNONYMS = ('available stock', 'free stock')
      COMMENT = 'Quantity available for new orders',
    INVENTORY.DAYS_OF_SUPPLY AS DAYS_OF_SUPPLY
      WITH SYNONYMS = ('DOS', 'supply days', 'stock coverage')
      COMMENT = 'Estimated number of days the current stock will last',

    -- Purchase order facts
    PURCHASE_ORDERS.QUANTITY_ORDERED AS QUANTITY_ORDERED
      WITH SYNONYMS = ('qty ordered', 'order quantity')
      COMMENT = 'Number of units ordered',
    PURCHASE_ORDERS.PO_UNIT_COST AS UNIT_COST
      COMMENT = 'Unit cost on the purchase order',
    PURCHASE_ORDERS.TOTAL_COST AS TOTAL_COST
      WITH SYNONYMS = ('order value', 'PO value', 'order total')
      COMMENT = 'Total cost of the purchase order',
    PURCHASE_ORDERS.DELAY_DAYS AS DELAY_DAYS
      WITH SYNONYMS = ('delivery delay', 'days late', 'days delayed')
      COMMENT = 'Number of days the delivery was late (0 means on time, NULL means not yet delivered)',

    -- Shipment facts
    SHIPMENTS.SHIPMENT_WEIGHT_KG AS WEIGHT_KG
      WITH SYNONYMS = ('weight', 'total weight')
      COMMENT = 'Total weight of the shipment in kilograms',

    -- Sales facts
    STORE_SALES.QUANTITY_SOLD AS QUANTITY_SOLD
      WITH SYNONYMS = ('units sold', 'qty sold')
      COMMENT = 'Number of units sold in the transaction',
    STORE_SALES.SALE_UNIT_PRICE AS UNIT_PRICE
      COMMENT = 'Unit price at which the product was sold',
    STORE_SALES.REVENUE AS REVENUE
      WITH SYNONYMS = ('sales revenue', 'sales amount', 'total sales')
      COMMENT = 'Total revenue from the sale',

    -- Warehouse facts
    WAREHOUSES.CAPACITY_SQFT AS CAPACITY_SQFT
      WITH SYNONYMS = ('capacity', 'square footage')
      COMMENT = 'Storage capacity of the warehouse in square feet'
  )
  DIMENSIONS (
    -- Supplier dimensions
    SUPPLIERS.SUPPLIER_ID AS SUPPLIER_ID
      WITH SYNONYMS = ('vendor id')
      COMMENT = 'Unique identifier for each supplier',
    SUPPLIERS.SUPPLIER_NAME AS SUPPLIER_NAME
      WITH SYNONYMS = ('vendor name', 'supplier', 'vendor')
      COMMENT = 'Name of the supplier company',
    SUPPLIERS.CONTACT_NAME AS CONTACT_NAME
      COMMENT = 'Primary contact person at the supplier',
    SUPPLIERS.SUPPLIER_REGION AS REGION
      WITH SYNONYMS = ('region', 'geography', 'area')
      COMMENT = 'Geographic region where the supplier is located',
    SUPPLIERS.SUPPLIER_COUNTRY AS COUNTRY
      WITH SYNONYMS = ('country')
      COMMENT = 'Country where the supplier is headquartered',
    SUPPLIERS.PAYMENT_TERMS AS PAYMENT_TERMS
      COMMENT = 'Payment terms for the supplier',
    SUPPLIERS.CONTRACT_START_DATE AS CONTRACT_START
      COMMENT = 'Start date of the supplier contract',
    SUPPLIERS.CONTRACT_END_DATE AS CONTRACT_END
      COMMENT = 'End date of the supplier contract',

    -- Product dimensions
    PRODUCTS.PRODUCT_ID AS PRODUCT_ID
      COMMENT = 'Unique product identifier',
    PRODUCTS.PRODUCT_NAME AS PRODUCT_NAME
      WITH SYNONYMS = ('product', 'item name', 'item')
      COMMENT = 'Name of the product',
    PRODUCTS.CATEGORY AS CATEGORY
      WITH SYNONYMS = ('product category', 'department')
      COMMENT = 'Product category grouping',
    PRODUCTS.SUBCATEGORY AS SUBCATEGORY
      WITH SYNONYMS = ('product subcategory', 'sub category')
      COMMENT = 'Product subcategory for finer grouping',
    PRODUCTS.IS_PERISHABLE AS IS_PERISHABLE
      WITH SYNONYMS = ('perishable')
      COMMENT = 'Whether the product is perishable and requires special storage',

    -- Inventory dimensions
    INVENTORY.INVENTORY_ID AS INVENTORY_ID
      COMMENT = 'Unique inventory record identifier',
    INVENTORY.LAST_RESTOCK_DATE AS LAST_RESTOCK_DATE
      WITH SYNONYMS = ('last restocked', 'last replenishment')
      COMMENT = 'Date when this product was last restocked at this warehouse',

    -- Purchase order dimensions
    PURCHASE_ORDERS.PO_ID AS PO_ID
      WITH SYNONYMS = ('purchase order id', 'PO number', 'order id')
      COMMENT = 'Unique purchase order identifier',
    PURCHASE_ORDERS.PO_STATUS AS STATUS
      WITH SYNONYMS = ('order status', 'PO status', 'status')
      COMMENT = 'Current status of the purchase order (Pending, In Transit, Delivered, Cancelled)',
    PURCHASE_ORDERS.ORDER_DATE AS ORDER_DATE
      WITH SYNONYMS = ('PO date', 'purchase date', 'date ordered')
      COMMENT = 'Date the purchase order was placed',
    PURCHASE_ORDERS.EXPECTED_DELIVERY_DATE AS EXPECTED_DELIVERY_DATE
      WITH SYNONYMS = ('expected arrival', 'due date')
      COMMENT = 'Expected delivery date based on supplier lead time',
    PURCHASE_ORDERS.ACTUAL_DELIVERY_DATE AS ACTUAL_DELIVERY_DATE
      WITH SYNONYMS = ('actual arrival', 'delivered date')
      COMMENT = 'Actual date the order was delivered',

    -- Shipment dimensions
    SHIPMENTS.SHIPMENT_ID AS SHIPMENT_ID
      COMMENT = 'Unique shipment identifier',
    SHIPMENTS.CARRIER AS CARRIER
      WITH SYNONYMS = ('shipping company', 'logistics provider')
      COMMENT = 'Name of the shipping carrier',
    SHIPMENTS.TRACKING_NUMBER AS TRACKING_NUMBER
      COMMENT = 'Carrier tracking number',
    SHIPMENTS.SHIPMENT_STATUS AS STATUS
      WITH SYNONYMS = ('delivery status')
      COMMENT = 'Current shipment status',
    SHIPMENTS.ORIGIN_CITY AS ORIGIN_CITY
      WITH SYNONYMS = ('shipped from', 'origin')
      COMMENT = 'City or country of shipment origin',
    SHIPMENTS.SHIPPED_DATE AS SHIPPED_DATE
      WITH SYNONYMS = ('ship date', 'date shipped')
      COMMENT = 'Date the shipment was dispatched',
    SHIPMENTS.ESTIMATED_ARRIVAL AS ESTIMATED_ARRIVAL
      WITH SYNONYMS = ('ETA', 'expected arrival')
      COMMENT = 'Estimated arrival date',
    SHIPMENTS.ACTUAL_ARRIVAL AS ACTUAL_ARRIVAL
      WITH SYNONYMS = ('delivery date', 'arrived date')
      COMMENT = 'Actual arrival date',

    -- Sales dimensions
    STORE_SALES.SALE_ID AS SALE_ID
      COMMENT = 'Unique sale transaction identifier',
    STORE_SALES.STORE_ID AS STORE_ID
      WITH SYNONYMS = ('store', 'location')
      COMMENT = 'Store identifier where the sale occurred',
    STORE_SALES.CHANNEL AS CHANNEL
      WITH SYNONYMS = ('sales channel', 'selling channel')
      COMMENT = 'Sales channel (In-Store, Online, Marketplace)',
    STORE_SALES.SALE_DATE AS SALE_DATE
      WITH SYNONYMS = ('date of sale', 'transaction date')
      COMMENT = 'Date when the sale occurred',

    -- Warehouse dimensions
    WAREHOUSES.WAREHOUSE_ID AS WAREHOUSE_ID
      COMMENT = 'Unique warehouse identifier',
    WAREHOUSES.WAREHOUSE_NAME AS WAREHOUSE_NAME
      WITH SYNONYMS = ('warehouse', 'facility')
      COMMENT = 'Name of the warehouse facility',
    WAREHOUSES.WAREHOUSE_CITY AS CITY
      WITH SYNONYMS = ('city')
      COMMENT = 'City where the warehouse is located',
    WAREHOUSES.STATE_PROVINCE AS STATE_PROVINCE
      WITH SYNONYMS = ('state')
      COMMENT = 'State or province where the warehouse is located',
    WAREHOUSES.WAREHOUSE_COUNTRY AS COUNTRY
      COMMENT = 'Country where the warehouse is located',
    WAREHOUSES.WAREHOUSE_TYPE AS WAREHOUSE_TYPE
      WITH SYNONYMS = ('facility type')
      COMMENT = 'Type of warehouse facility'
  )
  METRICS (
    -- Supplier metrics
    SUPPLIERS.AVG_LEAD_TIME AS AVG(LEAD_TIME_DAYS)
      WITH SYNONYMS = ('average lead time')
      COMMENT = 'Average lead time in days across suppliers',
    SUPPLIERS.AVG_RELIABILITY AS AVG(RELIABILITY_SCORE)
      WITH SYNONYMS = ('average reliability score')
      COMMENT = 'Average reliability score across suppliers',

    -- Product metrics
    PRODUCTS.PROFIT_MARGIN AS AVG((UNIT_PRICE - UNIT_COST) / NULLIF(UNIT_PRICE, 0) * 100)
      WITH SYNONYMS = ('margin', 'markup')
      COMMENT = 'Average profit margin as a percentage',

    -- Inventory metrics
    INVENTORY.TOTAL_STOCK_ON_HAND AS SUM(QUANTITY_ON_HAND)
      WITH SYNONYMS = ('total inventory', 'total stock')
      COMMENT = 'Total quantity on hand across all locations',
    INVENTORY.TOTAL_AVAILABLE_STOCK AS SUM(QUANTITY_AVAILABLE)
      COMMENT = 'Total quantity available for new orders',
    INVENTORY.AVG_DAYS_OF_SUPPLY AS AVG(DAYS_OF_SUPPLY)
      WITH SYNONYMS = ('average days of supply')
      COMMENT = 'Average days of supply across inventory records',

    -- Purchase order metrics
    PURCHASE_ORDERS.TOTAL_ORDER_VALUE AS SUM(TOTAL_COST)
      WITH SYNONYMS = ('total PO value', 'total purchase value')
      COMMENT = 'Total value of all purchase orders',
    PURCHASE_ORDERS.AVG_DELAY_DAYS AS AVG(DELAY_DAYS)
      WITH SYNONYMS = ('average delay', 'mean delay')
      COMMENT = 'Average delivery delay in days for delivered orders',
    PURCHASE_ORDERS.ON_TIME_DELIVERY_RATE AS AVG(CASE WHEN DELAY_DAYS <= 0 THEN 1.0 ELSE 0.0 END) * 100
      WITH SYNONYMS = ('OTD rate', 'on time percentage')
      COMMENT = 'Percentage of delivered orders that arrived on time or early',
    PURCHASE_ORDERS.TOTAL_ORDERS AS COUNT(PO_ID)
      WITH SYNONYMS = ('order count', 'number of orders')
      COMMENT = 'Total number of purchase orders',

    -- Shipment metrics
    SHIPMENTS.TOTAL_SHIPMENTS AS COUNT(SHIPMENT_ID)
      COMMENT = 'Total number of shipments',
    SHIPMENTS.AVG_SHIPMENT_WEIGHT AS AVG(WEIGHT_KG)
      COMMENT = 'Average shipment weight in kg',

    -- Sales metrics
    STORE_SALES.TOTAL_REVENUE AS SUM(REVENUE)
      WITH SYNONYMS = ('total sales', 'gross revenue')
      COMMENT = 'Total revenue across all sales',
    STORE_SALES.TOTAL_UNITS_SOLD AS SUM(QUANTITY_SOLD)
      WITH SYNONYMS = ('total quantity sold')
      COMMENT = 'Total number of units sold',
    STORE_SALES.AVG_ORDER_VALUE AS AVG(REVENUE)
      WITH SYNONYMS = ('average sale value', 'AOV')
      COMMENT = 'Average revenue per transaction',
    STORE_SALES.TRANSACTION_COUNT AS COUNT(SALE_ID)
      WITH SYNONYMS = ('number of sales', 'sale count')
      COMMENT = 'Total number of sales transactions'
  )
  COMMENT = 'Semantic model for retail supply chain analytics covering suppliers, products, inventory levels, purchase orders, shipments, and store sales. Supports analysis of supplier performance, delivery delays, stockout risk, and revenue trends.'
  WITH EXTENSION (CA = '{
    "tables": [
      {
        "name": "suppliers",
        "dimensions": [
          {"name": "supplier_id", "unique": true},
          {"name": "supplier_name", "unique": true},
          {"name": "contact_name"},
          {"name": "supplier_region"},
          {"name": "supplier_country"},
          {"name": "payment_terms"}
        ],
        "facts": [
          {"name": "lead_time_days"},
          {"name": "reliability_score"}
        ],
        "metrics": [
          {"name": "avg_lead_time"},
          {"name": "avg_reliability"}
        ],
        "time_dimensions": [
          {"name": "contract_start_date"},
          {"name": "contract_end_date"}
        ]
      },
      {
        "name": "products",
        "dimensions": [
          {"name": "product_id", "unique": true},
          {"name": "product_name", "unique": true},
          {"name": "category"},
          {"name": "subcategory"},
          {"name": "is_perishable"}
        ],
        "facts": [
          {"name": "unit_cost"},
          {"name": "unit_price"},
          {"name": "reorder_point"},
          {"name": "reorder_qty"},
          {"name": "weight_kg"}
        ],
        "metrics": [
          {"name": "profit_margin"}
        ]
      },
      {
        "name": "inventory",
        "dimensions": [
          {"name": "inventory_id", "unique": true}
        ],
        "facts": [
          {"name": "quantity_on_hand"},
          {"name": "quantity_reserved"},
          {"name": "quantity_available"},
          {"name": "days_of_supply"}
        ],
        "metrics": [
          {"name": "total_stock_on_hand"},
          {"name": "total_available_stock"},
          {"name": "avg_days_of_supply"}
        ],
        "time_dimensions": [
          {"name": "last_restock_date"}
        ]
      },
      {
        "name": "purchase_orders",
        "dimensions": [
          {"name": "po_id", "unique": true},
          {"name": "po_status"}
        ],
        "facts": [
          {"name": "quantity_ordered"},
          {"name": "po_unit_cost"},
          {"name": "total_cost"},
          {"name": "delay_days"}
        ],
        "metrics": [
          {"name": "total_order_value"},
          {"name": "avg_delay_days"},
          {"name": "on_time_delivery_rate"},
          {"name": "total_orders"}
        ],
        "filters": [
          {
            "name": "delivered_orders",
            "synonyms": ["completed orders"],
            "description": "Only delivered purchase orders",
            "expr": "STATUS = ''Delivered''"
          },
          {
            "name": "delayed_orders",
            "synonyms": ["late orders"],
            "description": "Orders that were delivered late",
            "expr": "STATUS = ''Delivered'' AND DELAY_DAYS > 0"
          }
        ],
        "time_dimensions": [
          {"name": "order_date"},
          {"name": "expected_delivery_date"},
          {"name": "actual_delivery_date"}
        ]
      },
      {
        "name": "shipments",
        "dimensions": [
          {"name": "shipment_id", "unique": true},
          {"name": "carrier"},
          {"name": "tracking_number"},
          {"name": "shipment_status"},
          {"name": "origin_city"}
        ],
        "facts": [
          {"name": "shipment_weight_kg"}
        ],
        "metrics": [
          {"name": "total_shipments"},
          {"name": "avg_shipment_weight"}
        ],
        "time_dimensions": [
          {"name": "shipped_date"},
          {"name": "estimated_arrival"},
          {"name": "actual_arrival"}
        ]
      },
      {
        "name": "store_sales",
        "dimensions": [
          {"name": "sale_id", "unique": true},
          {"name": "store_id"},
          {"name": "channel"}
        ],
        "facts": [
          {"name": "quantity_sold"},
          {"name": "sale_unit_price"},
          {"name": "revenue"}
        ],
        "metrics": [
          {"name": "total_revenue"},
          {"name": "total_units_sold"},
          {"name": "avg_order_value"},
          {"name": "transaction_count"}
        ],
        "time_dimensions": [
          {"name": "sale_date"}
        ]
      },
      {
        "name": "warehouses",
        "dimensions": [
          {"name": "warehouse_id", "unique": true},
          {"name": "warehouse_name", "unique": true},
          {"name": "warehouse_city"},
          {"name": "state_province"},
          {"name": "warehouse_country"},
          {"name": "warehouse_type"}
        ],
        "facts": [
          {"name": "capacity_sqft"}
        ]
      }
    ],
    "relationships": [
      {"name": "products_to_suppliers"},
      {"name": "inventory_to_products"},
      {"name": "inventory_to_warehouses"},
      {"name": "purchase_orders_to_suppliers"},
      {"name": "purchase_orders_to_products"},
      {"name": "shipments_to_purchase_orders"},
      {"name": "shipments_to_warehouses"},
      {"name": "store_sales_to_products"}
    ],
    "verified_queries": [
      {
        "name": "suppliers_causing_delays",
        "question": "Which suppliers are causing the most delivery delays?",
        "use_as_onboarding_question": true,
        "sql": "SELECT s.SUPPLIER_NAME, s.REGION, s.RELIABILITY_SCORE, COUNT(po.PO_ID) AS total_orders, AVG(po.DELAY_DAYS) AS avg_delay_days, SUM(CASE WHEN po.DELAY_DAYS > 0 THEN 1 ELSE 0 END) AS delayed_orders FROM SUPPLY_CHAIN_DEMO.PUBLIC.PURCHASE_ORDERS po JOIN SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLIERS s ON po.SUPPLIER_ID = s.SUPPLIER_ID WHERE po.STATUS = ''Delivered'' GROUP BY s.SUPPLIER_NAME, s.REGION, s.RELIABILITY_SCORE HAVING AVG(po.DELAY_DAYS) > 0 ORDER BY avg_delay_days DESC"
      },
      {
        "name": "products_at_stockout_risk",
        "question": "What products are at risk of stockouts?",
        "use_as_onboarding_question": true,
        "sql": "SELECT p.PRODUCT_NAME, p.CATEGORY, w.WAREHOUSE_NAME, i.QUANTITY_ON_HAND, i.QUANTITY_AVAILABLE, p.REORDER_POINT, i.DAYS_OF_SUPPLY, CASE WHEN i.QUANTITY_ON_HAND <= p.REORDER_POINT * 0.3 THEN ''Critical'' WHEN i.QUANTITY_ON_HAND <= p.REORDER_POINT THEN ''Low'' ELSE ''Adequate'' END AS stock_status FROM SUPPLY_CHAIN_DEMO.PUBLIC.INVENTORY i JOIN SUPPLY_CHAIN_DEMO.PUBLIC.PRODUCTS p ON i.PRODUCT_ID = p.PRODUCT_ID JOIN SUPPLY_CHAIN_DEMO.PUBLIC.WAREHOUSES w ON i.WAREHOUSE_ID = w.WAREHOUSE_ID WHERE i.QUANTITY_ON_HAND <= p.REORDER_POINT ORDER BY i.DAYS_OF_SUPPLY ASC"
      },
      {
        "name": "revenue_by_category",
        "question": "What is the total revenue by product category?",
        "use_as_onboarding_question": true,
        "sql": "SELECT p.CATEGORY, SUM(ss.REVENUE) AS total_revenue, SUM(ss.QUANTITY_SOLD) AS total_units_sold, COUNT(ss.SALE_ID) AS transaction_count FROM SUPPLY_CHAIN_DEMO.PUBLIC.STORE_SALES ss JOIN SUPPLY_CHAIN_DEMO.PUBLIC.PRODUCTS p ON ss.PRODUCT_ID = p.PRODUCT_ID GROUP BY p.CATEGORY ORDER BY total_revenue DESC"
      },
      {
        "name": "carrier_performance",
        "question": "How are the different carriers performing?",
        "sql": "SELECT sh.CARRIER, COUNT(sh.SHIPMENT_ID) AS total_shipments, AVG(DATEDIFF(''day'', sh.SHIPPED_DATE, COALESCE(sh.ACTUAL_ARRIVAL, sh.ESTIMATED_ARRIVAL))) AS avg_transit_days, SUM(sh.WEIGHT_KG) AS total_weight_shipped FROM SUPPLY_CHAIN_DEMO.PUBLIC.SHIPMENTS sh GROUP BY sh.CARRIER ORDER BY total_shipments DESC"
      },
      {
        "name": "supplier_delivery_performance",
        "question": "What is the on-time delivery rate by supplier?",
        "use_as_onboarding_question": true,
        "sql": "SELECT s.SUPPLIER_NAME, s.REGION, COUNT(po.PO_ID) AS total_delivered, SUM(CASE WHEN po.DELAY_DAYS <= 0 THEN 1 ELSE 0 END) AS on_time, ROUND(SUM(CASE WHEN po.DELAY_DAYS <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(po.PO_ID), 1) AS otd_rate_pct FROM SUPPLY_CHAIN_DEMO.PUBLIC.PURCHASE_ORDERS po JOIN SUPPLY_CHAIN_DEMO.PUBLIC.SUPPLIERS s ON po.SUPPLIER_ID = s.SUPPLIER_ID WHERE po.STATUS = ''Delivered'' GROUP BY s.SUPPLIER_NAME, s.REGION ORDER BY otd_rate_pct ASC"
      }
    ]
  }');

-- Verify
DESCRIBE SEMANTIC VIEW SUPPLY_CHAIN_ANALYTICS;
