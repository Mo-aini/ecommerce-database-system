-- =============================================================
-- E-Commerce Database System - stored procedures
-- =============================================================
USE ecommerce_db;

DROP PROCEDURE IF EXISTS place_order;
DROP PROCEDURE IF EXISTS cancel_order;
DROP PROCEDURE IF EXISTS restock_product;

DELIMITER $$

-- -------------------------------------------------------------
-- place_order: creates an order for ONE product line inside a
-- transaction. The triggers check/decrement stock and update the
-- total; if anything fails, the whole order is rolled back.
--   CALL place_order(customer_id, product_id, qty, 'card', @new_id);
-- -------------------------------------------------------------
CREATE PROCEDURE place_order(
    IN  p_customer_id INT UNSIGNED,
    IN  p_product_id  INT UNSIGNED,
    IN  p_quantity    INT,
    IN  p_method      VARCHAR(20),
    OUT p_order_id    INT UNSIGNED
)
BEGIN
    DECLARE v_price   DECIMAL(10,2);
    DECLARE v_address INT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_order_id = NULL;
        RESIGNAL;
    END;

    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    START TRANSACTION;

    SELECT price INTO v_price
    FROM products
    WHERE product_id = p_product_id AND is_active = TRUE;

    IF v_price IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found or inactive';
    END IF;

    SELECT address_id INTO v_address
    FROM addresses
    WHERE customer_id = p_customer_id
    ORDER BY is_default DESC, address_id
    LIMIT 1;

    INSERT INTO orders (customer_id, shipping_address_id, status)
    VALUES (p_customer_id, v_address, 'pending');
    SET p_order_id = LAST_INSERT_ID();

    -- triggers: stock check + decrement + total update
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price);

    INSERT INTO payments (order_id, method, amount, status, paid_at)
    SELECT order_id, p_method, total_amount,
           IF(p_method = 'cash_on_delivery', 'pending', 'completed'),
           IF(p_method = 'cash_on_delivery', NULL, NOW())
    FROM orders WHERE order_id = p_order_id;

    IF p_method <> 'cash_on_delivery' THEN
        UPDATE orders SET status = 'paid' WHERE order_id = p_order_id;
    END IF;

    COMMIT;
END$$

-- -------------------------------------------------------------
-- cancel_order: restores stock for every line, marks payments as
-- refunded and the order as cancelled. Delivered orders can't be
-- cancelled.
-- -------------------------------------------------------------
CREATE PROCEDURE cancel_order(IN p_order_id INT UNSIGNED)
BEGIN
    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT status INTO v_status FROM orders
    WHERE order_id = p_order_id FOR UPDATE;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order not found';
    ELSEIF v_status IN ('delivered', 'cancelled') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order can no longer be cancelled';
    END IF;

    UPDATE inventory i
    JOIN order_items oi ON oi.product_id = i.product_id
    SET i.quantity = i.quantity + oi.quantity
    WHERE oi.order_id = p_order_id;

    UPDATE payments SET status = 'refunded'
    WHERE order_id = p_order_id AND status = 'completed';

    UPDATE payments SET status = 'failed'
    WHERE order_id = p_order_id AND status = 'pending';

    UPDATE orders SET status = 'cancelled' WHERE order_id = p_order_id;

    COMMIT;
END$$

-- -------------------------------------------------------------
-- restock_product: adds stock (e.g. a new delivery from supplier)
-- -------------------------------------------------------------
CREATE PROCEDURE restock_product(IN p_product_id INT UNSIGNED, IN p_amount INT)
BEGIN
    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restock amount must be positive';
    END IF;

    UPDATE inventory SET quantity = quantity + p_amount
    WHERE product_id = p_product_id;
END$$

DELIMITER ;
