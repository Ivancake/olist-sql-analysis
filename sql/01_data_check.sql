-- Проверка загрузки и качества данных Olist

-- 1. Количество строк в таблицах
-- Ожидается: customers 99441, orders 99441, products 32951,
-- order_items 112650, order_payments 103886, category_translation 71
SELECT 'customers' AS table_name, count(*) AS rows_cnt FROM customers
UNION ALL SELECT 'orders', count(*) FROM orders
UNION ALL SELECT 'products', count(*) FROM products
UNION ALL SELECT 'order_items', count(*) FROM order_items
UNION ALL SELECT 'order_payments', count(*) FROM order_payments
UNION ALL SELECT 'category_translation', count(*) FROM category_translation
ORDER BY table_name;

-- 2. Распределение заказов по статусам
-- Итог: 97% заказов delivered (96478 из 99441)
SELECT order_status, count(*) AS orders_cnt
FROM orders
GROUP BY order_status
ORDER BY orders_cnt DESC;

-- 3. Период данных
-- Итог: 2016-09-04 — 2018-10-17; крайние месяцы неполные
SELECT min(order_purchase_timestamp) AS first_order,
       max(order_purchase_timestamp) AS last_order
FROM orders;

-- 4. Пропуски в датах
-- Итог: 2965 заказов без даты доставки (из них минимум 2 со статусом delivered),
-- 160 заказов без даты подтверждения оплаты
SELECT count(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS no_delivery,
       count(*) FILTER (WHERE order_approved_at IS NULL) AS no_approval
FROM orders;

-- 5. Доставленные заказы без даты доставки (аномалия)
SELECT count(*) AS delivered_without_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;
