-- =============================================================
-- E-Commerce Database System - seed data
-- Run AFTER schema.sql and triggers.sql (the triggers fill in order
-- totals and decrement stock while order_items are inserted).
-- Prices are in PKR. All people and addresses are fictional.
-- =============================================================
USE ecommerce_db;

-- ---------- categories ----------
INSERT INTO categories (category_id, name, parent_id, description) VALUES
  (1, 'Electronics', NULL, 'Phones, laptops and accessories'),
  (2, 'Mobile Phones', 1, 'Smartphones and feature phones'),
  (3, 'Laptops', 1, 'Notebooks and ultrabooks'),
  (4, 'Accessories', 1, 'Chargers, cables, headphones'),
  (5, 'Fashion', NULL, 'Clothing and footwear'),
  (6, 'Men', 5, 'Menswear'),
  (7, 'Women', 5, 'Womenswear'),
  (8, 'Home & Kitchen', NULL, 'Appliances and kitchenware'),
  (9, 'Books', NULL, 'Textbooks and novels'),
  (10, 'Sports', NULL, 'Fitness and outdoor gear');

-- ---------- customers ----------
-- password_hash values are dummy bcrypt-shaped strings for demo data only
INSERT INTO customers (first_name, last_name, email, phone, password_hash, created_at) VALUES
  ('Ahmed', 'Khan', 'ahmed.khan82@example.com', '+92-300-5614226', '$2b$12$FCrnl2edlBDdz1C5Jau2RJtBRnlWmTSHf6pWkLUyifDLkDmWJ6UuV', '2025-06-07 18:17:00'),
  ('Ayesha', 'Malik', 'ayesha.malik21@example.com', '+92-336-5528972', '$2b$12$CPhDeOZIiBOB/Y6sHrFH2ZUCr/lgotu2iXW7GboIRoL3u6aHwnMzt', '2025-06-25 10:34:00'),
  ('Bilal', 'Raza', 'bilal.raza77@example.com', '+92-327-1326765', '$2b$12$oUNEhEkk.iqq8vH2BzNZV45pFCiRcDCajhDieQjEJ.Bq8F80ymm3T', '2025-07-14 15:55:00'),
  ('Fatima', 'Siddiqui', 'fatima.siddiqui52@example.com', '+92-321-5171761', '$2b$12$yy5r2xJ7Fj4mgblEv0.9BZhvWaXH6K2.tyLBhhOhg9uhkxiiEZpFf', '2025-02-14 18:37:00'),
  ('Hamza', 'Qureshi', 'hamza.qureshi27@example.com', '+92-323-5456272', '$2b$12$YqM6Ojb6mjBHqSiFVKu4MbMnrHontIKARAH.Ggl2JfaQqHu42bojt', '2025-09-02 21:23:00'),
  ('Hira', 'Butt', 'hira.butt6@example.com', '+92-323-5186414', '$2b$12$nT0tEuw0dwQ0FIunWe8Cz6SNDCdyZQJiJSZQdoHwHen3SO3oXyGf3', '2025-01-17 22:51:00'),
  ('Usman', 'Chaudhry', 'usman.chaudhry56@example.com', '+92-305-6266630', '$2b$12$pMN0PZLqy1WwMZaMKA3P744B8vkKQlENCzsdfF8j61yX/ZFsan2Cw', '2025-09-15 08:35:00'),
  ('Zainab', 'Sheikh', 'zainab.sheikh18@example.com', '+92-338-6323376', '$2b$12$425u85HFJ.EJ4jKEIQOkrtDXtBi10Q71hA1XcW9aTMX1C.CI3.dXR', '2025-07-24 10:53:00'),
  ('Ali', 'Iqbal', 'ali.iqbal69@example.com', '+92-306-1454696', '$2b$12$k2r7xgHWPB6PRWJ1Gk8cgSCifdFzctEq8oB7GVvouNndNWYzjFnMp', '2025-01-12 16:27:00'),
  ('Maryam', 'Hussain', 'maryam.hussain63@example.com', '+92-306-7076506', '$2b$12$6t3wI973IPFlJ5F7WRd/Px.BTHRJJbykE0.E8.5clLCZFNV8S2QT6', '2025-05-10 12:14:00'),
  ('Omar', 'Ahmed', 'omar.ahmed16@example.com', '+92-342-4213524', '$2b$12$B9JKmyLDUwMbqJfgLq.nbK894RxgG9oiZ.jgttMkFp1CW54M2NhmA', '2025-04-09 18:05:00'),
  ('Sana', 'Javed', 'sana.javed10@example.com', '+92-310-7853787', '$2b$12$58LeDKK6jDHz2oCtIsjhvNK4p7MZI/4kf3PGdlDcIfw84Jx3.l8S0', '2025-06-11 18:06:00'),
  ('Hassan', 'Mirza', 'hassan.mirza89@example.com', '+92-334-7718473', '$2b$12$e6lOGPoZa70gyU/4gAIqK4.pdEuNb0lCo7pt/LI198F6sXyriJ1RI', '2025-01-10 19:19:00'),
  ('Iqra', 'Farooq', 'iqra.farooq62@example.com', '+92-325-7328534', '$2b$12$6PyEXD0fO8WXt/eqQm4m6bs0tj8HRYkQWO.eiEKDl3mm4vMdfPhLT', '2025-06-14 10:15:00'),
  ('Saad', 'Akhtar', 'saad.akhtar22@example.com', '+92-311-7418028', '$2b$12$E/sD7G6Gb7Kuj4SM2G6MzX9nEWTLLcYJbg/KDTCyGrmfN4eUqlLP1', '2025-03-07 10:50:00'),
  ('Noor', 'Shah', 'noor.shah65@example.com', '+92-322-5311242', '$2b$12$9LRo7jsCYUlYbHp6VHWVnD8dPCi7M0orfeM/omErX6V1t1m.0JeVB', '2025-08-15 11:54:00'),
  ('Fahad', 'Anwar', 'fahad.anwar83@example.com', '+92-320-7679674', '$2b$12$Jyp6lBcgQFqAiABDQsaJsqGwodqbTEPcwHgq1oi85Un5CfM6dh9Z2', '2025-02-16 19:58:00'),
  ('Amna', 'Rashid', 'amna.rashid36@example.com', '+92-349-6455706', '$2b$12$WL63moB35D0R6Z1mO2OGVt8ilkl3mVqhQp0T2gKNTnBt9CnSVoJC2', '2025-09-25 21:39:00'),
  ('Yusuf', 'Nawaz', 'yusuf.nawaz78@example.com', '+92-320-4026879', '$2b$12$INRSaxsZisdlBW16RuVNPkgtugkI42.41IBoS3oK.NfCYhaAMBrGL', '2025-06-04 08:31:00'),
  ('Khadija', 'Aslam', 'khadija.aslam49@example.com', '+92-343-9393009', '$2b$12$TjYf3c6jO2Z1LoZcPv6Ul3nF3ZkYNRCQvjoySSsEnsGzwtjw/75PO', '2025-03-15 09:30:00'),
  ('Rehan', 'Latif', 'rehan.latif7@example.com', '+92-321-5550147', '$2b$12$demoDemoDemoDemoDemoDemoDemoDemoDemoDemoDemoDemoDemoD', '2025-10-20 18:05:00'),
  ('Mahnoor', 'Tariq', 'mahnoor.tariq3@example.com', '+92-333-5550192', '$2b$12$demoDemoDemoDemoDemoDemoDemoDemoDemoDemoDemoDemoDemoF', '2025-10-27 11:40:00');

-- ---------- addresses ----------
INSERT INTO addresses (customer_id, label, line1, line2, city, province, postal_code, country, is_default) VALUES
  (1, 'Home', 'House 240, Street 5', 'Cantt', 'Multan', 'Punjab', '60000', 'Pakistan', TRUE),
  (1, 'Office', 'Office 6, Plaza 9', 'Model Town', 'Multan', 'Punjab', '60000', 'Pakistan', FALSE),
  (2, 'Home', 'House 237, Street 34', 'Gulberg III', 'Peshawar', 'KP', '25000', 'Pakistan', TRUE),
  (3, 'Home', 'House 14, Street 7', 'Gulberg III', 'Multan', 'Punjab', '60000', 'Pakistan', TRUE),
  (4, 'Home', 'House 134, Street 21', 'Clifton Block 4', 'Faisalabad', 'Punjab', '38000', 'Pakistan', TRUE),
  (5, 'Home', 'House 142, Street 10', 'Satellite Town', 'Faisalabad', 'Punjab', '38000', 'Pakistan', TRUE),
  (5, 'Office', 'Office 2, Plaza 5', 'F-10 Markaz', 'Karachi', 'Sindh', '74200', 'Pakistan', FALSE),
  (6, 'Home', 'House 176, Street 13', 'F-10 Markaz', 'Faisalabad', 'Punjab', '38000', 'Pakistan', TRUE),
  (7, 'Home', 'House 235, Street 8', 'Bahria Town', 'Karachi', 'Sindh', '74200', 'Pakistan', TRUE),
  (8, 'Home', 'House 236, Street 9', 'Cantt', 'Rawalpindi', 'Punjab', '46000', 'Pakistan', TRUE),
  (9, 'Home', 'House 95, Street 5', 'G-11/2', 'Multan', 'Punjab', '60000', 'Pakistan', TRUE),
  (9, 'Office', 'Office 11, Plaza 1', 'Satellite Town', 'Multan', 'Punjab', '60000', 'Pakistan', FALSE),
  (10, 'Home', 'House 185, Street 13', 'F-10 Markaz', 'Lahore', 'Punjab', '54000', 'Pakistan', TRUE),
  (11, 'Home', 'House 62, Street 12', 'G-11/2', 'Karachi', 'Sindh', '74200', 'Pakistan', TRUE),
  (12, 'Home', 'House 42, Street 22', 'Satellite Town', 'Peshawar', 'KP', '25000', 'Pakistan', TRUE),
  (13, 'Home', 'House 151, Street 38', 'Bahria Town', 'Peshawar', 'KP', '25000', 'Pakistan', TRUE),
  (13, 'Office', 'Office 5, Plaza 8', 'G-11/2', 'Peshawar', 'KP', '25000', 'Pakistan', FALSE),
  (14, 'Home', 'House 106, Street 37', 'DHA Phase 5', 'Faisalabad', 'Punjab', '38000', 'Pakistan', TRUE),
  (15, 'Home', 'House 225, Street 24', 'G-11/2', 'Faisalabad', 'Punjab', '38000', 'Pakistan', TRUE),
  (16, 'Home', 'House 26, Street 24', 'G-11/2', 'Islamabad', 'ICT', '44000', 'Pakistan', TRUE),
  (17, 'Home', 'House 19, Street 6', 'F-10 Markaz', 'Rawalpindi', 'Punjab', '46000', 'Pakistan', TRUE),
  (17, 'Office', 'Office 5, Plaza 2', 'DHA Phase 5', 'Faisalabad', 'Punjab', '38000', 'Pakistan', FALSE),
  (18, 'Home', 'House 173, Street 36', 'Gulberg III', 'Faisalabad', 'Punjab', '38000', 'Pakistan', TRUE),
  (19, 'Home', 'House 111, Street 12', 'DHA Phase 5', 'Multan', 'Punjab', '60000', 'Pakistan', TRUE),
  (20, 'Home', 'House 162, Street 20', 'Clifton Block 4', 'Rawalpindi', 'Punjab', '46000', 'Pakistan', TRUE),
  (21, 'Home', 'House 18, Street 6', 'Wapda Town', 'Lahore', 'Punjab', '54000', 'Pakistan', TRUE),
  (22, 'Home', 'Flat 4B, Block 2', 'Gulshan-e-Iqbal', 'Karachi', 'Sindh', '75300', 'Pakistan', TRUE);

-- ---------- products ----------
INSERT INTO products (category_id, sku, name, description, price) VALUES
  (2, 'MOB-001', 'Samsung Galaxy A55 5G 8/256GB', 'Samsung Galaxy A55 5G 8/256GB - genuine product with local warranty.', 129999.00),
  (2, 'MOB-002', 'Infinix Note 40 Pro', 'Infinix Note 40 Pro - genuine product with local warranty.', 64999.00),
  (2, 'MOB-003', 'Xiaomi Redmi Note 13', 'Xiaomi Redmi Note 13 - genuine product with local warranty.', 54999.00),
  (2, 'MOB-004', 'Tecno Spark 20 Pro', 'Tecno Spark 20 Pro - genuine product with local warranty.', 42999.00),
  (3, 'LAP-001', 'Lenovo IdeaPad Slim 3 Ryzen 5', 'Lenovo IdeaPad Slim 3 Ryzen 5 - genuine product with local warranty.', 149999.00),
  (3, 'LAP-002', 'HP Victus 15 Gaming Laptop', 'HP Victus 15 Gaming Laptop - genuine product with local warranty.', 239999.00),
  (3, 'LAP-003', 'Dell Inspiron 15 3520 i5', 'Dell Inspiron 15 3520 i5 - genuine product with local warranty.', 174999.00),
  (3, 'LAP-004', 'Apple MacBook Air M2 13\"', 'Apple MacBook Air M2 13\" - genuine product with local warranty.', 329999.00),
  (4, 'ACC-001', 'Anker 20W USB-C Charger', 'Anker 20W USB-C Charger - genuine product with local warranty.', 3499.00),
  (4, 'ACC-002', 'Audionic Airbud 550 Earbuds', 'Audionic Airbud 550 Earbuds - genuine product with local warranty.', 4999.00),
  (4, 'ACC-003', 'Logitech M185 Wireless Mouse', 'Logitech M185 Wireless Mouse - genuine product with local warranty.', 2899.00),
  (4, 'ACC-004', 'Baseus 10000mAh Power Bank', 'Baseus 10000mAh Power Bank - genuine product with local warranty.', 5999.00),
  (4, 'ACC-005', 'Ugreen USB-C to HDMI Adapter', 'Ugreen USB-C to HDMI Adapter - genuine product with local warranty.', 3299.00),
  (6, 'MEN-001', 'Cotton Kurta Shalwar - White', 'Cotton Kurta Shalwar - White - genuine product with local warranty.', 5499.00),
  (6, 'MEN-002', 'Slim Fit Denim Jeans', 'Slim Fit Denim Jeans - genuine product with local warranty.', 3999.00),
  (6, 'MEN-003', 'Leather Formal Shoes', 'Leather Formal Shoes - genuine product with local warranty.', 8999.00),
  (6, 'MEN-004', 'Polo T-Shirt Navy', 'Polo T-Shirt Navy - genuine product with local warranty.', 1999.00),
  (7, 'WMN-001', 'Embroidered Lawn 3-Piece Suit', 'Embroidered Lawn 3-Piece Suit - genuine product with local warranty.', 7499.00),
  (7, 'WMN-002', 'Chiffon Dupatta', 'Chiffon Dupatta - genuine product with local warranty.', 2499.00),
  (7, 'WMN-003', 'Women Running Sneakers', 'Women Running Sneakers - genuine product with local warranty.', 6499.00),
  (8, 'HKT-001', 'Dawlance Microwave Oven 20L', 'Dawlance Microwave Oven 20L - genuine product with local warranty.', 27999.00),
  (8, 'HKT-002', 'Philips Air Fryer 4.1L', 'Philips Air Fryer 4.1L - genuine product with local warranty.', 34999.00),
  (8, 'HKT-003', 'Non-Stick Cookware Set (7 pcs)', 'Non-Stick Cookware Set (7 pcs) - genuine product with local warranty.', 11999.00),
  (8, 'HKT-004', 'Electric Kettle 1.7L', 'Electric Kettle 1.7L - genuine product with local warranty.', 4499.00),
  (9, 'BOK-001', 'Introduction to Algorithms (CLRS) 4th Ed', 'Introduction to Algorithms (CLRS) 4th Ed - genuine product with local warranty.', 8999.00),
  (9, 'BOK-002', 'Database System Concepts 7th Ed', 'Database System Concepts 7th Ed - genuine product with local warranty.', 6999.00),
  (9, 'BOK-003', 'Clean Code - Robert C. Martin', 'Clean Code - Robert C. Martin - genuine product with local warranty.', 3999.00),
  (10, 'SPT-001', 'Cricket Bat English Willow', 'Cricket Bat English Willow - genuine product with local warranty.', 15999.00),
  (10, 'SPT-002', 'Yoga Mat 6mm', 'Yoga Mat 6mm - genuine product with local warranty.', 2299.00),
  (10, 'SPT-003', 'Adjustable Dumbbells 20kg Pair', 'Adjustable Dumbbells 20kg Pair - genuine product with local warranty.', 18999.00);

-- ---------- inventory ----------
INSERT INTO inventory (product_id, quantity, reorder_level) VALUES
  (1, 8, 5),
  (2, 47, 10),
  (3, 57, 10),
  (4, 29, 10),
  (5, 12, 5),
  (6, 15, 5),
  (7, 15, 5),
  (8, 6, 5),
  (9, 48, 10),
  (10, 78, 10),
  (11, 43, 10),
  (12, 6, 10),
  (13, 64, 10),
  (14, 63, 10),
  (15, 57, 10),
  (16, 49, 10),
  (17, 54, 10),
  (18, 62, 10),
  (19, 60, 10),
  (20, 75, 10),
  (21, 72, 10),
  (22, 27, 10),
  (23, 53, 10),
  (24, 76, 10),
  (25, 7, 10),
  (26, 45, 10),
  (27, 63, 10),
  (28, 55, 10),
  (29, 57, 10),
  (30, 34, 10);

-- ---------- orders ----------
-- Orders that were later cancelled are inserted as 'paid' and cancelled at the
-- end through the cancel_order procedure, so their stock is restored properly.
-- total_amount starts at 0; trg_order_items_after_insert keeps it in sync.
INSERT INTO orders (order_id, customer_id, shipping_address_id, order_date, status) VALUES
  (1, 1, 1, '2025-10-23 19:25:00', 'paid'),
  (2, 2, 3, '2025-07-18 15:41:00', 'paid'),
  (3, 3, 4, '2025-09-12 09:23:00', 'paid'),
  (4, 4, 5, '2025-06-05 11:04:00', 'shipped'),
  (5, 5, 6, '2025-10-17 09:42:00', 'shipped'),
  (6, 6, 8, '2025-08-05 11:11:00', 'delivered'),
  (7, 7, 9, '2025-07-22 20:15:00', 'delivered'),
  (8, 8, 10, '2025-09-08 13:51:00', 'paid'),
  (9, 9, 11, '2025-08-15 21:18:00', 'pending'),
  (10, 10, 13, '2025-09-05 22:16:00', 'delivered'),
  (11, 11, 14, '2025-09-04 20:54:00', 'paid'),
  (12, 12, 15, '2025-09-05 22:27:00', 'shipped'),
  (13, 13, 16, '2025-07-01 15:03:00', 'delivered'),
  (14, 14, 18, '2025-07-08 09:20:00', 'delivered'),
  (15, 15, 19, '2025-06-05 09:18:00', 'shipped'),
  (16, 16, 20, '2025-08-20 09:57:00', 'pending'),
  (17, 17, 21, '2025-06-27 11:35:00', 'delivered'),
  (18, 18, 23, '2025-06-14 19:50:00', 'delivered'),
  (19, 19, 24, '2025-09-08 20:09:00', 'delivered'),
  (20, 20, 25, '2025-09-14 11:42:00', 'delivered'),
  (21, 12, 15, '2025-07-24 09:22:00', 'delivered'),
  (22, 19, 24, '2025-10-25 14:08:00', 'delivered'),
  (23, 6, 8, '2025-10-15 20:30:00', 'shipped'),
  (24, 7, 9, '2025-05-11 23:19:00', 'pending'),
  (25, 7, 9, '2025-07-12 22:49:00', 'pending'),
  (26, 11, 14, '2025-07-04 21:23:00', 'delivered'),
  (27, 11, 14, '2025-06-16 20:31:00', 'paid'),
  (28, 14, 18, '2025-05-14 18:52:00', 'delivered'),
  (29, 4, 5, '2025-05-11 19:18:00', 'paid'),
  (30, 15, 19, '2025-07-15 09:46:00', 'delivered'),
  (31, 3, 4, '2025-10-21 15:23:00', 'shipped'),
  (32, 15, 19, '2025-05-05 10:15:00', 'delivered'),
  (33, 12, 15, '2025-08-25 10:36:00', 'delivered'),
  (34, 11, 14, '2025-10-09 12:07:00', 'delivered'),
  (35, 17, 21, '2025-08-18 10:16:00', 'paid'),
  (36, 16, 20, '2025-06-04 11:54:00', 'delivered'),
  (37, 3, 4, '2025-10-28 14:42:00', 'shipped'),
  (38, 6, 8, '2025-10-23 23:44:00', 'delivered'),
  (39, 16, 20, '2025-05-12 17:36:00', 'paid'),
  (40, 3, 4, '2025-05-10 15:45:00', 'delivered');

-- ---------- order_items ----------
-- (fires trigger: stock decrement + order total update)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 20, 3, 6499.00),
  (2, 5, 1, 149999.00),
  (2, 27, 3, 3999.00),
  (3, 6, 1, 239999.00),
  (3, 7, 1, 174999.00),
  (4, 26, 3, 6999.00),
  (4, 28, 1, 15999.00),
  (5, 25, 1, 8999.00),
  (5, 29, 3, 2299.00),
  (6, 20, 3, 6499.00),
  (6, 25, 1, 8999.00),
  (6, 26, 2, 6999.00),
  (6, 29, 1, 2299.00),
  (7, 10, 2, 4999.00),
  (7, 20, 3, 6499.00),
  (8, 27, 2, 3999.00),
  (8, 29, 1, 2299.00),
  (9, 14, 1, 5499.00),
  (9, 17, 1, 1999.00),
  (10, 21, 2, 27999.00),
  (11, 4, 1, 42999.00),
  (11, 10, 2, 4999.00),
  (11, 28, 1, 15999.00),
  (12, 30, 1, 18999.00),
  (13, 12, 2, 5999.00),
  (13, 17, 1, 1999.00),
  (14, 27, 3, 3999.00),
  (15, 23, 1, 11999.00),
  (15, 27, 3, 3999.00),
  (16, 1, 1, 129999.00),
  (17, 4, 1, 42999.00),
  (17, 14, 2, 5499.00),
  (17, 17, 1, 1999.00),
  (17, 20, 2, 6499.00),
  (18, 3, 1, 54999.00),
  (18, 4, 3, 42999.00),
  (18, 15, 2, 3999.00),
  (19, 1, 1, 129999.00),
  (19, 14, 3, 5499.00),
  (20, 3, 1, 54999.00),
  (20, 12, 2, 5999.00),
  (20, 17, 2, 1999.00),
  (20, 18, 1, 7499.00),
  (21, 12, 1, 5999.00),
  (22, 17, 1, 1999.00),
  (23, 3, 1, 54999.00),
  (23, 5, 1, 149999.00),
  (23, 6, 1, 239999.00),
  (23, 26, 1, 6999.00),
  (24, 13, 2, 3299.00),
  (24, 18, 1, 7499.00),
  (24, 27, 2, 3999.00),
  (25, 28, 3, 15999.00),
  (26, 13, 2, 3299.00),
  (26, 29, 3, 2299.00),
  (27, 26, 2, 6999.00),
  (27, 30, 3, 18999.00),
  (28, 18, 2, 7499.00),
  (29, 15, 3, 3999.00),
  (29, 20, 2, 6499.00),
  (30, 14, 3, 5499.00),
  (30, 20, 2, 6499.00),
  (31, 22, 1, 34999.00),
  (31, 24, 1, 4499.00),
  (31, 26, 1, 6999.00),
  (32, 2, 1, 64999.00),
  (32, 13, 1, 3299.00),
  (32, 19, 3, 2499.00),
  (33, 17, 2, 1999.00),
  (34, 24, 1, 4499.00),
  (35, 15, 3, 3999.00),
  (35, 23, 1, 11999.00),
  (36, 15, 1, 3999.00),
  (37, 3, 1, 54999.00),
  (37, 23, 3, 11999.00),
  (38, 6, 1, 239999.00),
  (38, 12, 1, 5999.00),
  (38, 17, 1, 1999.00),
  (38, 26, 1, 6999.00),
  (39, 15, 3, 3999.00),
  (39, 26, 1, 6999.00),
  (40, 14, 1, 5499.00),
  (40, 16, 2, 8999.00),
  (40, 17, 3, 1999.00),
  (40, 25, 1, 8999.00);

-- ---------- payments ----------
-- amount is read from the order so it always matches the computed total
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 1;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 2;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 3;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'wallet', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 4;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'wallet', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 5;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 6;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 7;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'wallet', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 8;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 10;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 11;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 12;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 13;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 14;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 15;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 17;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'wallet', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 18;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 19;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 20;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 21;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 22;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 23;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 26;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 27;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 28;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 29;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'card', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 30;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'wallet', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 31;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 32;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 33;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 34;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 35;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'bank_transfer', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 36;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 37;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 38;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'wallet', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 39;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'completed', DATE_ADD(order_date, INTERVAL 10 MINUTE) FROM orders WHERE order_id = 40;
-- pending orders: cash on delivery, not collected yet
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'pending', NULL FROM orders WHERE order_id = 9;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'pending', NULL FROM orders WHERE order_id = 16;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'pending', NULL FROM orders WHERE order_id = 24;
INSERT INTO payments (order_id, method, amount, status, paid_at) SELECT order_id, 'cash_on_delivery', total_amount, 'pending', NULL FROM orders WHERE order_id = 25;

-- ---------- reviews ----------
INSERT INTO reviews (product_id, customer_id, rating, comment, created_at) VALUES
  (25, 6, 5, 'Totally worth the price!', DATE_ADD('2025-08-05 11:11:00', INTERVAL 11 DAY)),
  (20, 6, 3, 'Average. Does the job.', DATE_ADD('2025-08-05 11:11:00', INTERVAL 15 DAY)),
  (29, 6, 2, 'Not as expected, quality could be better.', DATE_ADD('2025-08-05 11:11:00', INTERVAL 4 DAY)),
  (20, 7, 5, 'Excellent quality, exactly as described.', DATE_ADD('2025-07-22 20:15:00', INTERVAL 8 DAY)),
  (21, 10, 2, 'Not as expected, quality could be better.', DATE_ADD('2025-09-05 22:16:00', INTERVAL 4 DAY)),
  (17, 13, 4, 'Very good, minor issues with the box.', DATE_ADD('2025-07-01 15:03:00', INTERVAL 5 DAY)),
  (12, 13, 4, 'Good product, delivery took a bit long.', DATE_ADD('2025-07-01 15:03:00', INTERVAL 11 DAY)),
  (27, 14, 4, 'Good product, delivery took a bit long.', DATE_ADD('2025-07-08 09:20:00', INTERVAL 5 DAY)),
  (20, 17, 4, 'Very good, minor issues with the box.', DATE_ADD('2025-06-27 11:35:00', INTERVAL 12 DAY)),
  (17, 17, 3, 'Average. Does the job.', DATE_ADD('2025-06-27 11:35:00', INTERVAL 3 DAY)),
  (15, 18, 5, 'Totally worth the price!', DATE_ADD('2025-06-14 19:50:00', INTERVAL 9 DAY)),
  (3, 18, 5, 'Totally worth the price!', DATE_ADD('2025-06-14 19:50:00', INTERVAL 11 DAY)),
  (4, 18, 1, 'Stopped working after a week.', DATE_ADD('2025-06-14 19:50:00', INTERVAL 6 DAY)),
  (1, 19, 5, 'Excellent quality, exactly as described.', DATE_ADD('2025-09-08 20:09:00', INTERVAL 14 DAY)),
  (3, 20, 5, 'Fast delivery and great packaging.', DATE_ADD('2025-09-14 11:42:00', INTERVAL 10 DAY)),
  (17, 20, 4, 'Very good, minor issues with the box.', DATE_ADD('2025-09-14 11:42:00', INTERVAL 14 DAY)),
  (12, 20, 1, 'Stopped working after a week.', DATE_ADD('2025-09-14 11:42:00', INTERVAL 9 DAY)),
  (18, 20, 5, 'Totally worth the price!', DATE_ADD('2025-09-14 11:42:00', INTERVAL 4 DAY)),
  (12, 12, 4, 'Very good, minor issues with the box.', DATE_ADD('2025-07-24 09:22:00', INTERVAL 10 DAY)),
  (29, 11, 5, 'Fast delivery and great packaging.', DATE_ADD('2025-07-04 21:23:00', INTERVAL 9 DAY)),
  (18, 14, 1, 'Stopped working after a week.', DATE_ADD('2025-05-14 18:52:00', INTERVAL 8 DAY)),
  (14, 15, 5, 'Excellent quality, exactly as described.', DATE_ADD('2025-07-15 09:46:00', INTERVAL 10 DAY)),
  (19, 15, 3, 'Okay for the price.', DATE_ADD('2025-05-05 10:15:00', INTERVAL 3 DAY)),
  (2, 15, 5, 'Fast delivery and great packaging.', DATE_ADD('2025-05-05 10:15:00', INTERVAL 6 DAY)),
  (17, 12, 5, 'Excellent quality, exactly as described.', DATE_ADD('2025-08-25 10:36:00', INTERVAL 7 DAY)),
  (24, 11, 2, 'Not as expected, quality could be better.', DATE_ADD('2025-10-09 12:07:00', INTERVAL 7 DAY)),
  (15, 16, 3, 'Okay for the price.', DATE_ADD('2025-06-04 11:54:00', INTERVAL 5 DAY)),
  (26, 6, 3, 'Okay for the price.', DATE_ADD('2025-10-23 23:44:00', INTERVAL 3 DAY)),
  (12, 6, 4, 'Good product, delivery took a bit long.', DATE_ADD('2025-10-23 23:44:00', INTERVAL 8 DAY)),
  (17, 6, 5, 'Totally worth the price!', DATE_ADD('2025-10-23 23:44:00', INTERVAL 10 DAY)),
  (17, 3, 1, 'Stopped working after a week.', DATE_ADD('2025-05-10 15:45:00', INTERVAL 5 DAY)),
  (25, 3, 3, 'Okay for the price.', DATE_ADD('2025-05-10 15:45:00', INTERVAL 11 DAY));

-- ---------- cancellations (restock + refund through the procedure) ----------
CALL cancel_order(1);
CALL cancel_order(3);
CALL cancel_order(11);
