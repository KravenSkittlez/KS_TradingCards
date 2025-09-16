-- ks_tradingcards/client/client.lua

RegisterNetEvent('ks_tradingcards:openPackResult', function(pack, cards)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "showPackResult",
        pack = pack,
        cards = cards
    })
end)

RegisterNetEvent('ks_tradingcards:notify', function(type, msg)
    print(("[ks_tradingcards][%s] %s"):format(type, msg))
    SendNUIMessage({ action = "notify", nType = type, text = msg })
end)

RegisterNetEvent("ks_tradingcards:showCollection", function(cards)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "showCollection", cards = cards })
end)

RegisterCommand("mycards", function()
    TriggerServerEvent("ks_tradingcards:requestCollection")
end)

RegisterNUICallback("closeUI", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)
