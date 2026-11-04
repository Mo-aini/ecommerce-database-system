-- =============================================================
-- E-Commerce Database System - 22 example queries
-- Each query has a short comment explaining what it answers.
-- =============================================================
USE ecommerce_db;

-- Q1. All products in the 'Laptops' category, cheapest first (simple JOIN + ORDER BY)
SELECT p.sku, p.name, p.price
FROM products p
JOIN categories c ON c.category_id = p.category_id
WHERE c.name = 'Laptops'
ORDER BY p.price;

-- Q2. Products with their parent category (self-join on categories)
SELECT p.name AS product, c.name AS category, parent.name AS parent_category
FROM products p
JOIN categories c           ON c.category_id = p.category_id
LEFT JOIN categories parent ON parent.category_id = c.parent_id
ORDER BY parent_category, category, product
LIMIT 10;

-- Q3. Number of orders per status
SELECT status, COUNT(*) AS orders
FROM orders
GROUP BY status
ORDER BY orders DESC;

-- Q4. Revenue per month (only paid/shipped/delivered orders)
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       COUNT(*)                         AS orders,
       SUM(total_amount)                AS revenue
FROM orders
WHERE status IN ('paid', 'shipped', 'delivered')
GROUP BY month
ORDER BY month;

-- Q5. Top 5 best-selling products by units sold
SELECT p.name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o   ON o.order_id   = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY p.product_id, p.name
ORDER BY units_sold DESC, p.name
LIMIT 5;

-- Q6. Revenue by top-level category (rolls sub-categories up to their parent)
SELECT COALESCE(parent.name, c.name) AS top_category,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN orders o            ON o.order_id = oi.order_id AND o.status <> 'cancelled'
JOIN products p          ON p.product_id = oi.product_id
JOIN categories c        ON c.category_id = p.category_id
LEFT JOIN categories parent ON parent.category_id = c.parent_id
GROUP BY top_category
ORDER BY revenue DESC;

-- Q7. Customers who spent more than PKR 150,000 in total (GROUP BY + HAVING)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer,
       COUNT(o.order_id)  AS orders,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status <> 'cancelled'
GROUP BY c.customer_id, customer
HAVING total_spent > 150000
ORDER BY total_spent DESC;

-- Q8. Customers who have never placed an order (LEFT JOIN / IS NULL)
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- Q9. Products that were never ordered (NOT EXISTS subquery)
SELECT p.sku, p.name
FROM products p
WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id);

-- Q10. Products priced above the average price of their own category (correlated subquery)
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON c.category_id = p.category_id
WHERE p.price > (SELECT AVG(p2.price) FROM products p2 WHERE p2.category_id = p.category_id)
ORDER BY c.name, p.price DESC;

-- Q11. Average order value per city (join through the shipping address)
SELECT a.city, COUNT(*) AS orders, ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM orders o
JOIN addresses a ON a.address_id = o.shipping_address_id
WHERE o.status <> 'cancelled'
GROUP BY a.city
ORDER BY avg_order_value DESC;

-- Q12. Payment method share (count and % of completed payments)
SELECT method,
       COUNT(*) AS payments,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM payments
WHERE status = 'completed'
GROUP BY method
ORDER BY payments DESC;

-- Q13. Rank products by price inside each category (window function RANK)
SELECT c.name AS category, p.name, p.price,
       RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS price_rank
FROM products p
JOIN categories c ON c.category_id = p.category_id
ORDER BY c.name, price_rank
LIMIT 12;

-- Q14. Running total of revenue over time (window SUM ... OVER ORDER BY)
SELECT order_id, DATE(order_date) AS day, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date, order_id) AS running_revenue
FROM orders
WHERE status IN ('paid', 'shipped', 'delivered')
ORDER BY order_date, order_id
LIMIT 15;

-- Q15. Each customer's previous order date and the gap in days (LAG)
SELECT customer_id, order_id, DATE(order_date) AS order_day,
       DATE(LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS previous_order,
       DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_between
FROM orders
ORDER BY customer_id, order_date
LIMIT 15;

-- Q16. Top customer in every city (CTE + ROW_NUMBER)
WITH spend AS (
    SELECT a.city,
           CONCAT(c.first_name, ' ', c.last_name) AS customer,
           SUM(o.total_amount) AS total_spent
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN addresses a ON a.address_id  = o.shipping_address_id
    WHERE o.status <> 'cancelled'
    GROUP BY a.city, c.customer_id, customer
), ranked AS (
    SELECT spend.*, ROW_NUMBER() OVER (PARTITION BY city ORDER BY total_spent DESC) AS rn
    FROM spend
)
SELECT city, customer, total_spent
FROM ranked
WHERE rn = 1
ORDER BY total_spent DESC;

-- Q17. Month-over-month revenue growth (CTE + LAG)
WITH monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
    FROM orders
    WHERE status IN ('paid', 'shipped', 'delivered')
    GROUP BY month
)
SELECT month, revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS growth_pct
FROM monthly
ORDER BY month;

-- Q18. Customer segments by lifetime value (CASE)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer,
       COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
       CASE
           WHEN COALESCE(SUM(o.total_amount), 0) >= 300000 THEN 'Gold'
           WHEN COALESCE(SUM(o.total_amount), 0) >= 100000 THEN 'Silver'
           WHEN COALESCE(SUM(o.total_amount), 0) > 0       THEN 'Bronze'
           ELSE 'No orders'
       END AS segment
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id AND o.status <> 'cancelled'
GROUP BY c.customer_id, customer
ORDER BY lifetime_value DESC;

-- Q19. Best-rated products with at least 2 reviews
SELECT p.name, ROUND(AVG(r.rating), 2) AS avg_rating, COUNT(*) AS reviews
FROM reviews r
JOIN products p ON p.product_id = r.product_id
GROUP BY p.product_id, p.name
HAVING COUNT(*) >= 2
ORDER BY avg_rating DESC, reviews DESC;

-- Q20. Orders whose payment total does not match the order total (data-quality check)
SELECT o.order_id, o.total_amount, COALESCE(SUM(pay.amount), 0) AS paid
FROM orders o
LEFT JOIN payments pay ON pay.order_id = o.order_id AND pay.status = 'completed'
WHERE o.status IN ('paid', 'shipped', 'delivered')
GROUP BY o.order_id, o.total_amount
HAVING paid <> o.total_amount;

-- Q21. Low-stock report (uses the view)
SELECT * FROM v_low_stock ORDER BY quantity;

-- Q22. Pending cash-on-delivery amount still to be collected
SELECT COUNT(*) AS pending_cod_orders, COALESCE(SUM(pay.amount), 0) AS amount_to_collect
FROM payments pay
WHERE pay.method = 'cash_on_delivery' AND pay.status = 'pending';

-- Q23. Products frequently bought together (self-join on order_items)
SELECT p1.name AS product_a, p2.name AS product_b, COUNT(*) AS times_together
FROM order_items a
JOIN order_items b ON b.order_id = a.order_id AND b.product_id > a.product_id
JOIN products p1   ON p1.product_id = a.product_id
JOIN products p2   ON p2.product_id = b.product_id
GROUP BY p1.name, p2.name
HAVING times_together >= 1
ORDER BY times_together DESC, product_a
LIMIT 5;

-- Q24. Order summary view: the 5 biggest orders
SELECT * FROM v_order_summary ORDER BY total_amount DESC LIMIT 5;
