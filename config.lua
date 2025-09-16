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
    { id = 1, name = "Michael De Santa", rarity = "Common" },
    { id = 2, name = "Franklin Clinton", rarity = "Common" },
    { id = 3, name = "Trevor Philips", rarity = "Rare" },
    { id = 4, name = "Lamar Davis", rarity = "Rare" },
    { id = 5, name = "Wei Cheng", rarity = "Epic" },
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
