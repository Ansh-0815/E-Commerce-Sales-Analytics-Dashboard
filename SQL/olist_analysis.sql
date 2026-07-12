-- ============================================================
-- Olist E-Commerce Analysis - SQL Data Pipeline
-- Dataset: Brazilian E-Commerce Public Dataset by Olist (Kaggle)
-- https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
-- ============================================================
-- NOTE ON SCOPE: This script builds and cleans the MySQL data
-- warehouse used for exploratory analysis below. The Power BI
-- dashboard (dashboard/Olist_dashboard.pbix) currently connects
-- directly to the raw CSVs rather than to these cleaned MySQL
-- tables - see README.md "Reconnecting Power BI to MySQL" for
-- the steps to point it at clean_order_items / clean_products
-- created in Section 4 below, so the whole pipeline is unified.
-- ============================================================

CREATE DATABASE IF NOT EXISTS olist_project;
USE olist_project;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- ------------------------------------------------------------
-- 1. Create & load raw tables
--    Download the 6 CSVs from the Kaggle link above and update
--    the file paths below to their location on your machine.
-- ------------------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_orders_dataset.csv' 
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_customers_dataset.csv'  -- << update this path
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_order_items_dataset.csv'  -- << update this path
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_order_payments_dataset.csv'  -- << update this path
INTO TABLE payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght FLOAT,
    product_description_lenght FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_products_dataset.csv'  -- << update this path
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS category_translation;
CREATE TABLE category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/product_category_name_translation.csv'  -- << update this path
INTO TABLE category_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ------------------------------------------------------------
-- 2. Row count sanity checks
-- ------------------------------------------------------------
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'category_translation', COUNT(*) FROM category_translation;

-- ------------------------------------------------------------
-- 3. Data quality checks
-- ------------------------------------------------------------
-- How many products are missing a category?
SELECT COUNT(*) AS null_categories
FROM products
WHERE product_category_name IS NULL OR product_category_name = '';

-- Order status breakdown (are there cancelled/unavailable orders to exclude from revenue?)
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Any order_items rows with no matching product (broken join risk)?
SELECT COUNT(*) AS orphaned_order_items
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ------------------------------------------------------------
-- 4. Build cleaned tables
--    - product_category_name_english resolved via translation
--      table, with a fallback label for the ~1.85% of products
--      with a missing/untranslated category (found in Section 3)
--      instead of silently excluding them from category reports.
-- ------------------------------------------------------------
DROP TABLE IF EXISTS clean_products;
CREATE TABLE clean_products AS
SELECT
    p.product_id,
    COALESCE(ct.product_category_name_english, 'unknown') AS product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name;

-- Revenue-bearing order items only: exclude cancelled/unavailable orders
-- so revenue figures reflect orders that were actually fulfilled or in progress.
DROP TABLE IF EXISTS clean_order_items;
CREATE TABLE clean_order_items AS
SELECT oi.*
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');

SELECT COUNT(*) AS clean_order_items_count FROM clean_order_items;
SELECT COUNT(*) AS clean_products_count FROM clean_products;

-- ------------------------------------------------------------
-- 5. Core KPIs (match the Power BI Overview page cards)
-- ------------------------------------------------------------
SELECT
    ROUND(SUM(price), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM clean_order_items;

SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Delivery success rate = delivered orders / all orders
SELECT
    ROUND(
        SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate_pct
FROM orders;

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT payment_type, COUNT(*) AS total_transactions,
       ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- ------------------------------------------------------------
-- 6. Revenue by category
-- ------------------------------------------------------------
SELECT
    cp.product_category_name_english,
    ROUND(SUM(coi.price), 2) AS revenue,
    COUNT(*) AS order_items_count,
    ROUND(SUM(coi.freight_value), 2) AS total_freight_cost
FROM clean_products cp
JOIN clean_order_items coi ON cp.product_id = coi.product_id
GROUP BY cp.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 7. Monthly revenue trend
-- ------------------------------------------------------------
SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    ROUND(SUM(coi.price), 2) AS revenue
FROM orders o
JOIN clean_order_items coi ON o.order_id = coi.order_id
GROUP BY year, month
ORDER BY year, month;

-- ------------------------------------------------------------
-- 8. Month-over-month revenue growth (CTE + window function)
--    Demonstrates an alternative to the flat GROUP BY above:
--    LAG() looks at the previous row's revenue within the same
--    ordered result set, without a self-join.
-- ------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        ROUND(SUM(coi.price), 2) AS revenue
    FROM orders o
    JOIN clean_order_items coi ON o.order_id = coi.order_id
    GROUP BY year, month
)
SELECT
    year,
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY year, month) AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year, month))
        / LAG(revenue) OVER (ORDER BY year, month) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY year, month;

-- ------------------------------------------------------------
-- 9. Top-selling product per category (CTE + ROW_NUMBER window function)
-- ------------------------------------------------------------
WITH product_sales AS (
    SELECT
        cp.product_category_name_english,
        coi.product_id,
        SUM(coi.price) AS product_revenue,
        COUNT(*) AS units_sold
    FROM clean_products cp
    JOIN clean_order_items coi ON cp.product_id = coi.product_id
    GROUP BY cp.product_category_name_english, coi.product_id
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY product_category_name_english
            ORDER BY product_revenue DESC
        ) AS rank_in_category
    FROM product_sales
)
SELECT product_category_name_english, product_id, product_revenue, units_sold
FROM ranked
WHERE rank_in_category = 1
ORDER BY product_revenue DESC
LIMIT 15;

-- ------------------------------------------------------------
-- 10. Revenue and orders by customer state / city
--     (matches the Power BI Customer Analysis page)
-- ------------------------------------------------------------
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(coi.price), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN clean_order_items coi ON o.order_id = coi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

SELECT
    c.customer_city,
    ROUND(SUM(coi.price), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN clean_order_items coi ON o.order_id = coi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 11. Delivery performance: average delivery time vs. estimate
-- ------------------------------------------------------------
SELECT
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 1)
        AS avg_actual_delivery_days,
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp)), 1)
        AS avg_estimated_delivery_days,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)), 1)
        AS avg_days_early_or_late
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- ------------------------------------------------------------
-- 12. Customer-level RFM (Recency / Frequency / Monetary)
--     Same methodology as the standalone RFM project, applied
--     here to Olist customers as a natural extension of this
--     analysis - not currently reflected in the Power BI report.
-- ------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        coi.price
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN clean_order_items coi ON o.order_id = coi.order_id
)
SELECT
    customer_unique_id,
    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp) FROM orders),
        MAX(order_purchase_timestamp)
    ) AS recency_days,
    COUNT(DISTINCT order_id) AS frequency,
    ROUND(SUM(price), 2) AS monetary
FROM customer_orders
GROUP BY customer_unique_id
ORDER BY monetary DESC
LIMIT 20;
