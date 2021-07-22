CREATE USER account WITH PASSWORD 'account';
CREATE DATABASE account;
GRANT ALL PRIVILEGES ON DATABASE account TO account;

\c account;

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
