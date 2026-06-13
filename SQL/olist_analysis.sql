create database olist_project;
use olist_project;
show tables;
select count(*) from customers;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
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
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from orders;
select * from orders;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
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

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
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

LOAD DATA LOCAL INFILE 'C:/Users/agarw/Desktop/Olist_project/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from products;

SELECT COUNT(*) AS orders_count FROM orders;
SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS order_items_count FROM order_items;
SELECT COUNT(*) AS payments_count FROM payments;
SELECT COUNT(*) AS products_count FROM products;

SHOW TABLES;

select round(sum(price),2) as total_revenue
from order_items;

select count(distinct customer_unique_id) as total_customers
from customers;

select count(distinct order_id) as total_orders
from orders;

select round(sum(price)/count(distinct order_id),2) as avg_order_value 
from order_items;

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

select p.product_category_name,sum(oi.price) as total_revenue
from products p
join order_items oi
on p.product_id=oi.product_id
group by p.product_category_name
order by total_revenue desc;

SELECT payment_type, COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

SELECT COUNT(*) AS null_categories
FROM products
WHERE product_category_name IS NULL;

SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price),2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY year, month
ORDER BY year, month;

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

SELECT
SUM(price) AS revenue,
COUNT(DISTINCT order_id) AS orders,
ROUND(
SUM(price)/COUNT(DISTINCT order_id),2
) AS aov
FROM order_items;

SELECT COUNT(*) FROM order_items;