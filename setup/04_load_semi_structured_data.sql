-- =============================================================================
-- STEP 4: Load Semi-Structured Data (JSON)
-- =============================================================================
-- Inserts synthetic JSON data into 3 semi-structured tables:
--   1. SHIPMENT_UPDATES - tracking status events for shipments
--   2. IOT_SENSOR_LOGS - warehouse IoT sensor readings
--   3. DELIVERY_TRACKING_EVENTS - last-mile delivery milestones
-- =============================================================================

USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;

-- =============================================================================
-- SHIPMENT_UPDATES (~55 rows)
-- Multiple events per shipment showing progression
-- =============================================================================

INSERT INTO SHIPMENT_UPDATES (SHIPMENT_ID, EVENT_TIMESTAMP, UPDATE_DATA) VALUES
-- Shipment 1: Germany to Southeast Hub (delayed)
(1, '2025-03-13 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Frankfurt, Germany","carrier":"UPS","tracking_number":"TRK-UPS-000001","status_message":"Package picked up from shipper facility","temperature_controlled":false,"weight_kg":64.05}')),
(1, '2025-03-15 14:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Frankfurt Airport, Germany","carrier":"UPS","tracking_number":"TRK-UPS-000001","status_message":"Shipment departed origin hub via air freight","temperature_controlled":false,"weight_kg":64.05}')),
(1, '2025-03-20 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delayed","location":"Frankfurt Customs, Germany","carrier":"UPS","tracking_number":"TRK-UPS-000001","status_message":"Shipment held at customs - documentation review required","delay_reason":"Customs documentation incomplete","estimated_delivery":"2025-03-31"}')),
(1, '2025-03-28 16:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Newark, NJ, USA","carrier":"UPS","tracking_number":"TRK-UPS-000001","status_message":"Customs cleared - released for domestic transport","temperature_controlled":false}')),
(1, '2025-03-31 11:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Miami, FL, USA","carrier":"UPS","tracking_number":"TRK-UPS-000001","status_message":"Delivered to Warehouse 6 - Southeast Fulfillment","weight_kg":64.05,"signed_by":"D. Foster"}')),

-- Shipment 2: South Korea to Pacific NW (on time)
(2, '2026-01-19 06:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Busan, South Korea","carrier":"USPS","tracking_number":"TRK-USPS-000002","status_message":"Shipment collected from Seoul Semiconductor facility","temperature_controlled":false,"weight_kg":259.0}')),
(2, '2026-01-22 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Busan Port, South Korea","carrier":"USPS","tracking_number":"TRK-USPS-000002","status_message":"Loaded onto vessel - Pacific crossing","temperature_controlled":false,"weight_kg":259.0,"estimated_delivery":"2026-01-30"}')),
(2, '2026-01-28 08:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Seattle, WA, USA","carrier":"USPS","tracking_number":"TRK-USPS-000002","status_message":"US customs clearance completed","temperature_controlled":false}')),
(2, '2026-01-30 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Seattle, WA, USA","carrier":"USPS","tracking_number":"TRK-USPS-000002","status_message":"Delivered to Warehouse 7 - Pacific NW Hub","weight_kg":259.0,"signed_by":"J. Adams"}')),

-- Shipment 3: Vietnam to East Coast (on time, temperature controlled)
(3, '2025-04-15 07:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Ho Chi Minh City, Vietnam","carrier":"FedEx","tracking_number":"TRK-FDX-000003","status_message":"Package collected from Vietnam Garment Co.","temperature_controlled":true,"weight_kg":222.0}')),
(3, '2025-04-18 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Singapore Hub","carrier":"FedEx","tracking_number":"TRK-FDX-000003","status_message":"Transiting through Singapore sorting facility","temperature_controlled":true,"weight_kg":222.0}')),
(3, '2025-04-27 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Newark, NJ, USA","carrier":"FedEx","tracking_number":"TRK-FDX-000003","status_message":"Import clearance completed","temperature_controlled":true}')),
(3, '2025-04-30 15:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Atlanta, GA, USA","carrier":"FedEx","tracking_number":"TRK-FDX-000003","status_message":"Delivered to Warehouse 2 - Southeast Hub","weight_kg":222.0,"signed_by":"M. Brown"}')),

-- Shipment 4: China to Southeast Hub (delayed, port congestion)
(4, '2025-11-05 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Shenzhen, China","carrier":"UPS","tracking_number":"TRK-UPS-000004","status_message":"Shipment collected from Shenzhen Fast Supply","temperature_controlled":false,"weight_kg":66.3}')),
(4, '2025-11-08 11:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delayed","location":"Shenzhen Port, China","carrier":"UPS","tracking_number":"TRK-UPS-000004","status_message":"Port congestion causing loading delays","delay_reason":"Shenzhen port congestion - vessel queue 5 days","estimated_delivery":"2025-11-24"}')),
(4, '2025-11-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Pacific Ocean","carrier":"UPS","tracking_number":"TRK-UPS-000004","status_message":"Vessel departed Shenzhen - en route to US West Coast","temperature_controlled":false,"weight_kg":66.3}')),
(4, '2025-11-24 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Miami, FL, USA","carrier":"UPS","tracking_number":"TRK-UPS-000004","status_message":"Delivered to Warehouse 6 with 3hr detention delay","weight_kg":66.3,"signed_by":"D. Foster"}')),

-- Shipment 5: Japan to Pacific NW (early delivery)
(5, '2025-05-02 06:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Yokohama, Japan","carrier":"Maersk","tracking_number":"TRK-MSK-000005","status_message":"Container loaded at Yokohama port","temperature_controlled":false,"weight_kg":180.0}')),
(5, '2025-05-05 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Pacific Ocean","carrier":"Maersk","tracking_number":"TRK-MSK-000005","status_message":"Vessel in transit - ETA Seattle May 14","temperature_controlled":false,"weight_kg":180.0,"estimated_delivery":"2025-05-14"}')),
(5, '2025-05-12 07:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Seattle, WA, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000005","status_message":"Early arrival - customs cleared ahead of schedule"}')),
(5, '2025-05-12 16:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Seattle, WA, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000005","status_message":"Delivered 2 days early to Warehouse 7","weight_kg":180.0,"signed_by":"J. Adams"}')),

-- Shipment 10: India to East Coast (exception - damaged)
(10, '2025-06-10 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Mumbai, India","carrier":"DHL","tracking_number":"TRK-DHL-000010","status_message":"Collected from Mumbai Textiles Ltd warehouse","temperature_controlled":false,"weight_kg":145.0}')),
(10, '2025-06-14 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Dubai Hub, UAE","carrier":"DHL","tracking_number":"TRK-DHL-000010","status_message":"Transiting through DHL Dubai hub","temperature_controlled":false,"weight_kg":145.0}')),
(10, '2025-06-22 09:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"exception","location":"Newark, NJ, USA","carrier":"DHL","tracking_number":"TRK-DHL-000010","status_message":"Package damage detected during inspection - water ingress","delay_reason":"Damage assessment and claim processing required","estimated_delivery":"2025-06-25"}')),
(10, '2025-06-25 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Newark, NJ, USA","carrier":"DHL","tracking_number":"TRK-DHL-000010","status_message":"Delivered to Warehouse 1 - damage noted on delivery receipt","weight_kg":145.0,"signed_by":"J. Wilson","condition":"damaged"}')),

-- Shipment 15: USA domestic (fast delivery)
(15, '2025-07-08 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Detroit, MI, USA","carrier":"FedEx","tracking_number":"TRK-FDX-000015","status_message":"Picked up from Detroit Auto Parts facility","temperature_controlled":false,"weight_kg":92.0}')),
(15, '2025-07-09 06:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"FedEx Memphis Hub, TN","carrier":"FedEx","tracking_number":"TRK-FDX-000015","status_message":"Sorted at main hub - outbound to destination","temperature_controlled":false,"weight_kg":92.0}')),
(15, '2025-07-10 14:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Chicago, IL, USA","carrier":"FedEx","tracking_number":"TRK-FDX-000015","status_message":"Delivered to Warehouse 3 - Midwest Hub","weight_kg":92.0,"signed_by":"L. Park"}')),

-- Shipment 20: Colombia to East Coast (delayed customs)
(20, '2025-08-15 07:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Cartagena, Colombia","carrier":"Maersk","tracking_number":"TRK-MSK-000020","status_message":"Container loaded at Cartagena port","temperature_controlled":true,"weight_kg":320.0}')),
(20, '2025-08-18 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Caribbean Sea","carrier":"Maersk","tracking_number":"TRK-MSK-000020","status_message":"Vessel in transit to Miami","temperature_controlled":true,"weight_kg":320.0,"estimated_delivery":"2025-08-25"}')),
(20, '2025-08-23 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delayed","location":"Miami Port, FL, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000020","status_message":"Held at customs - phytosanitary documentation review","delay_reason":"Updated phytosanitary requirements - additional certificates needed","estimated_delivery":"2025-09-02"}')),
(20, '2025-08-30 11:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Miami, FL, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000020","status_message":"Documentation resolved - customs released"}')),
(20, '2025-09-02 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Newark, NJ, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000020","status_message":"Delivered to Warehouse 1 - East Coast Hub","weight_kg":320.0,"signed_by":"M. Tran"}')),

-- Shipment 25: Germany to Midwest (smooth)
(25, '2025-09-01 07:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Berlin, Germany","carrier":"DHL","tracking_number":"TRK-DHL-000025","status_message":"Collected from Berlin Industrial AG","temperature_controlled":false,"weight_kg":210.0}')),
(25, '2025-09-03 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"DHL Leipzig Hub, Germany","carrier":"DHL","tracking_number":"TRK-DHL-000025","status_message":"Sorted at European hub - loaded for transatlantic flight","temperature_controlled":false,"weight_kg":210.0}')),
(25, '2025-09-07 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Chicago, IL, USA","carrier":"DHL","tracking_number":"TRK-DHL-000025","status_message":"US customs clearance completed"}')),
(25, '2025-09-08 15:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Chicago, IL, USA","carrier":"DHL","tracking_number":"TRK-DHL-000025","status_message":"Delivered to Warehouse 3 - Midwest Hub","weight_kg":210.0,"signed_by":"C. Mendez"}')),

-- Shipment 30: Mexico to South Central (fast domestic-adjacent)
(30, '2025-09-20 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Monterrey, Mexico","carrier":"UPS","tracking_number":"TRK-UPS-000030","status_message":"Collected from Monterrey Steel facility","temperature_controlled":false,"weight_kg":450.0}')),
(30, '2025-09-21 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Laredo, TX, USA","carrier":"UPS","tracking_number":"TRK-UPS-000030","status_message":"Cross-border customs cleared at Laredo","temperature_controlled":false}')),
(30, '2025-09-22 16:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Dallas, TX, USA","carrier":"UPS","tracking_number":"TRK-UPS-000030","status_message":"Delivered to Warehouse 4 - South Central Hub","weight_kg":450.0,"signed_by":"T. Henderson"}')),

-- Shipment 35: UK to East Coast (smooth)
(35, '2025-10-05 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Manchester, UK","carrier":"FedEx","tracking_number":"TRK-FDX-000035","status_message":"Collected from Manchester Supply Co.","temperature_controlled":false,"weight_kg":125.0}')),
(35, '2025-10-07 11:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"FedEx Stansted Hub, UK","carrier":"FedEx","tracking_number":"TRK-FDX-000035","status_message":"Departed UK hub via transatlantic flight","temperature_controlled":false,"weight_kg":125.0}')),
(35, '2025-10-10 08:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Newark, NJ, USA","carrier":"FedEx","tracking_number":"TRK-FDX-000035","status_message":"Customs cleared at Newark"}')),
(35, '2025-10-11 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Newark, NJ, USA","carrier":"FedEx","tracking_number":"TRK-FDX-000035","status_message":"Delivered to Warehouse 1 - East Coast Hub","weight_kg":125.0,"signed_by":"R. Kim"}')),

-- Shipment 40: South Africa to West Coast (delayed)
(40, '2025-11-01 06:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"picked_up","location":"Cape Town, South Africa","carrier":"Maersk","tracking_number":"TRK-MSK-000040","status_message":"Container loaded at Cape Town port","temperature_controlled":true,"weight_kg":280.0}')),
(40, '2025-11-08 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"in_transit","location":"Indian Ocean","carrier":"Maersk","tracking_number":"TRK-MSK-000040","status_message":"Vessel rerouted due to weather - 3 day delay expected","temperature_controlled":true,"weight_kg":280.0,"estimated_delivery":"2025-11-28"}')),
(40, '2025-11-22 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delayed","location":"Singapore","carrier":"Maersk","tracking_number":"TRK-MSK-000040","status_message":"Transshipment delay at Singapore port","delay_reason":"Vessel connection missed - next available vessel in 2 days","estimated_delivery":"2025-11-30"}')),
(40, '2025-11-28 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","location":"Los Angeles, CA, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000040","status_message":"Customs clearance completed"}')),
(40, '2025-11-30 15:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","location":"Los Angeles, CA, USA","carrier":"Maersk","tracking_number":"TRK-MSK-000040","status_message":"Delivered to Warehouse 8 - West Coast Hub (Cold Storage)","weight_kg":280.0,"signed_by":"D. Nguyen"}'));

-- =============================================================================
-- IOT_SENSOR_LOGS (~55 rows)
-- Warehouse sensor readings with ~15% alerts
-- =============================================================================

INSERT INTO IOT_SENSOR_LOGS (WAREHOUSE_ID, SENSOR_TIMESTAMP, SENSOR_DATA) VALUES
-- Warehouse 1 (Newark) - Normal operations
(1, '2025-10-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH01-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":71.2,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":92}')),
(1, '2025-10-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH01-ZA","sensor_type":"humidity","zone":"Zone A - Receiving","reading":48.5,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":false,"alert_level":"normal","battery_pct":88}')),
(1, '2025-10-15 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH01-ZB","sensor_type":"temperature","zone":"Zone B - Storage","reading":69.8,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":95}')),
(1, '2025-10-15 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"MOT-WH01-ZD","sensor_type":"motion","zone":"Zone D - Shipping","reading":142,"unit":"count","threshold_min":0,"threshold_max":500,"alert":false,"alert_level":"normal","battery_pct":76}')),
(1, '2025-11-01 02:47:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"MOT-WH01-DOCK4","sensor_type":"motion","zone":"Loading Dock 4","reading":3,"unit":"count","threshold_min":0,"threshold_max":0,"alert":true,"alert_level":"critical","battery_pct":81,"notes":"Motion detected at dock 4 during off-hours - security alert triggered"}')),

-- Warehouse 2 (Atlanta) - Normal with humidity spike
(2, '2025-10-20 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH02-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":73.4,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":89}')),
(2, '2025-10-20 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH02-ZB","sensor_type":"humidity","zone":"Zone B - Storage","reading":62.8,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":true,"alert_level":"warning","battery_pct":84,"notes":"Humidity above threshold - check HVAC dehumidifier"}')),
(2, '2025-11-05 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"DOOR-WH02-DOCK1","sensor_type":"door","zone":"Loading Dock 1","reading":1,"unit":"open","threshold_min":0,"threshold_max":1,"alert":false,"alert_level":"normal","battery_pct":91}')),
(2, '2025-11-10 08:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH02-ZC","sensor_type":"temperature","zone":"Zone C - Picking","reading":72.1,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":87}')),

-- Warehouse 3 (Chicago) - Air quality issue
(3, '2025-10-22 08:15:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH03-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":68.5,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":93}')),
(3, '2025-10-22 08:15:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"AQ-WH03-ZB","sensor_type":"air_quality","zone":"Zone B - Storage","reading":42,"unit":"AQI","threshold_min":0,"threshold_max":50,"alert":false,"alert_level":"normal","battery_pct":79}')),
(3, '2025-11-15 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH03-ZD","sensor_type":"temperature","zone":"Zone D - Shipping","reading":67.9,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":90}')),
(3, '2025-12-01 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"MOT-WH03-ZA","sensor_type":"motion","zone":"Zone A - Receiving","reading":87,"unit":"count","threshold_min":0,"threshold_max":500,"alert":false,"alert_level":"normal","battery_pct":72}')),

-- Warehouse 4 (Dallas) - HVAC failure event
(4, '2025-06-28 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH04-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":78.2,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":86}')),
(4, '2025-06-28 11:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH04-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":83.5,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":true,"alert_level":"warning","battery_pct":86,"notes":"Temperature rising - HVAC may be malfunctioning"}')),
(4, '2025-06-28 13:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH04-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":91.2,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":true,"alert_level":"critical","battery_pct":85,"notes":"CRITICAL: Temperature 11°F above threshold - HVAC failure confirmed"}')),
(4, '2025-06-28 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH04-ZA","sensor_type":"humidity","zone":"Zone A - Receiving","reading":72.5,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":true,"alert_level":"critical","battery_pct":82,"notes":"Humidity spiking with HVAC failure"}')),
(4, '2025-10-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH04-ZB","sensor_type":"temperature","zone":"Zone B - Storage","reading":70.1,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":91}')),

-- Warehouse 5 (Denver) - Elevated air quality
(5, '2025-10-30 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"AQ-WH05-ZB","sensor_type":"air_quality","zone":"Zone B - Storage","reading":38,"unit":"AQI","threshold_min":0,"threshold_max":25,"alert":true,"alert_level":"warning","battery_pct":77,"notes":"Elevated particulate matter - nearby construction activity"}')),
(5, '2025-10-30 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"AQ-WH05-ZC","sensor_type":"air_quality","zone":"Zone C - Picking","reading":42,"unit":"AQI","threshold_min":0,"threshold_max":25,"alert":true,"alert_level":"warning","battery_pct":74,"notes":"PM2.5 elevated in picking zone"}')),
(5, '2025-11-05 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH05-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":66.3,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":88}')),
(5, '2025-11-15 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH05-ZB","sensor_type":"humidity","zone":"Zone B - Storage","reading":35.2,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":false,"alert_level":"normal","battery_pct":83}')),
(5, '2025-12-01 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"DOOR-WH05-DOCK2","sensor_type":"door","zone":"Loading Dock 2","reading":0,"unit":"closed","threshold_min":0,"threshold_max":1,"alert":false,"alert_level":"normal","battery_pct":95}')),

-- Warehouse 6 (Miami) - Humidity issues
(6, '2025-07-08 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH06-ZA","sensor_type":"humidity","zone":"Zone A - Receiving","reading":67.3,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":true,"alert_level":"warning","battery_pct":80,"notes":"Humidity consistently above threshold - Miami climate challenge"}')),
(6, '2025-07-08 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH06-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":76.8,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":87}')),
(6, '2025-10-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH06-ZC","sensor_type":"temperature","zone":"Zone C - Picking","reading":74.2,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":89}')),
(6, '2025-11-28 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH06-ZA","sensor_type":"humidity","zone":"Zone A - Receiving","reading":56.8,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":false,"alert_level":"normal","battery_pct":85,"notes":"Humidity improved after dehumidifier installation"}')),

-- Warehouse 7 (Seattle) - Motion and door sensors
(7, '2025-08-15 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH07-ZA","sensor_type":"temperature","zone":"Zone A - Receiving","reading":65.4,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":90}')),
(7, '2025-10-01 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"DOOR-WH07-DOCK3","sensor_type":"door","zone":"Loading Dock 3","reading":1,"unit":"open","threshold_min":0,"threshold_max":1,"alert":false,"alert_level":"normal","battery_pct":88}')),
(7, '2025-11-05 22:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"MOT-WH07-ZD","sensor_type":"motion","zone":"Zone D - High Value Storage","reading":2,"unit":"count","threshold_min":0,"threshold_max":0,"alert":true,"alert_level":"warning","battery_pct":79,"notes":"Unexpected motion in high-value zone after hours"}')),
(7, '2025-12-01 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH07-ZB","sensor_type":"humidity","zone":"Zone B - Storage","reading":58.1,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":false,"alert_level":"normal","battery_pct":82}')),

-- Warehouse 8 (LA Cold Storage) - Temperature excursion events
(8, '2025-08-20 02:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZC-COLD","sensor_type":"temperature","zone":"Zone C - Cold Storage","reading":-17.8,"unit":"°C","threshold_min":-22.0,"threshold_max":-15.0,"alert":false,"alert_level":"normal","battery_pct":94}')),
(8, '2025-08-20 03:15:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZC-COLD","sensor_type":"temperature","zone":"Zone C - Cold Storage","reading":-12.0,"unit":"°C","threshold_min":-22.0,"threshold_max":-15.0,"alert":true,"alert_level":"critical","battery_pct":94,"notes":"CRITICAL: Temperature excursion - compressor failure detected. Temperature rising rapidly."}')),
(8, '2025-08-20 05:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZC-COLD","sensor_type":"temperature","zone":"Zone C - Cold Storage","reading":-5.2,"unit":"°C","threshold_min":-22.0,"threshold_max":-15.0,"alert":true,"alert_level":"critical","battery_pct":93,"notes":"CRITICAL: Temperature now 13°C above minimum. Perishable goods at risk. Emergency response initiated."}')),
(8, '2025-08-20 07:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZC-COLD","sensor_type":"temperature","zone":"Zone C - Cold Storage","reading":-8.5,"unit":"°C","threshold_min":-22.0,"threshold_max":-15.0,"alert":true,"alert_level":"warning","battery_pct":93,"notes":"Portable refrigeration deployed - temperature stabilizing but still above threshold"}')),
(8, '2025-08-20 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZC-COLD","sensor_type":"temperature","zone":"Zone C - Cold Storage","reading":-16.1,"unit":"°C","threshold_min":-22.0,"threshold_max":-15.0,"alert":false,"alert_level":"normal","battery_pct":92,"notes":"Temperature returning to normal range after compressor relay replacement"}')),
(8, '2025-10-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZA","sensor_type":"temperature","zone":"Zone A - Receiving (Ambient)","reading":72.5,"unit":"°F","threshold_min":60.0,"threshold_max":80.0,"alert":false,"alert_level":"normal","battery_pct":90}')),
(8, '2025-10-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZB-CHILL","sensor_type":"temperature","zone":"Zone B - Chilled Storage","reading":2.1,"unit":"°C","threshold_min":0.0,"threshold_max":4.0,"alert":false,"alert_level":"normal","battery_pct":91}')),
(8, '2025-11-18 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"TEMP-WH08-ZC-COLD","sensor_type":"temperature","zone":"Zone C - Cold Storage","reading":-14.2,"unit":"°C","threshold_min":-22.0,"threshold_max":-15.0,"alert":true,"alert_level":"warning","battery_pct":88,"notes":"Temperature slightly above threshold during generator failure test"}')),
(8, '2025-12-01 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"sensor_id":"HUM-WH08-ZA","sensor_type":"humidity","zone":"Zone A - Receiving (Ambient)","reading":42.3,"unit":"%","threshold_min":30.0,"threshold_max":60.0,"alert":false,"alert_level":"normal","battery_pct":86}'));

-- =============================================================================
-- DELIVERY_TRACKING_EVENTS (~50 rows)
-- Last-mile delivery milestones
-- =============================================================================

INSERT INTO DELIVERY_TRACKING_EVENTS (SHIPMENT_ID, EVENT_TIMESTAMP, TRACKING_DATA) VALUES
-- Shipment 1: International to Miami (with delays)
(1, '2025-03-13 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"UPS Export Hub - Frankfurt","city":"Frankfurt","country":"DE","handler":"UPS International","signature_required":false,"pieces":2,"condition":"good"}')),
(1, '2025-03-28 17:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_destination","facility":"UPS Distribution Center - Miami","city":"Miami","state":"FL","country":"US","handler":"UPS Ground","signature_required":true,"pieces":2,"condition":"good"}')),
(1, '2025-03-31 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"out_for_delivery","facility":"UPS Local - Miami","city":"Miami","state":"FL","country":"US","handler":"UPS Ground","delivery_instructions":"Deliver to Receiving Dock B","pieces":2,"condition":"good"}')),
(1, '2025-03-31 11:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 6 - Southeast Fulfillment","city":"Miami","state":"FL","country":"US","handler":"UPS Ground","signature_required":true,"proof_of_delivery":{"signed_by":"D. Foster","timestamp":"2025-03-31 11:30:00"},"pieces":2,"condition":"good"}')),

-- Shipment 3: Vietnam to Atlanta (smooth)
(3, '2025-04-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"FedEx Export Hub - Ho Chi Minh City","city":"Ho Chi Minh City","country":"VN","handler":"FedEx International Priority","signature_required":false,"pieces":5,"condition":"good"}')),
(3, '2025-04-18 13:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_hub","facility":"FedEx Asia Pacific Hub - Singapore","city":"Singapore","country":"SG","handler":"FedEx International","pieces":5,"condition":"good"}')),
(3, '2025-04-27 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","facility":"FedEx Trade Networks - Newark","city":"Newark","state":"NJ","country":"US","handler":"FedEx Customs Brokerage","pieces":5,"condition":"good"}')),
(3, '2025-04-30 15:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 2 - Southeast Hub","city":"Atlanta","state":"GA","country":"US","handler":"FedEx Freight","signature_required":true,"proof_of_delivery":{"signed_by":"M. Brown","timestamp":"2025-04-30 15:30:00"},"pieces":5,"condition":"good"}')),

-- Shipment 5: Japan to Seattle (early)
(5, '2025-05-02 07:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"Maersk Terminal - Yokohama","city":"Yokohama","country":"JP","handler":"Maersk Line","signature_required":false,"pieces":8,"condition":"good"}')),
(5, '2025-05-12 07:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","facility":"CBP - Port of Seattle","city":"Seattle","state":"WA","country":"US","handler":"Maersk Customs","pieces":8,"condition":"good"}')),
(5, '2025-05-12 16:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 7 - Pacific NW Hub","city":"Seattle","state":"WA","country":"US","handler":"Maersk Drayage","signature_required":true,"proof_of_delivery":{"signed_by":"J. Adams","timestamp":"2025-05-12 16:00:00"},"pieces":8,"condition":"good"}')),

-- Shipment 10: India to Newark (damaged)
(10, '2025-06-10 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"DHL Gateway - Mumbai","city":"Mumbai","country":"IN","handler":"DHL Global Forwarding","signature_required":false,"pieces":4,"condition":"good"}')),
(10, '2025-06-14 13:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_hub","facility":"DHL Hub - Dubai","city":"Dubai","country":"AE","handler":"DHL Express","pieces":4,"condition":"good"}')),
(10, '2025-06-22 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_destination","facility":"DHL Import Center - Newark","city":"Newark","state":"NJ","country":"US","handler":"DHL Express","pieces":4,"condition":"damaged","damage_notes":"Water damage detected on 2 of 4 packages during import inspection"}')),
(10, '2025-06-25 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 1 - East Coast Hub","city":"Newark","state":"NJ","country":"US","handler":"DHL Express","signature_required":true,"proof_of_delivery":{"signed_by":"J. Wilson","timestamp":"2025-06-25 14:00:00","notes":"Delivery accepted with noted damage"},"pieces":4,"condition":"damaged"}')),

-- Shipment 15: Domestic Detroit to Chicago (fast)
(15, '2025-07-08 10:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"FedEx Pickup - Detroit","city":"Detroit","state":"MI","country":"US","handler":"FedEx Ground","signature_required":false,"pieces":3,"condition":"good"}')),
(15, '2025-07-09 06:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_hub","facility":"FedEx World Hub - Memphis","city":"Memphis","state":"TN","country":"US","handler":"FedEx Ground","pieces":3,"condition":"good"}')),
(15, '2025-07-10 14:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 3 - Midwest Hub","city":"Chicago","state":"IL","country":"US","handler":"FedEx Ground","signature_required":true,"proof_of_delivery":{"signed_by":"L. Park","timestamp":"2025-07-10 14:30:00"},"pieces":3,"condition":"good"}')),

-- Shipment 20: Colombia to Newark (customs delay)
(20, '2025-08-15 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"Maersk Terminal - Cartagena","city":"Cartagena","country":"CO","handler":"Maersk Line","signature_required":false,"pieces":10,"condition":"good"}')),
(20, '2025-08-23 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_entry","facility":"CBP - Port of Miami","city":"Miami","state":"FL","country":"US","handler":"Maersk Customs","pieces":10,"condition":"good","customs_notes":"Additional phytosanitary certificates required"}')),
(20, '2025-08-30 12:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","facility":"CBP - Port of Miami","city":"Miami","state":"FL","country":"US","handler":"Maersk Customs","pieces":10,"condition":"good"}')),
(20, '2025-09-02 09:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 1 - East Coast Hub","city":"Newark","state":"NJ","country":"US","handler":"Maersk Intermodal","signature_required":true,"proof_of_delivery":{"signed_by":"M. Tran","timestamp":"2025-09-02 09:00:00"},"pieces":10,"condition":"good"}')),

-- Shipment 25: Germany to Chicago (smooth)
(25, '2025-09-01 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"DHL Export Hub - Berlin","city":"Berlin","country":"DE","handler":"DHL Express","signature_required":false,"pieces":6,"condition":"good"}')),
(25, '2025-09-03 15:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_hub","facility":"DHL European Hub - Leipzig","city":"Leipzig","country":"DE","handler":"DHL Express","pieces":6,"condition":"good"}')),
(25, '2025-09-07 11:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","facility":"DHL Import - Chicago O''Hare","city":"Chicago","state":"IL","country":"US","handler":"DHL Customs","pieces":6,"condition":"good"}')),
(25, '2025-09-08 15:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 3 - Midwest Hub","city":"Chicago","state":"IL","country":"US","handler":"DHL Express","signature_required":true,"proof_of_delivery":{"signed_by":"C. Mendez","timestamp":"2025-09-08 15:00:00"},"pieces":6,"condition":"good"}')),

-- Shipment 30: Mexico to Dallas (fast cross-border)
(30, '2025-09-20 08:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"UPS Export - Monterrey","city":"Monterrey","country":"MX","handler":"UPS International","signature_required":false,"pieces":2,"condition":"good"}')),
(30, '2025-09-21 12:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","facility":"CBP - Laredo Border Crossing","city":"Laredo","state":"TX","country":"US","handler":"UPS Customs Brokerage","pieces":2,"condition":"good"}')),
(30, '2025-09-22 16:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 4 - South Central Hub","city":"Dallas","state":"TX","country":"US","handler":"UPS Ground","signature_required":true,"proof_of_delivery":{"signed_by":"T. Henderson","timestamp":"2025-09-22 16:00:00"},"pieces":2,"condition":"good"}')),

-- Shipment 12: Failed delivery attempt
(12, '2025-07-01 08:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"USPS International - Toronto","city":"Toronto","country":"CA","handler":"USPS International","signature_required":true,"pieces":4,"condition":"good"}')),
(12, '2025-07-05 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_destination","facility":"USPS Distribution - Denver","city":"Denver","state":"CO","country":"US","handler":"USPS Priority","pieces":4,"condition":"good"}')),
(12, '2025-07-06 11:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivery_attempted","facility":"USPS Local - Denver","city":"Denver","state":"CO","country":"US","handler":"USPS Priority","pieces":4,"condition":"good","attempt_notes":"No one available at receiving dock - facility closed for holiday"}')),
(12, '2025-07-06 16:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"returned_to_hub","facility":"USPS Distribution - Denver","city":"Denver","state":"CO","country":"US","handler":"USPS Priority","pieces":4,"condition":"good","return_reason":"Delivery unsuccessful - rescheduled for next business day"}')),
(12, '2025-07-07 09:30:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"out_for_delivery","facility":"USPS Local - Denver","city":"Denver","state":"CO","country":"US","handler":"USPS Priority","delivery_instructions":"Second attempt - call receiving dock 30 min before arrival","pieces":4,"condition":"good"}')),
(12, '2025-07-07 14:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 5 - Mountain Hub","city":"Denver","state":"CO","country":"US","handler":"USPS Priority","signature_required":true,"proof_of_delivery":{"signed_by":"S. Mitchell","timestamp":"2025-07-07 14:00:00"},"pieces":4,"condition":"good"}')),

-- Shipment 40: South Africa to LA (delayed with partial damage)
(40, '2025-11-01 07:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"departed_origin","facility":"Maersk Terminal - Cape Town","city":"Cape Town","country":"ZA","handler":"Maersk Line","signature_required":false,"pieces":12,"condition":"good"}')),
(40, '2025-11-22 11:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"arrived_hub","facility":"Maersk Transshipment - Singapore","city":"Singapore","country":"SG","handler":"Maersk Line","pieces":12,"condition":"good","notes":"Missed vessel connection - next departure in 48 hours"}')),
(40, '2025-11-28 10:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"customs_cleared","facility":"CBP - Port of Los Angeles","city":"Los Angeles","state":"CA","country":"US","handler":"Maersk Customs","pieces":12,"condition":"partial","damage_notes":"1 of 12 packages shows minor water staining on exterior"}')),
(40, '2025-11-30 15:00:00'::TIMESTAMP_NTZ, PARSE_JSON('{"event_type":"delivered","facility":"Warehouse 8 - West Coast Hub (Cold Storage)","city":"Los Angeles","state":"CA","country":"US","handler":"Maersk Drayage","signature_required":true,"proof_of_delivery":{"signed_by":"D. Nguyen","timestamp":"2025-11-30 15:00:00","notes":"11 packages good condition, 1 package minor water damage noted"},"pieces":12,"condition":"partial"}'));
