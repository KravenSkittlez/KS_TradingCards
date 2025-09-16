-- ks_tradingcards/server/server.lua
-- Core trading card logic (production-safe, with SQL persistence)

local oddsFile = "data/odds.json"

CreateThread(function()
    local saved = LoadResourceFile(GetCurrentResourceName(), oddsFile)
    if saved then
        local ok, parsed = pcall(json.decode, saved)
        if ok and parsed then
            Config.RarityOdds = parsed
            print("^2[ks_tradingcards]^7 Loaded saved odds from " .. oddsFile)
        else
            print("^1[ks_tradingcards]^7 Failed to parse odds.json, using default odds.")
        end
    else
        print("^3[ks_tradingcards]^7 No saved odds found, using default odds.")
    end
end)

-- Card picker functions
function pickCardAnyWeighted()
    local roll = math.random() * 100
    local cumulative = 0
    for rarity, chance in pairs(Config.RarityOdds) do
        cumulative = cumulative + chance
        if roll <= cumulative then
            local pool = {}
            for _, card in ipairs(Config.Cards) do
                if card.rarity == rarity then
                    table.insert(pool, card)
                end
            end
            if #pool > 0 then
                return pool[math.random(#pool)]
            end
        end
    end
    return nil
end

function pickCardByRarity(rarity)
    local pool = {}
    for _, card in ipairs(Config.Cards) do
        if card.rarity == rarity then
            table.insert(pool, card)
        end
    end
    if #pool > 0 then
        return pool[math.random(#pool)]
    end
    return nil
end

-- DB helpers (oxmysql)
function GetIdentifier(src)
    local identifier = GetPlayerIdentifierByType(src, "license")
    if not identifier then
        identifier = GetPlayerIdentifier(src, 0)
    end
    return identifier
end

function AddCardToCollection(identifier, cardId, amount)
    exports.oxmysql:execute(
        "INSERT INTO ks_cards_collection (identifier, card_id, amount) VALUES (?, ?, ?) " ..
        "ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount)",
        { identifier, cardId, amount }
    )
end

function LoadPlayerCollection(identifier, cb)
    exports.oxmysql:execute(
        "SELECT card_id, amount FROM ks_cards_collection WHERE identifier = ?",
        { identifier },
        function(rows)
            local collection = {}
            for _, row in ipairs(rows) do
                collection[row.card_id] = row.amount
            end
            cb(collection)
        end
    )
end

function AddInventoryCard(src, cardId, amount)
    local identifier = GetIdentifier(src)
    exports.oxmysql:execute(
        "INSERT INTO ks_cards_inventory (identifier, card_id, amount) VALUES (?, ?, ?) " ..
        "ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount)",
        { identifier, cardId, amount }
    )
end

function LoadInventory(identifier, cb)
    exports.oxmysql:execute(
        "SELECT card_id, amount FROM ks_cards_inventory WHERE identifier = ?",
        { identifier },
        function(rows)
            local inv = {}
            for _, row in ipairs(rows) do
                inv[row.card_id] = row.amount
            end
            cb(inv)
        end
    )
end

function ClearInventory(identifier)
    exports.oxmysql:execute(
        "DELETE FROM ks_cards_inventory WHERE identifier = ?",
        { identifier }
    )
end

-- Pack opening
function GiveCardItem(src, card)
    if GetResourceState("ox_inventory") == "started" then
        local itemName = "card_" .. card.id
        exports.ox_inventory:AddItem(src, itemName, 1)
    end
end

function OpenPackForPlayer(src, pack)
    local identifier = GetIdentifier(src)
    if not identifier then return false end

    local cards = {}
    local guaranteed = pack.contents.guaranteedCount or 0
    local total = pack.contents.total or 5
    local atleast = pack.contents.guaranteedAtLeast or "Rare"

    for i = 1, guaranteed do
        local c = pickCardByRarity(atleast)
        if c then
            AddCardToCollection(identifier, c.id, 1)
            AddInventoryCard(src, c.id, 1)
            table.insert(cards, c)
        end
    end

    for i = guaranteed + 1, total do
        local c = pickCardAnyWeighted()
        if c then
            AddCardToCollection(identifier, c.id, 1)
            AddInventoryCard(src, c.id, 1)
            table.insert(cards, c)
        end
    end

    return true, cards
end

-- Collection request event
RegisterNetEvent("ks_tradingcards:requestCollection", function()
    local src = source
    local identifier = GetIdentifier(src)
    if not identifier then return end

    LoadPlayerCollection(identifier, function(collection)
        local cards = {}
        for cardId, amount in pairs(collection) do
            local def = Config.CardById[cardId]
            if def then
                table.insert(cards, {
                    id = cardId,
                    name = def.name,
                    rarity = def.rarity,
                    amount = amount
                })
            end
        end
        TriggerClientEvent("ks_tradingcards:showCollection", src, cards)
    end)
end)

-- Startup summary
CreateThread(function()
    Wait(500)
    if Config.EnableDebugFile and Config.Debug then
        print("^2[ks_tradingcards]^7 Debug Mode ENABLED (In-game + Console tools).")
    elseif Config.EnableDebugFile and not Config.Debug then
        print("^3[ks_tradingcards]^7 Console-Only Debug Mode ENABLED (In-game tools disabled).")
    else
        print("^1[ks_tradingcards]^7 Production Mode (No debug tools loaded).")
    end
end)

-- Usable items (ox_inventory example)
if GetResourceState("ox_inventory") == "started" then
    exports.ox_inventory:registerUsableItem("pack_standard", function(data, slot)
        local src = data.source
        local pack = Config.PackById["standard"]
        if not pack then return end

        local ok, cards = OpenPackForPlayer(src, pack)
        if ok then
            exports.ox_inventory:RemoveItem(src, "pack_standard", 1, nil, slot.slot)
            TriggerClientEvent("ks_tradingcards:openPackResult", src, pack, cards)
        end
    end)

    exports.ox_inventory:registerUsableItem("pack_premium", function(data, slot)
        local src = data.source
        local pack = Config.PackById["premium"]
        if not pack then return end

        local ok, cards = OpenPackForPlayer(src, pack)
        if ok then
            exports.ox_inventory:RemoveItem(src, "pack_premium", 1, nil, slot.slot)
            TriggerClientEvent("ks_tradingcards:openPackResult", src, pack, cards)
        end
    end)
end