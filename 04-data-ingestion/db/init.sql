-- Seed data for the QueryDatabaseTable incremental-ingestion exercise.
-- Runs automatically on first Postgres container startup (docker-entrypoint-initdb.d).

CREATE TABLE IF NOT EXISTS orders (
    order_id    SERIAL PRIMARY KEY,
    customer    VARCHAR(100) NOT NULL,
    item        VARCHAR(100) NOT NULL,
    amount      NUMERIC(10,2) NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT now()
);

INSERT INTO orders (customer, item, amount) VALUES
    ('Alice',   'Widget', 19.99),
    ('Bob',     'Gadget', 49.50),
    ('Charlie', 'Gizmo',  9.75);
