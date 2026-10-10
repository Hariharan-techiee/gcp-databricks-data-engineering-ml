INSERT INTO customers (
    customer_id, first_name, last_name, email, phone,
    city, state, country, customer_segment, created_at, updated_at
)
VALUES
(1, 'Arun', 'Kumar', 'arun@example.com', '9000000001',
 'Chennai', 'Tamil Nadu', 'India', 'Regular', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'Priya', 'Sharma', 'priya@example.com', '9000000002',
 'Bangalore', 'Karnataka', 'India', 'Premium', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'Rahul', 'Verma', 'rahul@example.com', '9000000003',
 'Hyderabad', 'Telangana', 'India', 'Regular', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Sneha', 'Rao', 'sneha@example.com', '9000000004',
 'Pune', 'Maharashtra', 'India', 'Premium', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Karthik', 'Raj', 'karthik@example.com', '9000000005',
 'Mumbai', 'Maharashtra', 'India', 'Regular', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO products (
    product_id, product_name, category, brand,
    unit_price, cost_price, weight_grams, cocoa_percentage,
    stock_quantity, is_active, created_at, updated_at
)
VALUES
(1, 'Dark Chocolate', 'Dark Chocolate', 'CocoaCraft',
 250.00, 150.00, 100, 70.00, 100, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'Milk Chocolate', 'Milk Chocolate', 'SweetBite',
 180.00, 100.00, 100, 35.00, 150, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'White Chocolate', 'White Chocolate', 'CocoaCraft',
 200.00, 120.00, 100, 0.00, 80, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Hazelnut Chocolate', 'Nut Chocolate', 'ChocoDelight',
 320.00, 200.00, 150, 55.00, 60, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Chocolate Truffles', 'Truffles', 'SweetBite',
 450.00, 280.00, 200, 60.00, 40, TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO orders (
    order_id, customer_id, order_date, order_status,
    shipping_city, shipping_state, total_amount,
    discount_amount, tax_amount, shipping_amount,
    created_at, updated_at
)
VALUES
(1, 1, CURRENT_TIMESTAMP - INTERVAL '3 days', 'DELIVERED',
 'Chennai', 'Tamil Nadu', 540.00, 20.00, 30.00, 50.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, CURRENT_TIMESTAMP - INTERVAL '2 days', 'SHIPPED',
 'Bangalore', 'Karnataka', 780.00, 30.00, 40.00, 50.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 3, CURRENT_TIMESTAMP - INTERVAL '1 day', 'CONFIRMED',
 'Hyderabad', 'Telangana', 420.00, 10.00, 20.00, 50.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 4, CURRENT_TIMESTAMP, 'PLACED',
 'Pune', 'Maharashtra', 650.00, 25.00, 35.00, 50.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO order_items (
    order_item_id, order_id, product_id, quantity,
    unit_price, discount_amount, line_total,
    created_at, updated_at
)
VALUES
(1, 1, 1, 2, 250.00, 10.00, 490.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 2, 2, 180.00, 10.00, 350.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 2, 4, 1, 320.00, 0.00, 320.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 3, 3, 2, 200.00, 10.00, 390.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 4, 5, 1, 450.00, 20.00, 430.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 4, 2, 1, 180.00, 5.00, 175.00,
 CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);