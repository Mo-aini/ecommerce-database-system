-- =============================================================
-- E-Commerce Database System - schema
-- Target: MySQL 8.0+ / MariaDB 10.6+
-- Author: Mohammed Emad ALaini
-- =============================================================

CREATE DATABASE IF NOT EXISTS ecommerce_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS reviews, payments, order_items, orders, inventory,
                     products, categories, addresses, customers;
SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------
-- customers
-- -------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(120) NOT NULL,
    phone         VARCHAR(20),
    password_hash CHAR(60)     NOT NULL,           -- bcrypt hash, never plain text
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active     BOOLEAN      NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT chk_customers_email CHECK (email LIKE '%_@_%._%')
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- addresses (one customer -> many addresses)
-- -------------------------------------------------------------
CREATE TABLE addresses (
    address_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT UNSIGNED NOT NULL,
    label        VARCHAR(30)  NOT NULL DEFAULT 'Home',
    line1        VARCHAR(120) NOT NULL,
    line2        VARCHAR(120),
    city         VARCHAR(60)  NOT NULL,
    province     VARCHAR(60),
    postal_code  VARCHAR(12),
    country      VARCHAR(60)  NOT NULL DEFAULT 'Pakistan',
    is_default   BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_addresses_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE INDEX idx_addresses_customer ON addresses (customer_id);

-- -------------------------------------------------------------
-- categories (self-referencing for sub-categories)
-- -------------------------------------------------------------
CREATE TABLE categories (
    category_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(60) NOT NULL,
    parent_id    INT UNSIGNED NULL,
    description  VARCHAR(255),
    CONSTRAINT uq_categories_name UNIQUE (name),
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id)
        REFERENCES categories (category_id) ON DELETE SET NULL
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- products
-- -------------------------------------------------------------
CREATE TABLE products (
    product_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_id  INT UNSIGNED  NOT NULL,
    sku          VARCHAR(30)   NOT NULL,
    name         VARCHAR(120)  NOT NULL,
    description  TEXT,
    price        DECIMAL(10,2) NOT NULL,
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_products_sku UNIQUE (sku),
    CONSTRAINT chk_products_price CHECK (price > 0),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id) ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE INDEX idx_products_category ON products (category_id);
CREATE INDEX idx_products_name     ON products (name);

-- -------------------------------------------------------------
-- inventory (1:1 with products, kept separate so stock updates
-- don't lock the catalog row)
-- -------------------------------------------------------------
CREATE TABLE inventory (
    product_id     INT UNSIGNED PRIMARY KEY,
    quantity       INT          NOT NULL DEFAULT 0,
    reorder_level  INT          NOT NULL DEFAULT 5,
    updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_inventory_qty     CHECK (quantity >= 0),
    CONSTRAINT chk_inventory_reorder CHECK (reorder_level >= 0),
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id)
        REFERENCES products (product_id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- -------------------------------------------------------------
-- orders
-- -------------------------------------------------------------
CREATE TABLE orders (
    order_id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id         INT UNSIGNED  NOT NULL,
    shipping_address_id INT UNSIGNED  NULL,
    order_date          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status              ENUM('pending','paid','shipped','delivered','cancelled')
                                      NOT NULL DEFAULT 'pending',
    total_amount        DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_orders_total CHECK (total_amount >= 0),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id) ON DELETE RESTRICT,
    CONSTRAINT fk_orders_address FOREIGN KEY (shipping_address_id)
        REFERENCES addresses (address_id) ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE INDEX idx_orders_customer_date ON orders (customer_id, order_date);
CREATE INDEX idx_orders_status        ON orders (status);

-- -------------------------------------------------------------
-- order_items (M:N between orders and products)
-- -------------------------------------------------------------
CREATE TABLE order_items (
    order_id    INT UNSIGNED  NOT NULL,
    product_id  INT UNSIGNED  NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,      -- price snapshot at time of order
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT chk_items_qty   CHECK (quantity > 0),
    CONSTRAINT chk_items_price CHECK (unit_price > 0),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_items_product FOREIGN KEY (product_id)
        REFERENCES products (product_id) ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE INDEX idx_items_product ON order_items (product_id);

-- -------------------------------------------------------------
-- payments
-- -------------------------------------------------------------
CREATE TABLE payments (
    payment_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id    INT UNSIGNED  NOT NULL,
    method      ENUM('card','cash_on_delivery','bank_transfer','wallet') NOT NULL,
    amount      DECIMAL(12,2) NOT NULL,
    status      ENUM('pending','completed','failed','refunded') NOT NULL DEFAULT 'pending',
    paid_at     DATETIME NULL,
    CONSTRAINT chk_payments_amount CHECK (amount > 0),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE INDEX idx_payments_order ON payments (order_id);

-- -------------------------------------------------------------
-- reviews (a customer can review a product once)
-- -------------------------------------------------------------
CREATE TABLE reviews (
    review_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id   INT UNSIGNED NOT NULL,
    customer_id  INT UNSIGNED NOT NULL,
    rating       TINYINT      NOT NULL,
    comment      VARCHAR(500),
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_reviews_once UNIQUE (product_id, customer_id),
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id)
        REFERENCES products (product_id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id) ON DELETE CASCADE
) ENGINE = InnoDB;
