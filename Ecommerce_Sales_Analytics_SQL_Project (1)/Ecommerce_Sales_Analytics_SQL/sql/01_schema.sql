CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

DROP TABLE IF EXISTS ecommerce_sales;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL
);

CREATE TABLE ecommerce_sales (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    customer_segment VARCHAR(30) NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discount_pct DECIMAL(5,2) NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL,
    sales_amount DECIMAL(14,2) NOT NULL,
    profit_amount DECIMAL(14,2) NOT NULL,
    payment_mode VARCHAR(30) NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    customer_rating INT,
    delivery_days INT,
    CONSTRAINT fk_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);
