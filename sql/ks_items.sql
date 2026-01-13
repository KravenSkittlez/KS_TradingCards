-- Items for trading cards (QBCore format)
-- Add these items to your qb-core/shared/items.lua file instead of running this SQL

--[[
-- Add these to your qb-core/shared/items.lua items table:

['pack_standard'] = {
    ['name'] = 'pack_standard',
    ['label'] = 'Standard Card Pack',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'pack_standard.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Contains 5 cards, at least 1 Rare.'
},

['pack_premium'] = {
    ['name'] = 'pack_premium',
    ['label'] = 'Premium Card Pack',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'pack_premium.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'Contains 7 cards, at least 2 Epic.'
},

-- Individual Card Items
['card_1'] = {
    ['name'] = 'card_1',
    ['label'] = 'Michael De Santa (Common)',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'card_1.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'Trading Card'
},

['card_2'] = {
    ['name'] = 'card_2',
    ['label'] = 'Franklin Clinton (Common)',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'card_2.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'Trading Card'
},

['card_3'] = {
    ['name'] = 'card_3',
    ['label'] = 'Trevor Philips (Rare)',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'card_3.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'Trading Card'
},

['card_4'] = {
    ['name'] = 'card_4',
    ['label'] = 'Lamar Davis (Rare)',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'card_4.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'Trading Card'
},

['card_5'] = {
    ['name'] = 'card_5',
    ['label'] = 'Wei Cheng (Epic)',
    ['weight'] = 10,
    ['type'] = 'item',
    ['image'] = 'card_5.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = false,
    ['combinable'] = nil,
    ['description'] = 'Trading Card'
},

--]]