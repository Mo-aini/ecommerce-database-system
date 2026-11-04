-- =============================================================
-- E-Commerce Database System - triggers
-- Keeps stock and order totals consistent without trusting the app.
-- =============================================================
USE ecommerce_db;

DROP TRIGGER IF EXISTS trg_order_items_before_insert;
DROP TRIGGER IF EXISTS trg_order_items_after_insert;
DROP TRIGGER IF EXISTS trg_order_items_after_delete;
DROP TRIGGER IF EXISTS trg_reviews_before_insert;

DELIMITER $$

-- 1) Refuse an order line if there is not enough stock.
CREATE TRIGGER trg_order_items_before_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    SELECT quantity INTO v_stock
    FROM inventory
    WHERE product_id = NEW.product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No inventory record for this product';
    ELSEIF v_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for this product';
    END IF;
END$$

-- 2) Decrement stock and add the line to the order total.
CREATE TRIGGER trg_order_items_after_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id;

    UPDATE orders
    SET total_amount = total_amount + (NEW.quantity * NEW.unit_price)
    WHERE order_id = NEW.order_id;
END$$

-- 3) If a line is removed, put the stock back and reduce the total.
CREATE TRIGGER trg_order_items_after_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET quantity = quantity + OLD.quantity
    WHERE product_id = OLD.product_id;

    UPDATE orders
    SET total_amount = GREATEST(total_amount - (OLD.quantity * OLD.unit_price), 0)
    WHERE order_id = OLD.order_id;
END$$

-- 4) Only customers who received the product may review it.
CREATE TRIGGER trg_reviews_before_insert
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM orders o
        JOIN order_items oi ON oi.order_id = o.order_id
        WHERE o.customer_id = NEW.customer_id
          AND oi.product_id = NEW.product_id
          AND o.status = 'delivered'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer can only review delivered products';
    END IF;
END$$

DELIMITER ;
