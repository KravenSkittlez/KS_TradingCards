-- ks_tradingcards/server/ks_debug.lua
-- Debug / balancing toolkit for ks_tradingcards

if not Config.EnableDebugFile then
    return -- don't load if disabled
end

-- Save odds to file
local function saveOdds()
    SaveResourceFile(GetCurrentResourceName(), "data/odds.json", json.encode(Config.RarityOdds, { indent = true }), -1)
    print("[ks_tradingcards] Odds saved to data/odds.json")
end

-- Commands (console always, in-game if Debug=true)
RegisterCommand("showodds", function(src)
    print("[ks_tradingcards] Current Odds:")
    for r, v in pairs(Config.RarityOdds) do
        print(("  %s: %.2f%%"):format(r, v))
    end
end, true)

RegisterCommand("setodds", function(src, args)
    if src ~= 0 and not Config.Debug then return end
    local rarity, percent = args[1], tonumber(args[2])
    if not rarity or not percent then return end
    if not Config.RarityOdds[rarity] then
        print("[ks_tradingcards] Invalid rarity")
        return
    end
    Config.RarityOdds[rarity] = percent
    print(("[ks_tradingcards] Set %s odds to %.2f%%"):format(rarity, percent))
end, true)

RegisterCommand("saveodds", function(src)
    if src ~= 0 and not Config.Debug then return end
    saveOdds()
end, true)

RegisterCommand("resetodds", function(src)
    if src ~= 0 and not Config.Debug then return end
    Config.RarityOdds = {
        Common = 65.0,
        Rare = 25.0,
        Epic = 7.0,
        Legendary = 2.5,
        Mythic = 0.5,
    }
    print("[ks_tradingcards] Odds reset to defaults")
end, true)

RegisterCommand("debugcards", function(src)
    for _, c in ipairs(Config.Cards) do
        print(("[%d] %s (%s)"):format(c.id, c.name, c.rarity))
    end
end, true)

RegisterCommand("debugpacks", function(src)
    for _, p in ipairs(Config.Packs) do
        print(("[%s] %s (%d cards)"):format(p.pack_id, p.name, p.contents.total))
    end
end, true)

-- Test drops
RegisterCommand("testdrop", function(src, args)
    local packId, runs, mode = args[1], tonumber(args[2]), args[3]
    if not packId or not runs then return end
    local pack = Config.PackById[packId]
    if not pack then print("[ks_tradingcards] Invalid pack") return end

    local counts = {}
    local rarityCounts = {}
    for _, c in ipairs(Config.Cards) do counts[c.id] = 0 end

    local total = pack.contents.total * runs
    for i = 1, runs do
        local _, pulled = OpenPackForPlayer(0, pack)
        for _, c in ipairs(pulled) do
            counts[c.id] = counts[c.id] + 1
            rarityCounts[c.rarity] = (rarityCounts[c.rarity] or 0) + 1
        end
    end

    print(("[testdrop] Results after %d runs of pack '%s' (%d cards total):"):format(runs, packId, total))
    for rarity, cnt in pairs(rarityCounts) do
        print(("  %s: %d (%.2f%%)"):format(rarity, cnt, (cnt / total) * 100))
    end
end, true)
