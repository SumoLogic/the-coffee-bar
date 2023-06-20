CREATE USER account WITH PASSWORD 'account';
CREATE DATABASE account;
GRANT ALL PRIVILEGES ON DATABASE account TO account;

\c account;


ALTER SYSTEM SET log_checkpoints = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_min_duration_statement = 1;
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_duration = on;
ALTER SYSTEM SET log_hostname = on;
ALTER SYSTEM SET log_timezone = 'UTC';
ALTER SYSTEM SET log_min_messages = 'WARNING';
ALTER SYSTEM SET log_line_prefix = '%m [%p] %q%u@%d ';
SELECT pg_reload_conf() ;
CREATE TABLE IF NOT EXISTS account (
                                    id SERIAL PRIMARY KEY,
                                    product VARCHAR(255),
                                    price SMALLINT,
                                    items_sold BIGINT
                                    );
CREATE UNIQUE INDEX IF NOT EXISTS product ON account (product);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO account;

INSERT INTO account (product, price, items_sold) VALUES ('espresso', 2, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('cappuccino', 4, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('americano', 3, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('cornetto', 1, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('cannolo_siciliano', 3, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('torta', 2, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('budini_fiorentini', 1, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('muffin', 1, 0)
    ON CONFLICT (product) DO NOTHING;
INSERT INTO account (product, price, items_sold) VALUES ('tiramisu', 3, 0)
    ON CONFLICT (product) DO NOTHING;
