-- Проверка загрузки и качества данных Olist.
-- Выполнять после 00_post_load.sql.

-- 1. Количество строк в таблицах.
-- Ожидается:
-- customers            99441
-- orders               99441
-- products             32951
-- order_items         112650
-- order_payments      103886
-- category_translation    73
-- В справочник добавлены две категории без английского перевода.

SELECT 'customers' AS table_name, COUNT(*) AS rows_cnt
FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation
ORDER BY table_name;

-- 2. Распределение заказов по статусам.
SELECT
    order_status,
    COUNT(*) AS orders_cnt
FROM orders
GROUP BY order_status
ORDER BY orders_cnt DESC;

-- 3. Период данных.
SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- 4. Пропуски в датах.
SELECT
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date IS NULL
    ) AS no_delivery,
    COUNT(*) FILTER (
        WHERE order_approved_at IS NULL
    ) AS no_approval
FROM orders;

-- 5. Доставленные заказы без даты доставки.
SELECT
    COUNT(*) AS delivered_without_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;
