CREATE DATABASE ledger;
\connect ledger;
CREATE SCHEMA ledger_schema;
CREATE TABLE ledger_schema.users (
    id SERIAL PRIMARY KEY,
    name TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE ledger_schema.users IS
'User information.';
CREATE TABLE ledger_schema.transactions (
    id SERIAL PRIMARY KEY,
    amount INTEGER NOT NULL,
    description TEXT,
    user_from_id INTEGER NOT NULL REFERENCES ledger_schema.users(id),
    user_to_id INTEGER NOT NULL REFERENCES ledger_schema.users(id),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE ledger_schema.transactions IS
'Transactions for all users.';
