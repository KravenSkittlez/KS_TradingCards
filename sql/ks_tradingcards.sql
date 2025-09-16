-- Trading Cards SQL schema

CREATE TABLE IF NOT EXISTS ks_cards_collection (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    card_id INT NOT NULL,
    amount INT NOT NULL DEFAULT 1,
    UNIQUE(identifier, card_id)
);

CREATE TABLE IF NOT EXISTS ks_cards_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60) NOT NULL,
    card_id INT NOT NULL,
    amount INT NOT NULL DEFAULT 1,
    UNIQUE(identifier, card_id)
);
