--VW_COMPLETED_ORDERS
SELECT
    f.order_id,
    f.order_sk,

    f.customer_sk,

    CONCAT(
        c.first_name,
        ' ',
        c.last_name
    ) AS customer_name,

    c.customer_segment,

    f.order_date,
    f.order_status,

    f.shipping_city,
    f.shipping_state,

    f.total_amount,
    f.discount_amount,
    f.tax_amount,
    f.shipping_amount,
    f.net_amount,

    f.created_at,
    f.updated_at

FROM
    `gcp-data-engineering-504911.Gcp_Curated.FACT_ORDER` f

LEFT JOIN
    `gcp-data-engineering-504911.Gcp_Curated.DIM_CUSTOMER` c
ON
    f.customer_sk = c.customer_sk

AND
    c.is_current = TRUE

WHERE
    UPPER(f.order_status) = 'COMPLETED'


--VW_LOW_STOCK_PRODUCTS
SELECT
    p.product_id,
    p.product_sk,
    p.product_name,
    p.category,
    p.brand,

    p.stock_quantity,

    p.unit_price,

    p.is_active,

    COALESCE(SUM(m.quantity), 0) AS total_units_sold,

    COUNT(DISTINCT m.order_id) AS total_orders,

    COALESCE(SUM(m.line_total), 0) AS total_revenue,

    CASE
        WHEN p.stock_quantity = 0
            THEN 'OUT OF STOCK'
        WHEN p.stock_quantity <= 5
            THEN 'CRITICAL'
        WHEN p.stock_quantity <= 10
            THEN 'LOW'
        ELSE 'NORMAL'
    END AS stock_status

FROM
    `gcp-data-engineering-504911.Gcp_Curated.DIM_PRODUCT` p

LEFT JOIN
    `gcp-data-engineering-504911.Gcp_Curated.MAP_ORDER_ITEM` m
ON
    p.product_sk = m.product_sk

WHERE
    p.stock_quantity <= 10

GROUP BY
    p.product_id,
    p.product_sk,
    p.product_name,
    p.category,
    p.brand,
    p.stock_quantity,
    p.unit_price,
    p.is_active

ORDER BY
    p.stock_quantity ASC

    --VW_TOP_10_CUSTOMERS

    SELECT
    c.customer_id,
    c.customer_sk,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.city,
    c.state,
    c.country,
    c.customer_segment,

    COUNT(DISTINCT f.order_id) AS total_orders,

    SUM(f.net_amount) AS total_spend,

    AVG(f.net_amount) AS average_order_value,

    MAX(f.order_date) AS last_order_date

FROM
    `gcp-data-engineering-504911.Gcp_Curated.DIM_CUSTOMER` c

JOIN
    `gcp-data-engineering-504911.Gcp_Curated.FACT_ORDER` f
ON
    c.customer_sk = f.customer_sk

WHERE
    c.is_current = TRUE

GROUP BY
    c.customer_id,
    c.customer_sk,
    customer_name,
    c.email,
    c.city,
    c.state,
    c.country,
    c.customer_segment

ORDER BY
    total_spend DESC

LIMIT 10

--VW_TOP_10_SELLING_PRODUCTS

SELECT
    p.product_id,
    p.product_sk,
    p.product_name,
    p.category,
    p.brand,
    p.unit_price,

    SUM(m.quantity) AS total_units_sold,

    COUNT(DISTINCT m.order_id) AS total_orders,

    SUM(m.line_total) AS total_revenue,

    AVG(m.unit_price) AS average_selling_price,

    p.stock_quantity

FROM
    `gcp-data-engineering-504911.Gcp_Curated.DIM_PRODUCT` p

JOIN
    `gcp-data-engineering-504911.Gcp_Curated.MAP_ORDER_ITEM` m
ON
    p.product_sk = m.product_sk

GROUP BY
    p.product_id,
    p.product_sk,
    p.product_name,
    p.category,
    p.brand,
    p.unit_price,
    p.stock_quantity

ORDER BY
    total_units_sold DESC

LIMIT 10

--VW_TOTAL_ACTIVE_ORDERS

SELECT
    COUNT(*) AS total_active_orders,

    SUM(f.net_amount) AS active_order_revenue,

    AVG(f.net_amount) AS average_active_order_value,

    MIN(f.order_date) AS oldest_active_order_date,

    MAX(f.order_date) AS latest_active_order_date

FROM
    `gcp-data-engineering-504911.Gcp_Curated.FACT_ORDER` f

WHERE
    UPPER(f.order_status) IN (
        'PENDING',
        'PROCESSING',
        'SHIPPED'
    )

    --VW_TOTAL_REVENUE

    SELECT

    SUM(f.total_amount) AS gross_revenue,

    SUM(f.discount_amount) AS total_discount,

    SUM(f.tax_amount) AS total_tax,

    SUM(f.shipping_amount) AS total_shipping,

    SUM(f.net_amount) AS total_revenue,

    COUNT(DISTINCT f.order_id) AS total_orders,

    AVG(f.net_amount) AS average_order_value,

    MIN(f.order_date) AS first_order_date,

    MAX(f.order_date) AS latest_order_date

FROM
    `gcp-data-engineering-504911.Gcp_Curated.FACT_ORDER` f