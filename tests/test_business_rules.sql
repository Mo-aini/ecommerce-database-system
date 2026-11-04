-- =============================================================
-- Business-rule checks. Run after install.sql:
--   mysql -u root -p ecommerce_db < tests/test_business_rules.sql
-- Each block prints a PASS/FAIL line.
-- =============================================================
USE ecommerce_db;

DROP PROCEDURE IF EXISTS run_rule_tests;
DELIMITER $$
CREATE PROCEDURE run_rule_tests()
BEGIN
    DECLARE v_before INT;
    DECLARE v_after  INT;
    DECLARE v_order  INT UNSIGNED;
    DECLARE v_total  DECIMAL(12,2);
    DECLARE v_failed BOOLEAN DEFAULT FALSE;
    DECLARE v_orders_before INT;

    -- T1: place_order decrements stock and computes the total
    SELECT quantity INTO v_before FROM inventory WHERE product_id = 11;
    CALL place_order(5, 11, 2, 'card', v_order);
    SELECT quantity INTO v_after FROM inventory WHERE product_id = 11;
    SELECT total_amount INTO v_total FROM orders WHERE order_id = v_order;
    SELECT IF(v_after = v_before - 2 AND v_total = 2 * (SELECT price FROM products WHERE product_id = 11),
              'PASS', 'FAIL') AS result, 'T1 place_order: stock -2 and total = 2 x price' AS test;

    -- T2: ordering more than the stock is rejected and nothing is left behind
    SELECT COUNT(*) INTO v_orders_before FROM orders;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_failed = TRUE;
        CALL place_order(5, 12, 999, 'card', v_order);
    END;
    SELECT IF(v_failed AND (SELECT COUNT(*) FROM orders) = v_orders_before, 'PASS', 'FAIL') AS result,
           'T2 insufficient stock is rolled back' AS test;

    -- T3: CHECK constraint blocks negative stock
    SET v_failed = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_failed = TRUE;
        UPDATE inventory SET quantity = -1 WHERE product_id = 1;
    END;
    SELECT IF(v_failed, 'PASS', 'FAIL') AS result, 'T3 CHECK (quantity >= 0)' AS test;

    -- T4: rating outside 1..5 is rejected
    SET v_failed = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_failed = TRUE;
        INSERT INTO reviews (product_id, customer_id, rating) VALUES (1, 1, 7);
    END;
    SELECT IF(v_failed, 'PASS', 'FAIL') AS result, 'T4 CHECK rating BETWEEN 1 AND 5' AS test;

    -- T5: cancel_order restores stock
    SELECT quantity INTO v_before FROM inventory WHERE product_id = 11;
    CALL place_order(6, 11, 3, 'cash_on_delivery', v_order);
    CALL cancel_order(v_order);
    SELECT quantity INTO v_after FROM inventory WHERE product_id = 11;
    SELECT IF(v_after = v_before
              AND (SELECT status FROM orders WHERE order_id = v_order) = 'cancelled',
              'PASS', 'FAIL') AS result, 'T5 cancel_order restores stock' AS test;

    -- T6: a customer cannot review a product they never received
    SET v_failed = FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_failed = TRUE;
        INSERT INTO reviews (product_id, customer_id, rating) VALUES (8, 20, 5);
    END;
    SELECT IF(v_failed, 'PASS', 'FAIL') AS result, 'T6 review requires a delivered order' AS test;
END$$
DELIMITER ;

CALL run_rule_tests();
DROP PROCEDURE run_rule_tests;
