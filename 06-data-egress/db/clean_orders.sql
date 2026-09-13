-- Destination table for the Section 6 egress exercises (PutDatabaseRecord, PutSQL).
-- Applied by hand against the already-initialized `sourcedb` (docker exec nifi-postgres psql ...)
-- since docker-entrypoint-initdb.d scripts only run once, on first container creation.

CREATE TABLE IF NOT EXISTS clean_orders (
    order_id      INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    product_name  VARCHAR(100) NOT NULL,
    total_amount  NUMERIC(10,2) NOT NULL,
    order_date    DATE NOT NULL
);
