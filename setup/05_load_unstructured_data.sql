-- =============================================================================
-- STEP 5: Load Unstructured Data (Text)
-- =============================================================================
-- Inserts synthetic unstructured text data into 3 tables:
--   1. SUPPLIER_EMAILS (30 rows) - supplier communications
--   2. LOGISTICS_INCIDENT_REPORTS (18 rows) - warehouse incident narratives
--   3. WAREHOUSE_INSPECTION_NOTES (15 rows) - facility inspection findings
-- These tables feed Cortex Search services for semantic search.
-- =============================================================================

USE DATABASE SUPPLY_CHAIN_DEMO;
USE SCHEMA PUBLIC;
USE WAREHOUSE SUPPLY_CHAIN_WH;

-- =============================================================================
-- SUPPLIER_EMAILS (30 rows)
-- =============================================================================

INSERT INTO SUPPLIER_EMAILS (EMAIL_ID, SUPPLIER_NAME, SUPPLIER_ID, SUBJECT, EMAIL_BODY, DATE_SENT, SENDER, PRIORITY) VALUES
-- Delay notifications (8 emails, heavily weighted to low-reliability suppliers 4,7,13,17)
(1, 'Shenzhen Fast Supply', 4, 'URGENT: Shipment Delay - PO-2025-0847',
'Dear Supply Chain Team,\n\nWe regret to inform you that shipment for PO-2025-0847 (500 units of USB-C Charging Cables) will be delayed by approximately 8-10 days. The Shenzhen port is experiencing severe congestion due to increased holiday season volumes.\n\nOur logistics team is exploring alternative routing through Hong Kong port to minimize the delay. We will provide daily updates on the situation.\n\nWe sincerely apologize for the inconvenience and are committed to ensuring quality is not compromised despite the expedited handling.\n\nBest regards,\nChen Wei\nShenzhen Fast Supply',
'2025-09-15', 'Chen Wei', 'High'),

(2, 'Shenzhen Fast Supply', 4, 'RE: Production Delay - Electronic Components Batch EC-2025-Q3',
'Dear Procurement Team,\n\nFollowing up on our call yesterday, I want to confirm that the production delay for batch EC-2025-Q3 is now estimated at 12 days beyond the original schedule. The primary cause is a shortage of semiconductor chips from our upstream supplier.\n\nWe have placed emergency orders with two alternative chip suppliers but lead times are 7-9 days. Current inventory can cover approximately 40% of the pending orders.\n\nWe recommend splitting the shipment into two batches to get partial fulfillment sooner. Please advise on your preference.\n\nRegards,\nChen Wei\nShenzhen Fast Supply',
'2025-07-22', 'Chen Wei', 'High'),

(3, 'Vietnam Garment Co.', 7, 'Notice: Fabric Shipment Delay Due to Labor Strike',
'Dear Partners,\n\nWe are writing to inform you of an ongoing labor dispute at our Ho Chi Minh City facility that has impacted production schedules. The strike began on October 2nd and negotiations are still underway with the workers union.\n\nAll orders scheduled for shipment between October 5-20 will be delayed by an estimated 10-14 days. We are transferring some production to our Hanoi facility to mitigate the impact, but capacity there is limited.\n\nAffected POs: PO-2025-1102, PO-2025-1115, PO-2025-1128. We will provide updated shipping dates by end of this week.\n\nSincerely,\nNguyen Thi Mai\nVietnam Garment Co.',
'2025-10-03', 'Nguyen Thi Mai', 'High'),

(4, 'Pacific Coast Packaging', 13, 'Shipment Delay - Warehouse Fire Impact',
'Dear Supply Chain Management,\n\nI regret to inform you of a fire incident at our Sacramento packaging facility on August 12th. While no personnel were injured, approximately 30% of our finished goods inventory was damaged or destroyed.\n\nThis directly affects the following pending orders: PO-2025-0934, PO-2025-0951. Expected delay is 15-20 days as we ramp up production at our Portland backup facility.\n\nOur insurance adjusters are on-site and we are working around the clock to restore full capacity. We will absorb all expedited shipping costs for affected orders.\n\nSincerely,\nMike Johnson\nPacific Coast Packaging',
'2025-08-14', 'Mike Johnson', 'High'),

(5, 'Bogota Coffee Supply', 17, 'Delay Notice: Coffee Bean Shipment - Customs Hold',
'Dear Team,\n\nOur latest shipment of organic coffee beans (PO-2025-0876) has been held at Cartagena customs due to updated phytosanitary documentation requirements that took effect September 1st.\n\nWe are working with our customs broker to resolve the paperwork issues. Estimated additional delay is 7-10 days. The goods are properly stored in climate-controlled containers at the port so quality should not be affected.\n\nThis is the third customs-related delay this quarter and we are investing in a dedicated compliance officer to prevent future occurrences.\n\nApologies for the inconvenience,\nCarlos Rodriguez\nBogota Coffee Supply',
'2025-09-08', 'Carlos Rodriguez', 'High'),

(6, 'Vietnam Garment Co.', 7, 'RE: Updated Timeline - Apparel Order Delays',
'Dear Procurement,\n\nFurther to our previous communication about the labor situation, I wanted to provide an update. The strike has been partially resolved with 60% of workers returning. However, we are still operating at reduced capacity.\n\nRevised delivery estimates for pending orders:\n- PO-2025-1102: Delayed 8 days (was 14)\n- PO-2025-1115: Delayed 11 days (was 14)\n- PO-2025-1128: Delayed 6 days (was 10)\n\nWe have also hired temporary workers and are running extended shifts to catch up. Quality control remains strict despite the accelerated schedule.\n\nThank you for your patience,\nNguyen Thi Mai\nVietnam Garment Co.',
'2025-10-12', 'Nguyen Thi Mai', 'Medium'),

(7, 'Bogota Coffee Supply', 17, 'Harvest Season Delay - Lower Than Expected Yield',
'Dear Purchasing Team,\n\nDue to unusual weather patterns this growing season, our coffee bean harvest yield is approximately 25% below projections. This will impact our ability to fulfill large orders on the original timeline.\n\nWe are supplementing with beans from partner farms in the Huila region, but the blending and quality testing process adds 5-7 days to our standard lead time.\n\nPlease note that pricing for Q4 orders may need to be adjusted upward by 8-12% to reflect the increased sourcing costs. We will send a formal price revision next week.\n\nBest regards,\nCarlos Rodriguez\nBogota Coffee Supply',
'2025-11-05', 'Carlos Rodriguez', 'Medium'),

(8, 'Pacific Coast Packaging', 13, 'Equipment Breakdown - Corrugated Line #3',
'Dear Supply Chain Team,\n\nOur main corrugated cardboard production line (#3) experienced a major mechanical failure yesterday. The main drive motor needs replacement and the part has a 10-day lead time from the manufacturer.\n\nWe are redirecting orders to lines #1 and #2 but total capacity is reduced by approximately 35%. Orders for standard shipping boxes and custom packaging will be delayed 5-8 days.\n\nPriority orders can be fulfilled first - please let us know which POs are most urgent and we will prioritize accordingly.\n\nRegards,\nMike Johnson\nPacific Coast Packaging',
'2025-06-18', 'Mike Johnson', 'High'),

-- Quality issues (5 emails)
(9, 'Shenzhen Fast Supply', 4, 'Quality Alert: Defective Batch - Bluetooth Modules BT-2025-Q2',
'Dear Quality Assurance Team,\n\nDuring our internal QC process, we identified a defect in Bluetooth modules from batch BT-2025-Q2. Approximately 15% of units tested showed intermittent connectivity drops beyond 5 meters range, below our specified 10-meter standard.\n\nWe have quarantined the entire batch of 2,000 units and initiated a root cause analysis. Preliminary findings point to a soldering defect on the antenna connection.\n\nPlease check any units from this batch that may have already been shipped (tracking numbers TRK-SFS-004521 through TRK-SFS-004525). We recommend pulling them from inventory pending our full QC report.\n\nRegards,\nLi Jing, Quality Manager\nShenzhen Fast Supply',
'2025-05-20', 'Li Jing', 'High'),

(10, 'Vietnam Garment Co.', 7, 'Quality Issue: Color Fastness Failure - Denim Batch DN-2025-08',
'Dear Quality Team,\n\nWe have received your complaint regarding color bleeding in denim jackets from batch DN-2025-08. After investigation, we confirmed that the dye lot used did not meet our standard wash fastness rating.\n\nRoot cause: Our dye supplier substituted a lower-grade indigo dye without notification. We have terminated that supplier relationship and reverted to our original dye source.\n\nWe are prepared to offer full replacement of the 300 affected units at no additional cost, with expedited shipping. Replacement batch will undergo triple wash testing before shipment.\n\nSincerely,\nNguyen Van Duc\nVietnam Garment Co.',
'2025-08-28', 'Nguyen Van Duc', 'High'),

(11, 'GlobalTech Components', 1, 'Quality Certificate Update - ISO 9001:2025 Recertification',
'Dear Partners,\n\nWe are pleased to inform you that GlobalTech Components has successfully completed our ISO 9001:2025 recertification audit. Our updated certificate is attached for your records.\n\nAs part of our continuous improvement program, we have also implemented new automated optical inspection systems on all SMT production lines. This has reduced our defect rate from 0.3% to 0.08% over the past quarter.\n\nWe are confident this investment will further improve the quality and reliability of components we supply to you.\n\nBest regards,\nWang Lei, Quality Director\nGlobalTech Components',
'2025-04-10', 'Wang Lei', 'Low'),

(12, 'Mumbai Textiles Ltd', 2, 'Fabric Specification Change Notice',
'Dear Product Development Team,\n\nPlease be advised that effective from our next production run, we will be transitioning our organic cotton blend from 60/40 to 65/35 organic cotton to recycled polyester ratio. This change improves fabric durability by approximately 15% based on our testing.\n\nThe weight, hand feel, and color absorption properties remain within your specified tolerances. We have sent sample swatches via DHL (tracking: DHL-9847562) for your evaluation.\n\nPlease confirm acceptance within 10 business days so we can proceed with the updated specification for Q4 production.\n\nRegards,\nPriya Sharma\nMumbai Textiles Ltd',
'2025-06-05', 'Priya Sharma', 'Medium'),

(13, 'Detroit Auto Parts', 12, 'Recall Notice - Brake Pad Compound Issue',
'Dear Valued Customer,\n\nWe are issuing a voluntary recall on brake pad sets manufactured between March 15-22, 2025 (lot numbers BP-2025-0315 through BP-2025-0322). Testing revealed that the friction compound in these lots may not meet our heat resistance specifications under sustained high-temperature braking.\n\nAffected quantity in your inventory: estimated 45 sets. Please quarantine these units immediately. Replacement sets will be shipped within 5 business days at our expense.\n\nSafety is our top priority and we appreciate your cooperation in this matter.\n\nJohn Martinez, VP Quality\nDetroit Auto Parts',
'2025-04-02', 'John Martinez', 'High'),

-- Pricing changes (4 emails)
(14, 'Seoul Semiconductor', 6, 'Price Adjustment Notice - Effective January 2026',
'Dear Procurement Team,\n\nDue to rising costs of rare earth materials and increased energy prices in South Korea, we must adjust our pricing effective January 1, 2026.\n\nLED components: +6% increase\nDisplay modules: +8% increase\nSemiconductor chips: +4% increase\n\nWe have absorbed cost increases throughout 2025 but can no longer sustain current pricing. For orders placed before December 15, 2025, we will honor current pricing.\n\nWe remain committed to providing the highest quality components and appreciate your continued partnership.\n\nBest regards,\nPark Min-jun\nSeoul Semiconductor',
'2025-11-15', 'Park Min-jun', 'Medium'),

(15, 'Sao Paulo Plastics', 16, 'Bulk Discount Offer - Q4 2025',
'Dear Purchasing Department,\n\nAs we approach year-end, we would like to offer a special bulk discount program for Q4 orders:\n\n- Orders over 10,000 units: 5% discount\n- Orders over 25,000 units: 8% discount\n- Orders over 50,000 units: 12% discount\n\nThis applies to all product lines including food-grade containers, industrial packaging, and retail display materials. Offer valid for orders placed before November 30, 2025.\n\nWe also have new biodegradable packaging options available at competitive pricing. Happy to schedule a call to discuss.\n\nRegards,\nRoberto Silva\nSao Paulo Plastics',
'2025-10-01', 'Roberto Silva', 'Low'),

(16, 'Monterrey Steel', 14, 'Raw Material Cost Increase - Steel Price Update',
'Dear Supply Chain Partners,\n\nGlobal steel prices have increased 18% over the past quarter due to supply constraints and increased demand from the construction sector. We must pass through a portion of this increase.\n\nEffective November 1, 2025:\n- Carbon steel components: +10% \n- Stainless steel components: +12%\n- Aluminum alloy parts: +7%\n\nWe are actively hedging our raw material purchases and exploring alternative suppliers to minimize future volatility. Long-term contract pricing is available for commitments of 12+ months.\n\nRegards,\nAlejandro Gutierrez\nMonterrey Steel',
'2025-10-20', 'Alejandro Gutierrez', 'Medium'),

(17, 'Cape Town Organics', 18, 'Updated Pricing - Fair Trade Premium Adjustment',
'Dear Buyer,\n\nAs part of our commitment to Fair Trade practices, we are adjusting our pricing to reflect the increased Fair Trade premium mandated for 2026. The premium increase is approximately 3-5% depending on the product line.\n\nThis ensures our farming partners receive living wages and can invest in sustainable agricultural practices. We believe this aligns with your company''s sustainability commitments.\n\nNew price lists will be distributed by December 1, 2025. Current contract pricing remains valid through the end of this year.\n\nWarm regards,\nThandi Nkosi\nCape Town Organics',
'2025-11-08', 'Thandi Nkosi', 'Low'),

-- Capacity updates (4 emails)
(18, 'Tokyo Precision Mfg', 5, 'Factory Expansion Complete - Increased Capacity Available',
'Dear Partners,\n\nWe are excited to announce the completion of our new manufacturing wing in Osaka. This expansion increases our total production capacity by 40% and adds three new CNC machining centers with 5-axis capability.\n\nNew capabilities include:\n- Precision parts down to 0.001mm tolerance\n- Titanium and carbon fiber machining\n- Automated quality inspection with AI-powered vision systems\n\nWe can now accept larger orders with shorter lead times. Our new capacity is available for booking starting December 2025.\n\nBest regards,\nTanaka Hiroshi\nTokyo Precision Mfg',
'2025-11-20', 'Tanaka Hiroshi', 'Low'),

(19, 'Berlin Industrial AG', 8, 'Capacity Constraint Notice - Q1 2026',
'Dear Customer,\n\nDue to scheduled maintenance of our main production line and the installation of new energy-efficient equipment, we will be operating at approximately 70% capacity during January-February 2026.\n\nWe strongly recommend placing Q1 orders by November 30, 2025 to ensure availability. Orders received after that date may experience 5-10 day delays.\n\nThe new equipment will significantly reduce our carbon footprint and improve energy efficiency by 25%. We appreciate your understanding during this transition.\n\nMit freundlichen Gruessen,\nHans Mueller\nBerlin Industrial AG',
'2025-11-01', 'Hans Mueller', 'Medium'),

(20, 'Bangalore Software Exports', 19, 'New IoT Sensor Product Line Launch',
'Dear Technology Partners,\n\nWe are pleased to announce the launch of our new IoT sensor product line, specifically designed for warehouse and supply chain monitoring:\n\n- Temperature/Humidity sensors (Wi-Fi and LoRaWAN)\n- Motion detection sensors with AI edge processing\n- Asset tracking beacons (BLE 5.0)\n- Environmental monitoring (air quality, CO2)\n\nAll products are compatible with major cloud platforms and include our proprietary dashboard software. Volume pricing starts at $15/unit for orders of 500+.\n\nWould you be interested in a pilot program? We can offer 50 units at cost for a 90-day evaluation.\n\nBest regards,\nRajesh Krishnamurthy\nBangalore Software Exports',
'2025-09-25', 'Rajesh Krishnamurthy', 'Low'),

(21, 'Warsaw Electronics', 11, 'Production Line Upgrade - Temporary Capacity Reduction',
'Dear Supply Chain Team,\n\nWe are upgrading our SMT (Surface Mount Technology) lines to the latest generation equipment during the first two weeks of December 2025. During this period, our capacity for circuit board assembly will be reduced by approximately 50%.\n\nPlease plan accordingly and submit any urgent orders before November 25. Post-upgrade, we will have 30% higher throughput and improved yield rates.\n\nWe apologize for any inconvenience and are available to discuss order scheduling to minimize disruption.\n\nPozdrawiam,\nAnna Kowalska\nWarsaw Electronics',
'2025-11-10', 'Anna Kowalska', 'Medium'),

-- General correspondence (5 emails)
(22, 'Manchester Supply Co.', 9, 'Contract Renewal Discussion - 2026 Terms',
'Dear Procurement Director,\n\nAs our current supply agreement expires on March 31, 2026, I would like to schedule a meeting to discuss renewal terms. We have valued our partnership over the past three years and look forward to continuing.\n\nKey topics for discussion:\n- Volume commitments for 2026\n- Pricing framework with raw material indexing\n- Quality SLA updates\n- Sustainability requirements and reporting\n\nPlease let me know your availability for a video call in the first week of December. I will prepare a proposal document in advance.\n\nKind regards,\nJames Crawford\nManchester Supply Co.',
'2025-11-18', 'James Crawford', 'Medium'),

(23, 'Milan Fashion Group', 10, 'Spring/Summer 2026 Collection Preview',
'Dear Buying Team,\n\nWe are delighted to invite you to the preview of our Spring/Summer 2026 collection. The line features 45 new designs incorporating sustainable fabrics and Italian craftsmanship.\n\nHighlights include:\n- Organic linen blend casual wear\n- Recycled ocean plastic accessories\n- Plant-based leather alternatives\n\nThe virtual showroom will be available from December 1, 2025. Early orders placed before January 15 will receive priority manufacturing slots and a 3% early-bird discount.\n\nLooking forward to your feedback.\n\nCordiali saluti,\nGiulia Rossi\nMilan Fashion Group',
'2025-11-22', 'Giulia Rossi', 'Low'),

(24, 'Maple Leaf Goods', 15, 'Meeting Confirmation - Annual Business Review',
'Dear Team,\n\nThis email confirms our Annual Business Review meeting scheduled for December 8, 2025 at 10:00 AM EST via Microsoft Teams.\n\nAgenda:\n1. 2025 Performance Review (delivery, quality, pricing)\n2. 2026 Demand Forecast\n3. New Product Development Pipeline\n4. Sustainability Scorecard\n5. Open Discussion\n\nPlease have your 2026 forecast numbers ready for discussion. We will share our capacity planning presentation beforehand.\n\nBest regards,\nSarah MacDonald\nMaple Leaf Goods',
'2025-11-25', 'Sarah MacDonald', 'Low'),

(25, 'EuroLogistics GmbH', 20, 'New Warehouse Hub in Rotterdam - Faster EU Distribution',
'Dear Logistics Partners,\n\nWe are excited to announce the opening of our new 50,000 sqm warehouse hub in Rotterdam, Netherlands. This strategic location provides:\n\n- Direct access to Europe''s largest port\n- 24-hour reach to all major EU markets\n- Cross-docking and value-added services\n- Temperature-controlled storage zones\n\nFor our existing customers, we are offering preferential rates for the first 6 months. This hub can significantly reduce your EU distribution lead times by 2-3 days.\n\nI''d welcome the opportunity to discuss how this can benefit your supply chain.\n\nMit freundlichen Gruessen,\nKlaus Fischer\nEuroLogistics GmbH',
'2025-10-15', 'Klaus Fischer', 'Medium'),

(26, 'AmeriParts Inc.', 3, 'Quarterly Business Update - Q3 2025',
'Dear Partner,\n\nPlease find below our Q3 2025 performance summary for your account:\n\n- On-time delivery rate: 96.2% (target: 95%)\n- Quality rejection rate: 0.12% (target: <0.5%)\n- Orders fulfilled: 47 of 48 (1 cancelled by customer)\n- Average lead time: 5.3 days (improved from 6.1 days in Q2)\n\nWe continue to invest in automation and are on track to reduce lead times further in Q4. Our new automated packaging line will be operational by November 15.\n\nThank you for your continued business.\n\nBest regards,\nDavid Chen\nAmeriParts Inc.',
'2025-10-08', 'David Chen', 'Low'),

-- Positive updates (4 emails)
(27, 'GlobalTech Components', 1, 'Early Shipment Notification - PO-2025-1203',
'Dear Logistics Team,\n\nWe are pleased to inform you that PO-2025-1203 (1,200 units of Smart LED Light Bulbs) has been completed 5 days ahead of schedule. The shipment is ready for pickup at our Guangzhou warehouse.\n\nTracking details:\n- Carrier: DHL Express\n- Tracking: DHL-8834567\n- Estimated arrival: December 10, 2025 (3 days earlier than scheduled)\n\nAll units have passed our enhanced quality inspection with a 99.7% pass rate. Certificates of compliance are included in the shipping documentation.\n\nBest regards,\nWang Lei\nGlobalTech Components',
'2025-12-02', 'Wang Lei', 'Low'),

(28, 'Mumbai Textiles Ltd', 2, 'Sustainability Milestone - GOTS Certification Achieved',
'Dear Valued Partners,\n\nWe are proud to announce that Mumbai Textiles Ltd has achieved Global Organic Textile Standard (GOTS) certification for our entire production facility. This certification covers:\n\n- Raw material sourcing and traceability\n- Manufacturing processes and chemical usage\n- Worker welfare and fair labor practices\n- Environmental management systems\n\nThis positions us as one of only 12 GOTS-certified large-scale textile manufacturers in India. We can now provide certified organic textiles at scale with full traceability.\n\nWe look forward to supporting your sustainability goals.\n\nWarm regards,\nAmit Patel\nMumbai Textiles Ltd',
'2025-07-15', 'Amit Patel', 'Medium'),

(29, 'Tokyo Precision Mfg', 5, 'Shipment Ahead of Schedule - Precision Bearings',
'Dear Supply Chain Team,\n\nGood news! Our production team has completed the precision bearing order (PO-2025-0998) one week ahead of the original schedule. All 800 units have passed our zero-defect quality gate.\n\nThe shipment has been dispatched via Maersk from Yokohama port. Expected transit time is 12 days to Seattle (Warehouse 7). Tracking number: MSK-JP-2025-44891.\n\nTest certificates and dimensional inspection reports are available in our supplier portal.\n\nBest regards,\nTanaka Hiroshi\nTokyo Precision Mfg',
'2025-10-28', 'Tanaka Hiroshi', 'Low'),

(30, 'Seoul Semiconductor', 6, 'New Energy-Efficient LED Chip - Samples Available',
'Dear Engineering Team,\n\nWe have developed a new generation LED chip (model SS-LED-7G) that offers 20% higher lumens-per-watt efficiency compared to our current top model. Key specifications:\n\n- Efficacy: 220 lm/W\n- Color temperature range: 2700K-6500K\n- Lifetime: 60,000 hours (L70)\n- CRI: 95+\n\nSample kits are available for evaluation. We can ship 100 units within 3 business days. If approved, volume production can begin in Q1 2026 with pricing comparable to current generation.\n\nPlease let us know if you would like to proceed with samples.\n\nBest regards,\nPark Min-jun\nSeoul Semiconductor',
'2025-11-28', 'Park Min-jun', 'Medium');

-- =============================================================================
-- LOGISTICS_INCIDENT_REPORTS (18 rows)
-- =============================================================================

INSERT INTO LOGISTICS_INCIDENT_REPORTS (REPORT_ID, INCIDENT_TYPE, WAREHOUSE_ID, SEVERITY, REPORT_DATE, REPORTED_BY, REPORT_TEXT, STATUS, RESOLUTION_DATE) VALUES
(1, 'Equipment Failure', 1, 'High', '2025-03-15', 'James Wilson, Shift Supervisor',
'At approximately 14:30 on March 15, the main conveyor belt in Zone B (Sorting Area) experienced a catastrophic motor failure. The drive motor seized without warning, causing a chain reaction that derailed approximately 40 meters of belt and scattered 23 packages across the sorting floor. No personnel were injured as the area was temporarily cleared for a scheduled break. Production in Zone B was halted for 6.5 hours while the maintenance team replaced the motor and realigned the belt system. Root cause analysis indicates the motor bearings had exceeded their service life. We have since implemented a preventive maintenance schedule for all conveyor motors with 90-day inspection intervals.',
'Resolved', '2025-03-16'),

(2, 'Inventory Discrepancy', 3, 'Medium', '2025-04-22', 'Lisa Park, Inventory Analyst',
'During the monthly cycle count in Warehouse 3 (Chicago), we identified a discrepancy of 347 units across 12 SKUs in Zone A storage racks. The system showed 4,218 units on hand but physical count was 3,871. Investigation revealed that 280 units were mislocated in adjacent rack positions due to a barcode scanner malfunction on Receiving Dock 2 that had been miscategorizing incoming pallets for approximately 5 days. The remaining 67 units appear to be a genuine shrinkage loss. Corrective actions include scanner replacement, additional spot checks for the affected period, and enhanced receiving verification procedures.',
'Resolved', '2025-04-28'),

(3, 'Shipping Damage', 2, 'Medium', '2025-05-10', 'Marcus Brown, Dock Manager',
'Three pallets of electronics (Smart LED Light Bulbs, order PO-2025-0445) arrived at Warehouse 2 (Atlanta) with significant water damage. The shrink wrap was intact but the corrugated outer packaging was visibly wet and weakened. Inspection revealed that 156 out of 480 units had moisture ingress damage and are unsalvageable. The carrier (DHL) has been notified and a damage claim filed. Photos and moisture readings have been documented. The damage appears to have occurred during the ocean freight segment, possibly from container condensation. We have requested that the supplier use moisture barrier packaging for future shipments.',
'Resolved', '2025-05-25'),

(4, 'Safety Incident', 6, 'Critical', '2025-06-03', 'Maria Garcia, Safety Officer',
'A forklift operator in Warehouse 6 (Miami) collided with a pallet rack in Zone C at approximately 09:15. The impact dislodged two upper-level pallets, which fell approximately 12 feet to the floor. The operator sustained minor bruising from the seatbelt restraint. One nearby worker was struck by falling debris and required medical attention for a cut on the forearm. The affected rack section has been cordoned off and a structural engineer inspection is scheduled. CCTV review shows the operator was traveling above the 5 mph zone limit. Immediate corrective actions include mandatory speed monitoring device installation on all forklifts and refresher safety training for all operators.',
'Resolved', '2025-06-10'),

(5, 'Equipment Failure', 4, 'Medium', '2025-06-28', 'Tom Henderson, Facilities Manager',
'The HVAC system in Warehouse 4 (Dallas) Zone A failed at 11:00 AM during a period of extreme heat (105°F outside temperature). Internal warehouse temperature rose from the target 72°F to 91°F over a 3-hour period before the backup cooling units were deployed. No temperature-sensitive inventory was stored in Zone A at the time, so product impact was minimal. The primary compressor unit was found to have a refrigerant leak. Repair was completed by the HVAC contractor within 8 hours. We have added redundant temperature monitoring alerts and are evaluating backup cooling capacity for all zones.',
'Resolved', '2025-06-29'),

(6, 'Security Breach', 1, 'High', '2025-07-12', 'Robert Kim, Security Supervisor',
'At 02:47 AM, motion sensors on Loading Dock 4 at Warehouse 1 (Newark) detected unauthorized movement. Security camera review showed two individuals attempting to access the dock area by prying open the rolling door. The intruders triggered the audible alarm system and fled before gaining entry to the warehouse interior. No inventory was stolen or damaged. Local police were notified and responded within 8 minutes. The attempted entry point has been reinforced with additional steel brackets and a secondary electronic lock. We are also adding infrared perimeter detection and increasing nighttime security patrol frequency from every 2 hours to every 45 minutes.',
'Resolved', '2025-07-13'),

(7, 'Inventory Discrepancy', 7, 'High', '2025-07-25', 'Jennifer Adams, Warehouse Manager',
'Annual physical inventory at Warehouse 7 (Seattle) revealed a significant discrepancy in the Sports & Fitness category. A total of 523 units across 8 SKUs are unaccounted for, representing approximately $18,400 in inventory value. The discrepancy is concentrated in high-value items (running shoes, fitness trackers) stored in Zone D. Security footage review is ongoing but initial analysis suggests the losses occurred over a 6-week period. We have implemented additional access controls for Zone D including badge-in/badge-out tracking and random bag checks. An internal investigation has been initiated.',
'Under Investigation', NULL),

(8, 'Shipping Damage', 5, 'Low', '2025-08-05', 'Sarah Mitchell, Receiving Clerk',
'A shipment of office supplies from Warsaw Electronics (PO-2025-0789) arrived at Warehouse 5 (Denver) with minor external packaging damage. Upon inspection, 12 units of desk organizers had cosmetic scratches on the surface but remain fully functional. The damage appears to have occurred during ground transport. The carrier has been notified and a minor damage claim of $180 has been filed. No operational impact - the units have been moved to the discount/clearance inventory pool. This is the second minor damage incident with this carrier route in the past quarter.',
'Resolved', '2025-08-08'),

(9, 'Environmental', 8, 'Critical', '2025-08-20', 'David Nguyen, Cold Storage Manager',
'Critical temperature excursion detected in Warehouse 8 (Los Angeles) Cold Storage Zone C at 03:15 AM. Temperature rose from the required -18°C to -5°C over a 4-hour period due to a compressor failure. The automated monitoring system triggered alerts at -12°C (threshold) but the on-call technician was delayed in responding. Approximately 2,400 units of frozen food products were affected. Product quality testing is underway - preliminary assessment indicates 30-40% of affected inventory may need to be condemned. Root cause is a failed compressor relay switch. Immediate corrective actions include installation of redundant compressor systems and revised on-call response protocols with maximum 30-minute response time.',
'Under Investigation', NULL),

(10, 'Safety Incident', 3, 'Medium', '2025-09-02', 'Carlos Mendez, Floor Supervisor',
'A chemical spill occurred in the cleaning supply storage area of Warehouse 3 (Chicago) at 15:45. A container of industrial floor cleaner (5 gallons) fell from a shelf and ruptured on impact. The chemical spread across approximately 100 square feet of the storage room floor. Two workers in the area experienced mild respiratory irritation and were treated on-site by the first aid team. The area was evacuated, ventilated, and the spill was contained and cleaned up by our hazmat response team within 2 hours. All chemical storage shelving has been inspected and restraining bars have been added to prevent future container falls.',
'Resolved', '2025-09-03'),

(11, 'Equipment Failure', 2, 'Low', '2025-09-18', 'Angela Peters, IT Support',
'The barcode scanning system at Receiving Dock 1 in Warehouse 2 (Atlanta) experienced intermittent failures throughout the day shift. Approximately 15% of scans required manual entry, slowing the receiving process by an estimated 2 hours. The issue was traced to a failing laser module in the fixed scanner unit. A replacement scanner was installed by end of shift and full scanning capability has been restored. Backup handheld scanners were deployed during the outage to maintain operations.',
'Resolved', '2025-09-18'),

(12, 'Shipping Damage', 6, 'Medium', '2025-09-30', 'Diana Foster, Quality Inspector',
'An inbound shipment from Shenzhen Fast Supply (PO-2025-1056) arrived at Warehouse 6 (Miami) with significant packaging crush damage. Two of five pallets showed compression damage from improper stacking during container loading. Of 600 units of electronic accessories, 89 units have confirmed damage including cracked casings and bent connectors. The carrier (UPS) and supplier have been notified. Damage claim value is estimated at $2,670. This is the fourth quality issue with shipments from this supplier in the past 6 months. Recommending a supplier performance review meeting.',
'Under Investigation', NULL),

(13, 'Safety Incident', 4, 'Low', '2025-10-08', 'Kevin O''Brien, Safety Coordinator',
'A minor slip-and-fall incident occurred in Warehouse 4 (Dallas) near the break room entrance at 12:30 PM. An employee slipped on a wet floor that had been mopped but the wet floor sign had fallen over and was not visible. The employee sustained a bruised knee and returned to work after a 30-minute rest. First aid was administered on-site. No lost work time. Corrective action: All wet floor signs have been replaced with weighted-base models that resist tipping, and the janitorial team has been reminded to verify signage placement after mopping.',
'Resolved', '2025-10-08'),

(14, 'IT System Outage', 3, 'High', '2025-10-22', 'Patrick Wu, IT Manager',
'The Warehouse Management System (WMS) at Warehouse 3 (Chicago) experienced a complete outage from 08:15 to 13:45 due to a database server crash. All pick, pack, and ship operations were halted as the system was unavailable. Manual paper-based picking was initiated for priority orders at 09:30. The database crash was caused by a storage array failure that corrupted the transaction log. Data was restored from the previous night''s backup with approximately 2 hours of transactions lost. Total impact: 847 orders delayed by 4-6 hours, 12 missed carrier pickup windows. Post-incident review has recommended real-time database replication to a standby server.',
'Resolved', '2025-10-23'),

(15, 'Environmental', 5, 'Medium', '2025-10-30', 'Rachel Torres, Facilities Coordinator',
'Routine air quality monitoring at Warehouse 5 (Denver) detected elevated particulate matter levels in Zones B and C. PM2.5 readings were 35-42 µg/m³, exceeding our internal threshold of 25 µg/m³. The elevated levels are attributed to nearby construction activity and inadequate air filtration. While not at immediately dangerous levels, prolonged exposure could affect worker respiratory health. Temporary HEPA filtration units have been deployed and the HVAC filters have been upgraded from MERV-8 to MERV-13. Workers in affected zones have been provided N95 masks as a precautionary measure. Levels are expected to return to normal once construction activity subsides.',
'Under Investigation', NULL),

(16, 'Security Breach', 7, 'Medium', '2025-11-05', 'Steven Chang, Loss Prevention Manager',
'Internal investigation at Warehouse 7 (Seattle) identified an employee who had been systematically diverting small quantities of high-value electronics inventory over the past two months. The employee used their legitimate system access to mark items as damaged/returned when they were actually removed from the facility. Total estimated loss: $4,200 across 15 incidents. The employee has been terminated and the matter has been referred to local law enforcement. System controls have been enhanced to require supervisor approval for all damage/return dispositions, and random audits of disposed items have been implemented.',
'Resolved', '2025-11-12'),

(17, 'Equipment Failure', 8, 'Critical', '2025-11-18', 'Amy Richardson, Operations Manager',
'The backup generator at Warehouse 8 (Los Angeles) failed to start during a scheduled power outage for utility maintenance. The primary power was off for 3.5 hours. Cold storage temperatures began rising within 45 minutes. Emergency portable refrigeration units were brought in within 90 minutes, limiting the temperature rise to 4°C above target in the most affected zone. Approximately 800 units of perishable goods experienced partial thawing. Quality testing is in progress. The generator failure was due to a dead starter battery and corroded fuel line connections. A full generator overhaul has been scheduled and monthly test runs have been mandated.',
'Resolved', '2025-11-20'),

(18, 'Inventory Discrepancy', 1, 'Low', '2025-12-01', 'Michelle Tran, Inventory Supervisor',
'End-of-month inventory reconciliation at Warehouse 1 (Newark) identified a net overage of 78 units across 5 SKUs in the Home & Kitchen category. Investigation determined that a supplier (AmeriParts Inc.) had shipped an extra partial pallet that was received and put away but not properly recorded in the system. The receiving dock team confirmed the pallet was delivered on November 28 but the PO match failed due to the quantity exceeding the order by 78 units. The supplier has been contacted and confirmed the overage was a shipping error. They have agreed to invoice us at standard pricing for the extra units rather than arranging a return shipment.',
'Resolved', '2025-12-05');

-- =============================================================================
-- WAREHOUSE_INSPECTION_NOTES (15 rows)
-- =============================================================================

INSERT INTO WAREHOUSE_INSPECTION_NOTES (INSPECTION_ID, WAREHOUSE_ID, INSPECTION_DATE, INSPECTOR, INSPECTION_NOTES, OVERALL_RATING, FOLLOW_UP_REQUIRED) VALUES
(1, 1, '2025-02-10', 'Robert Chen, Senior Inspector',
'Warehouse 1 (East Coast Hub, Newark) annual safety inspection. Facility is well-maintained and organized. All 48 fire extinguishers are current on inspection tags and properly mounted. Emergency exits are clearly marked with illuminated signage and unobstructed. Sprinkler system passed flow test on January 28. Pallet racking in all zones is straight and undamaged with proper load placards displayed. Floor markings for pedestrian walkways and forklift lanes are in good condition. PPE compliance observed at 97% during walk-through (3 workers missing safety vests). First aid stations are fully stocked. Loading docks are clean and dock levelers are functioning properly. Pest control logs are current with no reported issues. Overall, this is one of our best-maintained facilities.',
'Excellent', FALSE),

(2, 2, '2025-03-18', 'Karen Mitchell, Safety Auditor',
'Warehouse 2 (Southeast Hub, Atlanta) quarterly inspection. General facility condition is good. Dock area is clean and organized. However, noted several concerns: Two emergency exit lights in Zone C were non-functional and need immediate replacement. One section of pallet racking in Zone A (Row 12, Bays 8-14) shows minor impact damage from forklift contact - structural integrity appears unaffected but should be monitored. Temperature monitoring logs show consistent compliance at 68-74°F. Restroom facilities are clean. Loading dock #3 has a hydraulic leak on the dock leveler that has been reported but not yet repaired. Staff were wearing appropriate PPE. Recommend scheduling the rack repair and exit light replacement within 2 weeks.',
'Good', FALSE),

(3, 3, '2025-04-05', 'Robert Chen, Senior Inspector',
'Warehouse 3 (Midwest Hub, Chicago) semi-annual inspection. The facility shows signs of heavy usage and some deferred maintenance. Floor condition in Zone B has deteriorated with multiple cracks and uneven surfaces that pose trip hazards. Three sections of racking have been repaired with non-standard brackets that do not meet manufacturer specifications. Fire extinguisher inspection was 2 months overdue on 8 units. Emergency evacuation plan posted is dated 2023 and does not reflect the current floor layout after the Zone D expansion. Positive notes: pest control is excellent, break room is clean and well-maintained, and loading dock operations appear efficient. Recommend prioritizing floor repair in Zone B and updating the evacuation plan.',
'Fair', TRUE),

(4, 4, '2025-05-12', 'Lisa Yamamoto, Compliance Inspector',
'Warehouse 4 (South Central Hub, Dallas) routine safety inspection. Facility is in good condition overall. HVAC system is functioning properly with temperatures maintained at target levels despite recent heat wave. All safety equipment is current and accessible. Storage organization is excellent with clear labeling and proper FIFO rotation observed. One concern: the chemical storage area lacks secondary containment as required by OSHA standards - spill containment pallets should be installed under all chemical storage racks. Staff safety training records are up to date. Dock area is clean with proper trailer chocking procedures being followed. Parking lot lighting was adequate for late-shift operations. Overall a well-run facility with one compliance item to address.',
'Good', FALSE),

(5, 5, '2025-06-20', 'Sarah Thompson, Quality Auditor',
'Warehouse 5 (Mountain Hub, Denver) annual inspection. Facility is generally well-maintained but showing its age. The roof has several areas where water staining on ceiling tiles indicates possible leaks - facilities manager confirmed repairs are scheduled for July. Air quality readings were slightly elevated (PM2.5 at 28 µg/m³) likely due to nearby construction, but within acceptable limits. Racking is in good condition with proper load ratings displayed. Fire suppression system passed inspection. Emergency exits are clear and properly marked. Staff compliance with PPE requirements was excellent at 100% during observation period. Forklift fleet is well-maintained with current inspection stickers. Recommend monitoring the roof situation closely and installing additional air filtration if construction continues.',
'Good', FALSE),

(6, 6, '2025-07-08', 'Karen Mitchell, Safety Auditor',
'Warehouse 6 (Southeast Fulfillment, Miami) post-incident follow-up inspection after the June 3 forklift collision. The damaged pallet rack section in Zone C has been fully replaced with new uprights and beams. Structural engineer certification is on file. New speed monitoring devices have been installed on all 12 forklifts and are functioning correctly. Speed limit signage has been added at all zone transitions. However, I noted additional concerns during this visit: humidity levels in Zone A are consistently above 65% (target <60%), which could affect product quality for moisture-sensitive items. Two dock door seals are worn and allowing outside air infiltration. The break room refrigerator temperature was 48°F (should be below 40°F). Staff appear attentive to the new safety procedures.',
'Fair', TRUE),

(7, 7, '2025-08-15', 'Robert Chen, Senior Inspector',
'Warehouse 7 (Pacific NW Hub, Seattle) quarterly inspection. Facility is in fair condition with several notable issues. The ongoing inventory shrinkage investigation has resulted in enhanced security measures that are visible and appear effective (badge readers, cameras, bag check station). However, general housekeeping has declined - multiple aisles in Zones C and D have loose products and debris on the floor creating trip hazards. Three of the four dock door weather seals need replacement as they are allowing water ingress during Seattle''s frequent rain. The mezzanine level storage area has boxes stacked above the safe height limit on multiple shelving units. Pest control report from last month noted rodent activity near the south wall and bait stations have been deployed. Fire safety equipment is current. Recommend immediate attention to housekeeping and shelving height compliance.',
'Fair', TRUE),

(8, 8, '2025-09-01', 'Michael Torres, Cold Storage Specialist',
'Warehouse 8 (West Coast Hub, Los Angeles) specialized cold storage inspection following the August 20 temperature excursion incident. CRITICAL FINDINGS: The primary compressor system is 8 years old and showing signs of wear beyond normal aging. The failed relay switch has been replaced but two other compressor units show early indicators of similar degradation. The redundant compressor system installation (recommended after the incident) has not yet been completed - contractor quotes are pending. Temperature monitoring alert thresholds have been tightened from -12°C to -15°C, which is appropriate. The backup generator issue from November has been addressed with a new battery, but the corroded fuel lines have only been patched, not replaced. Personnel response time drill showed 52-minute response time vs. the new 30-minute target. This facility requires significant investment in equipment upgrades to meet cold chain reliability standards.',
'Poor', TRUE),

(9, 1, '2025-09-22', 'Lisa Yamamoto, Compliance Inspector',
'Warehouse 1 (East Coast Hub, Newark) follow-up compliance inspection. All items from the February inspection remain in good standing. Additional observations: New LED lighting installation in Zones A and B has significantly improved visibility - measured at 55 foot-candles vs. the minimum 30 required. Energy consumption has reportedly decreased 20% since the lighting upgrade. The security enhancement (infrared perimeter detection) installed after the July attempted break-in is operational and has been tested. Dock area traffic management has improved with the new one-way flow pattern. Staff morale appears good with low turnover reported. Minor note: the employee break area vending machines are partially blocking a secondary exit path and should be relocated 3 feet to the right. Overall, this continues to be a model facility.',
'Excellent', FALSE),

(10, 3, '2025-10-10', 'Sarah Thompson, Quality Auditor',
'Warehouse 3 (Midwest Hub, Chicago) follow-up from April inspection. The floor repairs in Zone B have been completed and the surface is now level and crack-free. The emergency evacuation plan has been updated to reflect the current layout. Fire extinguisher inspections are now current. However, the non-standard racking brackets identified in April have NOT been replaced - this is now a repeat finding and must be addressed urgently. Additionally, the WMS outage in October exposed gaps in our manual backup procedures. During the outage, products were placed in incorrect locations and some inventory records still have not been fully reconciled. New finding: loading dock 5 has a cracked concrete apron that is causing trailer alignment issues. Recommend escalating the racking bracket replacement to management.',
'Fair', TRUE),

(11, 2, '2025-10-25', 'Robert Chen, Senior Inspector',
'Warehouse 2 (Southeast Hub, Atlanta) follow-up inspection. Previous findings have been addressed: emergency exit lights in Zone C replaced and functional, dock leveler #3 hydraulic leak repaired. The racking damage in Zone A Row 12 has been professionally repaired by the rack manufacturer''s certified installer. New observations: the facility has implemented a new 5S program and the improvement in organization is noticeable throughout. Pick accuracy has reportedly improved 12% since implementation. Temperature and humidity levels are well-controlled. One new concern: the pest control vendor has noted an increase in ant activity around the south loading docks, likely seasonal. Treatment has been applied but monitoring should continue. All safety training records reviewed are current and complete.',
'Good', FALSE),

(12, 4, '2025-11-05', 'Karen Mitchell, Safety Auditor',
'Warehouse 4 (South Central Hub, Dallas) follow-up on chemical storage compliance finding from May. Spill containment pallets have been installed under all chemical storage racks in compliance with OSHA requirements. Documentation and SDS sheets are properly organized and accessible. Additional inspection notes: the facility has been dealing with high staff turnover (35% in the past quarter) and several new hires were observed operating equipment without a buddy system in place. While all new hires have completed safety orientation, the practical experience component should be strengthened. Forklift certification records for 3 new operators were not yet on file. Break room and restroom facilities are clean and well-maintained. Overall the facility is well-managed but the staffing situation needs attention to maintain safety standards.',
'Good', FALSE),

(13, 8, '2025-11-20', 'Michael Torres, Cold Storage Specialist',
'Warehouse 8 (West Coast Hub, Los Angeles) critical follow-up inspection. URGENT: The redundant compressor installation that was recommended in September has still not been completed. The facility is operating on aging primary compressors with no backup, which is an unacceptable risk for a cold storage operation handling perishable goods worth an estimated $1.2 million at any given time. The backup generator fuel lines remain patched rather than replaced. Temperature monitoring improvements from September are functioning correctly. Personnel drill response time has improved to 38 minutes but still exceeds the 30-minute target. Positive note: a new digital temperature logging system has been installed that provides real-time alerts to management''s mobile phones. RECOMMENDATION: Halt acceptance of new perishable inventory until redundant compressor installation is complete. This facility is at HIGH RISK of another temperature excursion event.',
'Poor', TRUE),

(14, 6, '2025-11-28', 'Lisa Yamamoto, Compliance Inspector',
'Warehouse 6 (Southeast Fulfillment, Miami) quarterly inspection. Humidity issues identified in July have been partially addressed with new dehumidifier units in Zone A, bringing readings to 55-58% (within target). Dock door seals have been replaced on both identified doors. The break room refrigerator has been replaced. Forklift speed compliance has been excellent since the monitoring system installation - zero speed violations recorded in the past 60 days. New observation: hurricane preparedness supplies are stocked and the emergency action plan has been updated for the current hurricane season. One concern: the parking lot drainage system is backing up near dock 6 during heavy rains, creating a standing water hazard. Facilities team is aware and a drainage contractor has been engaged.',
'Good', FALSE),

(15, 7, '2025-12-05', 'Sarah Thompson, Quality Auditor',
'Warehouse 7 (Pacific NW Hub, Seattle) end-of-year inspection. Housekeeping has improved moderately since August - main aisles are clear but secondary aisles in Zone D still have items stored outside designated areas. Dock door weather seals have been replaced on 2 of 4 doors identified; remaining 2 are scheduled for December 15. Mezzanine storage height compliance has improved to 90% from approximately 60% in August. The inventory shrinkage investigation has been closed with one employee terminated and $4,200 in losses recovered through insurance. Enhanced security measures (badge access, cameras, random checks) will remain permanent. Pest control situation has improved with no recent rodent activity detected. New concern: the fire alarm system showed a false alarm on November 30 and the alarm company has been unable to identify the cause. Recommend thorough fire alarm system diagnostic before year-end.',
'Fair', TRUE);
