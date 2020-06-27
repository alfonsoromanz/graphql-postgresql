\connect ledger;
INSERT INTO ledger_schema.users (name) VALUES
('Alfonso'),
('Juan');
INSERT INTO ledger_schema.transactions (amount, description, user_from_id, user_to_id) VALUES
(15000, 'Consulting Services', 1, 2),
(12000, 'Consulting Services', 1, 2),
(10000, 'Ad Campaign', 2, 1);
