-- ks_tradingcards/config.lua

Config = {}

-- Debug flags
Config.Debug = false              -- Enables in-game admin debug commands
Config.EnableDebugFile = true     -- Loads ks_debug.lua if true

-- Rarity odds (default)
Config.RarityOdds = {
    Common = 65.0,
    Rare = 25.0,
    Epic = 7.0,
    Legendary = 2.5,
    Mythic = 0.5,
}

-- Cards
Config.Cards = {
    -- Main Characters (Common)
    { id = 1, name = "Michael De Santa", rarity = "Common", image = "michael_de_santa.png" },
    { id = 2, name = "Franklin Clinton", rarity = "Common", image = "franklin_clinton.png" },
    { id = 3, name = "Trevor Philips", rarity = "Common", image = "trevor_phillips.png" },
    { id = 4, name = "Amanda De Santa", rarity = "Common", image = "Amanda_De_Santa.png" },
    { id = 5, name = "Jimmy De Santa", rarity = "Common", image = "Jimmy_De_Santa.png" },
    { id = 6, name = "Denise Clinton", rarity = "Common", image = "Denise_Clinton.png" },
    { id = 7, name = "Chop", rarity = "Common", image = "chop.png" },
    
    -- Supporting Characters (Rare)
    { id = 8, name = "Dave Norton", rarity = "Rare", image = "Dave_Norton.png" },
    { id = 9, name = "Martin Madrazo", rarity = "Rare", image = "Martin_Madrazo.png" },
    { id = 10, name = "Devin Weston", rarity = "Rare", image = "Devin_Weston.png" },
    { id = 11, name = "Dr Friedlander", rarity = "Rare", image = "Dr_Friedlander.png" },
    { id = 12, name = "Barry", rarity = "Rare", image = "Barry.png" },
    { id = 13, name = "Dom Beasley", rarity = "Rare", image = "Dom_Beasley.png" },
    { id = 14, name = "Mary Ann Quinn", rarity = "Rare", image = "Mary_Ann_Quinn.png" },
    { id = 15, name = "Josh Bernstein", rarity = "Rare", image = "Josh_Bernstein.png" },
    { id = 16, name = "Hugh Welsh", rarity = "Rare", image = "Hugh_Welsh.png" },
    { id = 17, name = "Gerald", rarity = "Rare", image = "Gerald.png" },
    { id = 18, name = "Casey", rarity = "Rare", image = "Casey.png" },
    
    -- Special Characters (Epic)
    { id = 19, name = "Wei Cheng", rarity = "Epic", image = "wei_cheng.png" },
    { id = 20, name = "El Rubio", rarity = "Epic", image = "El_Rubio.png" },
    { id = 21, name = "Luis Lopez", rarity = "Epic", image = "Luis_Lopez.png" },
    { id = 22, name = "Chef", rarity = "Epic", image = "Chef.png" },
    { id = 23, name = "Al Di Napoli", rarity = "Epic", image = "Al_Di_Napoli.png" },
    { id = 24, name = "Eddie Toh", rarity = "Epic", image = "Eddie_Toh.png" },
    { id = 25, name = "Fabian LaRouche", rarity = "Epic", image = "Fabian_LaRouche.png" },
    { id = 26, name = "Kyle Chavis", rarity = "Epic", image = "Kyle_Chavis.png" },
    { id = 27, name = "Brad Snider", rarity = "Epic", image = "Brad_Snider.png" },
    { id = 28, name = "Ashley Butler", rarity = "Epic", image = "Ashley_Butler.png" },
    { id = 29, name = "Elwood ONeil", rarity = "Epic", image = "Elwood_ONeil.png" },
    { id = 30, name = "Malc", rarity = "Epic", image = "Malc.png" },
    
    -- Rare Characters (Legendary)
    { id = 31, name = "Cris Formage", rarity = "Legendary", image = "Cris_Formage.png" },
    { id = 32, name = "Abigail Mathers", rarity = "Legendary", image = "Abigail_Mathers.png" },
    { id = 33, name = "Daisy Bell", rarity = "Legendary", image = "Daisy_Bell.png" },
    { id = 34, name = "Debra Hebert", rarity = "Legendary", image = "Debra_Hebert.png" },
    { id = 35, name = "Marnie Allen", rarity = "Legendary", image = "Marnie_Allen.png" },
    
    -- Additional Characters (Rare)
    { id = 36, name = "Simeon Yetarian", rarity = "Rare", image = "Simeon_Yetarian.png" },
    { id = 37, name = "Tanisha Jackson", rarity = "Rare", image = "Tanisha_Jackson.png" },
    { id = 38, name = "Solomon Richards", rarity = "Rare", image = "Solomon_Richards.png" },
    { id = 39, name = "Terry Thorpe", rarity = "Rare", image = "Terry_Thorpe.png" },
    { id = 40, name = "Nigel", rarity = "Rare", image = "Nigel.png" },
    { id = 41, name = "Mrs Thornhill", rarity = "Rare", image = "Mrs_Thornhill.png" },
    
    -- Additional Epic Characters
    { id = 42, name = "Tao Cheng", rarity = "Epic", image = "Tao_Cheng.png" },
    { id = 43, name = "Rocco Pelosi", rarity = "Epic", image = "Rocco_Pelosi.png" },
    { id = 44, name = "Patricia Madrazo", rarity = "Epic", image = "Patricia_Madrazo.png" },
    { id = 46, name = "Walton ONeil", rarity = "Epic", image = "Walton_ONeil.png" },
    { id = 47, name = "Ortega", rarity = "Epic", image = "Ortega.png" },
    { id = 48, name = "Taos Translator", rarity = "Epic", image = "Taos_Translator.png" },
    
    -- Additional Legendary Characters
    { id = 49, name = "Molly Schultz", rarity = "Legendary", image = "Molly_Schultz.png" },
    { id = 50, name = "Poppy Mitchell", rarity = "Legendary", image = "Poppy_Mitchell.png" },
    
    -- Mythic Character
    { id = 51, name = "Bigfoot", rarity = "Mythic", image = "Bigfoot.png" },
}
Config.CardById = {}
for _, card in ipairs(Config.Cards) do
    Config.CardById[card.id] = card
end

-- Packs
Config.Packs = {
    {
        pack_id = "standard",
        name = "Standard Pack",
        cost = 1000,
        contents = { total = 5, guaranteedCount = 1, guaranteedAtLeast = "Rare" }
    },
    {
        pack_id = "premium",
        name = "Premium Pack",
        cost = 2500,
        contents = { total = 7, guaranteedCount = 2, guaranteedAtLeast = "Epic" }
    }
}
Config.PackById = {}
for _, pack in ipairs(Config.Packs) do
    Config.PackById[pack.pack_id] = pack
end
