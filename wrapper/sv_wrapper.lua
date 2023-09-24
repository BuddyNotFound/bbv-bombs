Wrapper = {
    ServerCallbacks = {}
}


RegisterNetEvent("Wrapper:bomb:Log",function(_txt)
    local src = source
    local txt = _txt
    local name = GetPlayerName(src)
    local steam = GetPlayerIdentifier(src)
    local ip = GetPlayerEndpoint(src)
    local identifiers = Wrapper:Identifiers(src)
    local license = identifiers.license
    local discord ="<@" ..identifiers.discord:gsub("discord:", "")..">" 
    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = txt,
                ["description"] = "Name: **"..name.."**\nSteam ID: **"..steam.."**\nIP: **" .. ip .."**\nGTA License: **" .. license .. "**\nDiscord Tag: **" .. discord .. "**\nLog: **"..txt.."**", -- Main Body of embed with the info about the person who left
            }
        }
    
        PerformHttpRequest(Config.Settings.WebHook, function(err, text, headers) end, "POST", json.encode({username = username, embeds = disconnect, tts = TTS}), { ["Content-Type"] = "application/json" }) -- Perform the request to the discord webhook and send the specified message
end)

RegisterNetEvent("Wrapper:bomb:RemoveItem",function(item,amount)
    if item == nil then 
        return 
    end
    if amount == nil then 
        amount = 1 
    end
    Wrapper:RemoveItemServer(item,amount)
end)



function Wrapper:RemoveItemServer(item,amount)
    if item == nil then 
        return 
    end
    if amount == nil then 
        amount = 1 
    end
    if Config.Settings.Framework == "QB" then 
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end
        Player.Functions.RemoveItem(item, amount) 
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "remove")
    end
    if Config.Settings.Framework == "ESX" then 
        local src = source 
        if Config.Settings.Inventory == "QS" then 
            exports["qs-inventory"]:RemoveItem(src, item, amount)
            return
        end
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, amount)
    end
end
function Wrapper:Identifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

