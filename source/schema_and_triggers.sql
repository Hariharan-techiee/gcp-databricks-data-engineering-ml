
-- ============================================================
-- GCP END-TO-END DATA ENGINEERING PROJECT
-- Source database: PostgreSQL
-- Tables: customers, products, orders, order_items
-- Purpose: Source schema for incremental Databricks ingestion
-- ============================================================

-- ------------------------------------------------------------
-- 1. CUSTOMERS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS customers (
    customer_id       INTEGER PRIMARY KEY,
    first_name        TEXT,
    last_name         TEXT,
    email             TEXT,
    phone             TEXT,
    city              TEXT,
    state             TEXT,
    country           TEXT,
    customer_segment  TEXT,
    created_at        TIMESTAMPTZ,
    updated_at        TIMESTAMPTZ
);

-- ------------------------------------------------------------
-- 2. PRODUCTS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS products (
    product_id        INTEGER PRIMARY KEY,
    product_name      TEXT,
    category          TEXT,
    brand             TEXT,
    unit_price        NUMERIC,
    cost_price        NUMERIC,
    weight_grams      INTEGER,
    cocoa_percentage  NUMERIC,
    stock_quantity    INTEGER,
    is_active         BOOLEAN,
    created_at        TIMESTAMPTZ,
    updated_at        TIMESTAMPTZ
);

-- ------------------------------------------------------------
-- 3. ORDERS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS orders (
    order_id          INTEGER PRIMARY KEY,
    customer_id       INTEGER REFERENCES customers(customer_id),
    order_date        TIMESTAMPTZ,
    order_status      TEXT,
    shipping_city     TEXT,
    shipping_state    TEXT,
    total_amount      NUMERIC,
    discount_amount   NUMERIC,
    tax_amount        NUMERIC,
    shipping_amount   NUMERIC,
    created_at        TIMESTAMPTZ,
    updated_at        TIMESTAMPTZ
);

-- ------------------------------------------------------------
-- 4. ORDER ITEMS
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id     INTEGER PRIMARY KEY,
    order_id          INTEGER REFERENCES orders(order_id),
    product_id        INTEGER REFERENCES products(product_id),
    quantity          INTEGER,
    unit_price        NUMERIC,
    discount_amount   NUMERIC,
    line_total        NUMERIC,
    created_at        TIMESTAMPTZ,
    updated_at        TIMESTAMPTZ
);

-- ------------------------------------------------------------
-- 5. COMMON FUNCTION TO REFRESH updated_at
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- ------------------------------------------------------------
-- 6. TRIGGER: CUSTOMERS
-- ------------------------------------------------------------



CREATE TRIGGER trg_customers_updated_at
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ------------------------------------------------------------
-- 7. TRIGGER: PRODUCTS
-- ------------------------------------------------------------



CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ------------------------------------------------------------
-- 8. TRIGGER: ORDERS
-- ------------------------------------------------------------



CREATE TRIGGER trg_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ------------------------------------------------------------
-- 9. TRIGGER: ORDER ITEMS
-- ------------------------------------------------------------


CREATE TRIGGER trg_order_items_updated_at
BEFORE UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- END OF SCHEMA
-- ============================================================
