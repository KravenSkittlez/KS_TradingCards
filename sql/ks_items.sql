-- Items for trading cards (ox_inventory example)

INSERT INTO items (name, label, weight, stack, closeonuse, description) VALUES
('pack_standard', 'Standard Card Pack', 1, 100, 1, 'Contains 5 cards, at least 1 Rare.'),
('pack_premium', 'Premium Card Pack', 1, 100, 1, 'Contains 7 cards, at least 2 Epic.');

-- Individual Card Items
INSERT INTO items (name, label, weight, stack, closeonuse, description) VALUES
('card_1', 'Michael De Santa (Common)', 1, 100, 0, 'Trading Card'),
('card_2', 'Franklin Clinton (Common)', 1, 100, 0, 'Trading Card'),
('card_3', 'Trevor Philips (Rare)', 1, 100, 0, 'Trading Card'),
('card_4', 'Lamar Davis (Rare)', 1, 100, 0, 'Trading Card'),
('card_5', 'Wei Cheng (Epic)', 1, 100, 0, 'Trading Card');