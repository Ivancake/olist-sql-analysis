-- Схема базы данных Olist (PostgreSQL)
-- Порядок загрузки CSV: customers -> orders -> products -> order_items -> order_payments -> category_translation

CREATE TABLE customers (
  customer_id text PRIMARY KEY,
  customer_unique_id text,
  customer_zip_code_prefix text,
  customer_city text,
  customer_state text
);

CREATE TABLE orders (
  order_id text PRIMARY KEY,
  customer_id text REFERENCES customers,
  order_status text,
  order_purchase_timestamp timestamp,
  order_approved_at timestamp,
  order_delivered_carrier_date timestamp,
  order_delivered_customer_date timestamp,
  order_estimated_delivery_date timestamp
);

CREATE TABLE products (
  product_id text PRIMARY KEY,
  product_category_name text,
  product_name_lenght int,
  product_description_lenght int,
  product_photos_qty int,
  product_weight_g int,
  product_length_cm int,
  product_height_cm int,
  product_width_cm int
);

CREATE TABLE order_items (
  order_id text REFERENCES orders,
  order_item_id int,
  product_id text REFERENCES products,
  seller_id text,
  shipping_limit_date timestamp,
  price numeric(10,2),
  freight_value numeric(10,2),
  PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE order_payments (
  order_id text REFERENCES orders,
  payment_sequential int,
  payment_type text,
  payment_installments int,
  payment_value numeric(10,2)
);
-- У платежей нет естественного ключа: один заказ может иметь несколько платежей
ALTER TABLE order_payments ADD COLUMN payment_id serial PRIMARY KEY;

CREATE TABLE category_translation (
  product_category_name text PRIMARY KEY,
  product_category_name_english text
);
