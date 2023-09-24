Bombs = {}

RegisterNetEvent('bbv-bombs:plantbomb',function(data)
    Bombs[data.position] = data

    TriggerClientEvent('bbv-bombs:plantbomb:sync',-1,data)
end)

RegisterNetEvent('bbv-bombs:syncdata',function(pos,data,length)
    Bombs[pos] = data
    if Bombs[pos] ~= nil then 
    Bombs[pos].length = length
    end 
    TriggerClientEvent('bbv-bombs:syncdata:client',-1,pos,data,length)
end)

RegisterNetEvent('bbv-bombs:explode',function(data)
    TriggerClientEvent('bbv-bombs:explode:client',-1,data)
end)

Wrapper.CreateCallback('bbv-syncbombs', function(source, cb, args)
    cb(Bombs)
end)

RegisterNetEvent('bbv-bombs:defuse',function(data)
    TriggerClientEvent('bbv-bombs:defuse:client',-1,data)
end)

RegisterNetEvent('bbv-bombs:activate',function(data)
    for i = data.length, 1, -1 do
        Wait(1000)
        if Bombs[data.position] == nil then return end
        Bombs[data.position].length = i
        -- -- ----print(Bombs[data.position].length .. ' ' .. Bombs[data.position].position)
        TriggerEvent('bbv-bombs:syncdata',data.position,data,Bombs[data.position].length)
        -- --print('bbv-bombs:syncdata',data.position,data,Bombs[data.position].length)
        if Bombs[data.position].length <= 1 then 
            TriggerClientEvent('bbv-bombs:explode:client',-1,data)
            TriggerEvent('bbv-bombs:syncdata',data.position,nil,nil)
        end
    end
end)

RegisterCommand('checksv',function()
    for k,v in pairs(Bombs) do
        --print('---------')
        --print('Bomb #' .. k)
        --print('Bomb pos = '..v.position)
        --print('Bomb time = '..v.length)
        --print('---------')
    end
end)