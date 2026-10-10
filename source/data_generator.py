import psycopg2
import random
import time
from datetime import datetime

DB_CONFIG = {
    "host": "YOUR-HOST",
    "database": "DB-NAME",
    "user": "USER",
    "password": "PASSWORD",
    "port": 
}


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def create_order(conn):
    cur = conn.cursor()

    # Select a random customer
    cur.execute("""
        SELECT customer_id
        FROM customers
        ORDER BY random()
        LIMIT 1;
    """)
    customer_id = cur.fetchone()[0]

    # Create order
    cur.execute("""
        INSERT INTO orders (
            customer_id,
            order_status,
            shipping_city,
            shipping_state,
            discount_amount,
            tax_amount,
            shipping_amount
        )
        VALUES (
            %s,
            'PLACED',
            'Chennai',
            'Tamil Nadu',
            0,
            0,
            50
        )
        RETURNING order_id;
    """, (customer_id,))

    order_id = cur.fetchone()[0]

    # Select 1–4 products
    cur.execute("""
        SELECT product_id, unit_price
        FROM products
        WHERE is_active = TRUE
          AND stock_quantity > 0
        ORDER BY random()
        LIMIT %s;
    """, (random.randint(1, 4),))

    products = cur.fetchall()

    subtotal = 0

    for product_id, unit_price in products:

        quantity = random.randint(1, 3)

        discount = round(
            float(unit_price) * quantity * random.uniform(0, 0.10),
            2
        )

        line_total = round(
            float(unit_price) * quantity - discount,
            2
        )

        subtotal += line_total

        # Insert order item
        cur.execute("""
            INSERT INTO order_items (
                order_id,
                product_id,
                quantity,
                unit_price,
                discount_amount,
                line_total
            )
            VALUES (%s, %s, %s, %s, %s, %s);
        """, (
            order_id,
            product_id,
            quantity,
            unit_price,
            discount,
            line_total
        ))

        # Reduce stock
        cur.execute("""
            UPDATE products
            SET stock_quantity = stock_quantity - %s
            WHERE product_id = %s;
        """, (quantity, product_id))

    # Calculate order totals
    order_discount = round(subtotal * random.uniform(0, 0.05), 2)
    tax = round((subtotal - order_discount) * 0.05, 2)
    shipping = 50

    total = round(
        subtotal - order_discount + tax + shipping,
        2
    )

    cur.execute("""
        UPDATE orders
        SET discount_amount = %s,
            tax_amount = %s,
            shipping_amount = %s,
            total_amount = %s
        WHERE order_id = %s;
    """, (
        order_discount,
        tax,
        shipping,
        total,
        order_id
    ))

    conn.commit()

    cur.close()

    print(
        f"[{datetime.now()}] "
        f"New order #{order_id} | "
        f"Customer #{customer_id} | "
        f"Total ₹{total}"
    )


def update_customer(conn):
    cur = conn.cursor()

    cur.execute("""
        SELECT customer_id
        FROM customers
        ORDER BY random()
        LIMIT 1;
    """)

    customer_id = cur.fetchone()[0]

    cities = [
        ("Chennai", "Tamil Nadu"),
        ("Bangalore", "Karnataka"),
        ("Hyderabad", "Telangana"),
        ("Pune", "Maharashtra"),
        ("Mumbai", "Maharashtra"),
        ("Delhi", "Delhi")
    ]

    city, state = random.choice(cities)

    cur.execute("""
        UPDATE customers
        SET city = %s,
            state = %s
        WHERE customer_id = %s;
    """, (city, state, customer_id))

    conn.commit()
    cur.close()

    print(
        f"[{datetime.now()}] "
        f"Customer #{customer_id} updated → {city}"
    )


def update_product(conn):
    cur = conn.cursor()

    cur.execute("""
        SELECT product_id
        FROM products
        ORDER BY random()
        LIMIT 1;
    """)

    product_id = cur.fetchone()[0]

    price_change = random.uniform(0.95, 1.10)

    cur.execute("""
        UPDATE products
        SET unit_price = ROUND(unit_price * %s, 2)
        WHERE product_id = %s;
    """, (price_change, product_id))

    conn.commit()
    cur.close()

    print(
        f"[{datetime.now()}] "
        f"Product #{product_id} price updated"
    )


def update_order_status(conn):
    cur = conn.cursor()

    cur.execute("""
        SELECT order_id, order_status
        FROM orders
        WHERE order_status IN ('PLACED', 'CONFIRMED', 'SHIPPED')
        ORDER BY random()
        LIMIT 1;
    """)

    row = cur.fetchone()

    if not row:
        cur.close()
        return

    order_id, current_status = row

    next_status = {
        "PLACED": "CONFIRMED",
        "CONFIRMED": "SHIPPED",
        "SHIPPED": "DELIVERED"
    }

    new_status = next_status[current_status]

    cur.execute("""
        UPDATE orders
        SET order_status = %s
        WHERE order_id = %s;
    """, (new_status, order_id))

    conn.commit()
    cur.close()

    print(
        f"[{datetime.now()}] "
        f"Order #{order_id}: "
        f"{current_status} → {new_status}"
    )


def main():

    print("Starting Chocolate Shop Data Generator...")

    while True:

        try:
            conn = get_connection()

            event = random.choice([
                "order",
                "order",
                "order",
                "customer",
                "product",
                "status"
            ])

            if event == "order":
                create_order(conn)

            elif event == "customer":
                update_customer(conn)

            elif event == "product":
                update_product(conn)

            elif event == "status":
                update_order_status(conn)

            conn.close()

            # Wait 5–15 seconds
            time.sleep(random.randint(5, 15))

        except Exception as e:

            print(f"ERROR: {e}")

            time.sleep(10)


if __name__ == "__main__":
    main()