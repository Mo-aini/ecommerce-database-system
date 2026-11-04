-- =============================================================
-- E-Commerce Database System - views
-- =============================================================
USE ecommerce_db;

-- Order summary: one row per order with customer name and item count
CREATE OR REPLACE VIEW v_order_summary AS
SELECT o.order_id,
       o.order_date,
       o.status,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(oi.product_id)                   AS line_items,
       COALESCE(SUM(oi.quantity), 0)          AS units,
       o.total_amount
FROM orders o
JOIN customers c        ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY o.order_id, o.order_date, o.status, customer_name, o.total_amount;

-- Product catalog with category, stock and rating
CREATE OR REPLACE VIEW v_product_catalog AS
SELECT p.product_id,
       p.sku,
       p.name,
       cat.name                          AS category,
       p.price,
       i.quantity                        AS in_stock,
       ROUND(AVG(r.rating), 2)           AS avg_rating,
       COUNT(r.review_id)                AS review_count
FROM products p
JOIN categories cat   ON cat.category_id = p.category_id
JOIN inventory i      ON i.product_id    = p.product_id
LEFT JOIN reviews r   ON r.product_id    = p.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_id, p.sku, p.name, cat.name, p.price, i.quantity;

-- Products at or below their reorder level
CREATE OR REPLACE VIEW v_low_stock AS
SELECT p.product_id, p.sku, p.name, i.quantity, i.reorder_level
FROM products p
JOIN inventory i ON i.product_id = p.product_id
WHERE i.quantity <= i.reorder_level;
