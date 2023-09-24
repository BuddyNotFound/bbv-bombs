if Config.Settings.Framework == "QB" then 
    if Config.Debug then 
        print("QB LOADED")
    end
    QBCore.Functions.CreateUseableItem(Config.Settings.ItemName, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) then
            TriggerClientEvent('bbv-bombs:plantbomb', src)
        end
    end)
end

if Config.Settings.Framework == "ESX" then 
    if Config.Debug then 
        print("ESX LOADED")
    end
    ESX.RegisterUsableItem(Config.Settings.ItemName, function(source)
        local src = source
        TriggerClientEvent('bbv-bombs:plantbomb', src)
        return
    end)
end

