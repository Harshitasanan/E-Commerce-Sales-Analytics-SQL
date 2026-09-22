USE ecommerce_analytics;

-- ============================================================
-- 1. BASIC DATA EXPLORATION
-- ============================================================

SELECT COUNT(*) AS total_orders
FROM ecommerce_sales;

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM ecommerce_sales;

SELECT MIN(order_date) AS first_order_date,
       MAX(order_date) AS last_order_date
FROM ecommerce_sales;

SELECT category, COUNT(*) AS orders
FROM ecommerce_sales
GROUP BY category
ORDER BY orders DESC;


-- ============================================================
-- 2. CORE BUSINESS KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS total_sales,
    ROUND(SUM(profit_amount), 2) AS total_profit,
    ROUND(SUM(sales_amount) / COUNT(*), 2) AS average_order_value,
    ROUND(SUM(profit_amount) / NULLIF(SUM(sales_amount),0) * 100, 2) AS profit_margin_pct
FROM ecommerce_sales
WHERE order_status <> 'Cancelled';


-- ============================================================
-- 3. MONTHLY SALES & PROFIT TREND
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS orders,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(SUM(profit_amount), 2) AS profit
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;


-- ============================================================
-- 4. MONTH-OVER-MONTH SALES GROWTH USING LAG()
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(sales_amount) AS sales
    FROM ecommerce_sales
    WHERE order_status <> 'Cancelled'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
sales_with_previous AS (
    SELECT
        sales_month,
        sales,
        LAG(sales) OVER (ORDER BY sales_month) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(sales, 2) AS sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        (sales - previous_month_sales) / NULLIF(previous_month_sales,0) * 100,
        2
    ) AS mom_growth_pct
FROM sales_with_previous
ORDER BY sales_month;


-- ============================================================
-- 5. CATEGORY PERFORMANCE
-- ============================================================

SELECT
    category,
    COUNT(*) AS orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(SUM(profit_amount), 2) AS profit,
    ROUND(SUM(profit_amount) / NULLIF(SUM(sales_amount),0) * 100, 2) AS margin_pct
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY category
ORDER BY sales DESC;


-- ============================================================
-- 6. TOP 10 PRODUCTS BY SALES
-- ============================================================

SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(SUM(profit_amount), 2) AS profit
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY product_id, product_name, category
ORDER BY sales DESC
LIMIT 10;


-- ============================================================
-- 7. TOP PRODUCTS WITH DENSE_RANK()
-- ============================================================

WITH product_sales AS (
    SELECT
        product_id,
        product_name,
        category,
        SUM(sales_amount) AS sales
    FROM ecommerce_sales
    WHERE order_status <> 'Cancelled'
    GROUP BY product_id, product_name, category
)
SELECT
    product_id,
    product_name,
    category,
    ROUND(sales, 2) AS sales,
    DENSE_RANK() OVER (ORDER BY sales DESC) AS sales_rank
FROM product_sales
ORDER BY sales_rank;


-- ============================================================
-- 8. CITY-WISE SALES
-- ============================================================

SELECT
    city,
    COUNT(*) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(SUM(profit_amount), 2) AS profit
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY city
ORDER BY sales DESC;


-- ============================================================
-- 9. CUSTOMER SEGMENT PERFORMANCE
-- ============================================================

SELECT
    customer_segment,
    COUNT(*) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(AVG(sales_amount), 2) AS avg_order_value,
    ROUND(SUM(profit_amount), 2) AS profit
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY customer_segment
ORDER BY sales DESC;


-- ============================================================
-- 10. PAYMENT MODE ANALYSIS
-- ============================================================

SELECT
    payment_mode,
    COUNT(*) AS orders,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(AVG(sales_amount), 2) AS avg_order_value
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY payment_mode
ORDER BY sales DESC;


-- ============================================================
-- 11. ORDER STATUS ANALYSIS
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS order_share_pct
FROM ecommerce_sales
GROUP BY order_status
ORDER BY orders DESC;


-- ============================================================
-- 12. RETURN & CANCELLATION RATE
-- ============================================================

SELECT
    ROUND(SUM(order_status = 'Cancelled') * 100.0 / COUNT(*), 2) AS cancellation_rate_pct,
    ROUND(SUM(order_status = 'Returned') * 100.0 / COUNT(*), 2) AS return_rate_pct
FROM ecommerce_sales;


-- ============================================================
-- 13. DISCOUNT VS PROFITABILITY
-- ============================================================

SELECT
    discount_pct,
    COUNT(*) AS orders,
    ROUND(SUM(sales_amount), 2) AS sales,
    ROUND(SUM(profit_amount), 2) AS profit,
    ROUND(AVG(profit_amount), 2) AS avg_profit_per_order
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY discount_pct
ORDER BY discount_pct;


-- ============================================================
-- 14. CUSTOMER LIFETIME VALUE PROXY
-- ============================================================

SELECT
    customer_id,
    COUNT(*) AS order_count,
    ROUND(SUM(sales_amount), 2) AS lifetime_sales,
    ROUND(SUM(profit_amount), 2) AS lifetime_profit,
    ROUND(AVG(sales_amount), 2) AS avg_order_value
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY customer_id
ORDER BY lifetime_sales DESC
LIMIT 20;


-- ============================================================
-- 15. REPEAT CUSTOMERS
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM ecommerce_sales
    WHERE order_status <> 'Cancelled'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers,
    SUM(order_count > 1) AS repeat_customers,
    ROUND(SUM(order_count > 1) * 100.0 / COUNT(*), 2) AS repeat_customer_rate_pct
FROM customer_orders;


-- ============================================================
-- 16. AVERAGE RATING BY CATEGORY
-- ============================================================

SELECT
    category,
    ROUND(AVG(customer_rating), 2) AS avg_rating,
    COUNT(customer_rating) AS rated_orders
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY category
ORDER BY avg_rating DESC;


-- ============================================================
-- 17. DELIVERY PERFORMANCE
-- ============================================================

SELECT
    category,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(CASE WHEN delivery_days <= 3 THEN 1 ELSE 0 END) * 100, 2)
        AS delivered_within_3_days_pct
FROM ecommerce_sales
WHERE order_status IN ('Delivered', 'Shipped')
GROUP BY category
ORDER BY avg_delivery_days;


-- ============================================================
-- 18. SALES BY WEEKDAY
-- ============================================================

SELECT
    DAYNAME(order_date) AS weekday,
    COUNT(*) AS orders,
    ROUND(SUM(sales_amount), 2) AS sales
FROM ecommerce_sales
WHERE order_status <> 'Cancelled'
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY DAYOFWEEK(order_date);


-- ============================================================
-- 19. RUNNING TOTAL OF MONTHLY SALES
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(sales_amount) AS sales
    FROM ecommerce_sales
    WHERE order_status <> 'Cancelled'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(sales, 2) AS monthly_sales,
    ROUND(
        SUM(sales) OVER (
            ORDER BY sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_sales
FROM monthly_sales
ORDER BY sales_month;


-- ============================================================
-- 20. DATA QUALITY CHECKS
-- ============================================================

SELECT 'Null order IDs' AS check_name, COUNT(*) AS issue_count
FROM ecommerce_sales
WHERE order_id IS NULL

UNION ALL

SELECT 'Invalid quantity', COUNT(*)
FROM ecommerce_sales
WHERE quantity <= 0

UNION ALL

SELECT 'Negative sales', COUNT(*)
FROM ecommerce_sales
WHERE sales_amount < 0

UNION ALL

SELECT 'Invalid ratings', COUNT(*)
FROM ecommerce_sales
WHERE customer_rating NOT BETWEEN 1 AND 5
  AND customer_rating IS NOT NULL;


-- ============================================================
-- 21. EXECUTIVE SUMMARY
-- ============================================================

SELECT
    ROUND(SUM(CASE WHEN order_status <> 'Cancelled' THEN sales_amount ELSE 0 END), 2) AS total_sales,
    ROUND(SUM(CASE WHEN order_status <> 'Cancelled' THEN profit_amount ELSE 0 END), 2) AS total_profit,
    SUM(CASE WHEN order_status <> 'Cancelled' THEN quantity ELSE 0 END) AS units_sold,
    COUNT(DISTINCT CASE WHEN order_status <> 'Cancelled' THEN customer_id END) AS unique_customers,
    ROUND(
        SUM(CASE WHEN order_status <> 'Cancelled' THEN sales_amount ELSE 0 END)
        / NULLIF(SUM(CASE WHEN order_status <> 'Cancelled' THEN 1 ELSE 0 END), 0),
        2
    ) AS average_order_value,
    ROUND(
        SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM ecommerce_sales;
