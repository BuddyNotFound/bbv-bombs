Bombs = {}

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Wrapper.TriggerCallback('bbv-syncbombs', function(data)
        Bombs = data
        for k,v in pairs(Bombs) do
            TriggerEvent('bbv-bombs:plantbomb:sync',v)
        end
    end)
end)

RegisterNetEvent('bbv-bombs:syncdata:client',function(pos,data,length)
    Bombs[pos] = data
    if Bombs[pos] ~= nil then 
        Bombs[pos].length = length
    end 
end)

RegisterNetEvent('bbv-bombs:plantbomb',function()
    exports['ox_lib']:hideTextUI()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    ExecuteCommand('e pickup')
    Wait(500)

    local input = exports['ox_lib']:inputDialog('Bomb Planting', {
        {type = 'input', label = 'Length', description = 'Length in seconds (120-7200)', required = true, min = 1, max = 4},
        {type = 'input', label = 'Wire', description = 'Red,Green,Blue,Yellow,Purple,White', required = true, min = 1, max = 10},
        {type = 'input', label = 'Colored Sqaures', description = 'Colored Sqaures (5-20)', required = true, min = 1, max = 2},
        {type = 'input', label = 'Time To Complete', description = 'Time To Complete (10-30)', required = true, min = 1, max = 2},
        {type = 'input', label = 'Time To See', description = 'Time To See (3-10)', required = true, min = 1, max = 2},
        {type = 'input', label = 'Attempts', description = 'Attempts (1-10)', required = true, min = 1, max = 2},
        {type = 'input', label = 'Pin', description = 'Used to disable the bomb', required = true, min = 1, max = 6},
      })

    if tonumber(input[1]) < 120 or tonumber(input[1]) > 7200 then 
        Wrapper:Notify('Length must be between (120-7200)')
        return
    end

    local userInput = input[2]:lower()  -- Convert input[2] to lowercase
    if userInput ~= 'red' and
        userInput ~= 'green' and
        userInput ~= 'blue' and
        userInput ~= 'yellow' and
        userInput ~= 'purple' and
        userInput ~= 'white' then
        Wrapper:Notify('Wire must be (red,green,blue,yellow,purple,white)')
        return
    end

    if tonumber(input[3]) < 5 or tonumber(input[3]) > 20 then 
        Wrapper:Notify('Colored Sqaures must be between (5-20)')
        return
    end

    if tonumber(input[4]) < 10 or tonumber(input[4]) > 30 then 
        Wrapper:Notify('Time To Complete must be between (10-30)')
        return
    end

    if tonumber(input[5]) < 3 or tonumber(input[5]) > 10 then 
        Wrapper:Notify('Time To See must be between (3-10)')
        return
    end

    if tonumber(input[5]) < 3 or tonumber(input[5]) > 10 then 
        Wrapper:Notify('Attempts must be between (5-12)')
        return
    end

    data = {
        length = tonumber(input[1]), -- Length in seconds (120-7200)
        wire = userInput, -- Wire to cut
        correctBlocks = input[3], -- Grid Size (5-12)
        timetoLose = input[4], -- Colored Sqaures (5-20)
        timetoShow = input[5], -- Time To Complete (10-30)
        incorrectBlocks = input[6],
        position = pos,
        pin = input[7]
    }
    Wrapper:RemoveItem(Config.Settings.ItemName,1)
    Wrapper:Log('Planted A Bomb at : ' .. GetEntityCoords(PlayerPedId()) .. ' | ' .. data.length .. ' Seconds left.' .. " PIN : " ..data.pin)
    AlertPolice()
    TriggerServerEvent('bbv-bombs:plantbomb',data)
end)

RegisterNetEvent('bbv-bombs:plantbomb:sync',function(data)
    TriggerServerEvent("bbv-bombs:activate",data)
    Bombs[data.position] = data

    Wrapper:LoadModel(Config.Settings.Prop)
    Wrapper:CreateObject('bomb'..Bombs[data.position].position,Config.Settings.Prop,Bombs[data.position].position,false)
    Wrapper:Target('bomb'..Bombs[data.position].position,label,Bombs[data.position].position,event,type)
end)

RegisterNetEvent('bbv-bombs:bomb:checkTime',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            Wrapper:Notify('Time remaining : ' .. Bombs[v.position].length .. " seconds")
        end
    end
end)

RegisterNetEvent('bbv-bombs:defuse:client',function(data)
    Wrapper:DeleteObject('bomb'..Bombs[data].position)
    Wrapper:TargetRemove('bomb'..Bombs[data].position)
    if Bombs[data] ~= nil then 
        Bombs[data] = nil
    end
end)

RegisterNetEvent('bbv-bombs:cut:red',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do 
        local dist = #(mypos - v.position)      
        if dist <= 3 then 
            local color = Bombs[v.position].wire
            if color == 'red' then 
                exports["bbv-bombs"]:thermiteminigame(v.correctBlocks , v.incorrectBlocks, v.timetoShow , v.timetoLose,
                function()
                    Wrapper:Notify("You defused the bomb.")
                    
                    TriggerServerEvent('bbv-bombs:defuse',v.position)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end,
                function()
                    Wrapper:Notify("You failed the defusion.")
                    explosion = {
                        position = v.position
                    }
                    TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end)
            else
                Wrapper:Notify("Wrong wire.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)

RegisterNetEvent('bbv-bombs:cut:green',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            local color = Bombs[v.position].wire
            if color == 'green' then 
                exports["bbv-bombs"]:thermiteminigame(v.correctBlocks , v.incorrectBlocks, v.timetoShow , v.timetoLose,
                function()
                    Wrapper:Notify("You defused the bomb.")

                    
                    TriggerServerEvent('bbv-bombs:defuse',v.position)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end,
                function()
                    Wrapper:Notify("You failed the defusion.")
                    explosion = {
                        position = v.position
                    }
                    TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end)
            else
                Wrapper:Notify("Wrong wire.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)

RegisterNetEvent('bbv-bombs:cut:blue',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do 
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            local color = Bombs[v.position].wire
            if color == 'blue' then 
                exports["bbv-bombs"]:thermiteminigame(v.correctBlocks , v.incorrectBlocks, v.timetoShow , v.timetoLose,
                function()
                    Wrapper:Notify("You defused the bomb.")
                    
                    TriggerServerEvent('bbv-bombs:defuse',v.position)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end,
                function()
                    Wrapper:Notify("You failed the defusion.")
                    explosion = {
                        position = v.position
                    }
                    TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end)
            else
                Wrapper:Notify("Wrong wire.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)

RegisterNetEvent('bbv-bombs:cut:yellow',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do 
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            local color = Bombs[v.position].wire
            if color == 'yellow' then 
                exports["bbv-bombs"]:thermiteminigame(v.correctBlocks , v.incorrectBlocks, v.timetoShow , v.timetoLose,
                function()
                    Wrapper:Notify("You defused the bomb.")
                    
                    TriggerServerEvent('bbv-bombs:defuse',v.position)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end,
                function()
                    Wrapper:Notify("You failed the defusion.")
                    explosion = {
                        position = v.position
                    }
                    TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end)
            else
                Wrapper:Notify("Wrong wire.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)

RegisterNetEvent('bbv-bombs:cut:purple',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do 
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            local color = Bombs[v.position].wire
            if color == 'purple' then 
                exports["bbv-bombs"]:thermiteminigame(v.correctBlocks , v.incorrectBlocks, v.timetoShow , v.timetoLose,
                function()
                    Wrapper:Notify("You defused the bomb.")
                    
                    TriggerServerEvent('bbv-bombs:defuse',v.position)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end,
                function()
                    Wrapper:Notify("You failed the defusion.")
                    explosion = {
                        position = v.position
                    }
                    TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end)
            else
                Wrapper:Notify("Wrong wire.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)

RegisterNetEvent('bbv-bombs:cut:white',function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do 
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            local color = Bombs[v.position].wire
            if color == 'white' then 
                exports["bbv-bombs"]:thermiteminigame(v.correctBlocks , v.incorrectBlocks, v.timetoShow , v.timetoLose,
                function()
                    Wrapper:Notify("You defused the bomb.")
                    
                    TriggerServerEvent('bbv-bombs:defuse',v.position)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end,
                function()
                    Wrapper:Notify("You failed the defusion.")
                    explosion = {
                        position = v.position
                    }
                    TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
                end)
            else
                Wrapper:Notify("Wrong wire.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                    TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)

RegisterNetEvent("bbv-bombs:pin",function()
    mypos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Bombs) do 
        local dist = #(mypos - v.position)
        if dist <= 3 then 
            local input = exports['ox_lib']:inputDialog('Bomb Planting', {
                {type = 'input', label = 'Pin', description = 'Used to disable the bomb', required = true, min = 1, max = 6},
              })
            if input[1] == Bombs[v.position].pin then 
                Wrapper:Notify("You defused the bomb.")
                TriggerServerEvent('bbv-bombs:defuse',v.position)
                TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            else
                Wrapper:Notify("You failed the defusion.")
                explosion = {
                    position = v.position
                }
                TriggerServerEvent('bbv-bombs:explode',explosion)
                TriggerServerEvent('bbv-bombs:syncdata',v.position,nil,nil)
            end
        end
    end
end)



RegisterNetEvent('bbv-bombs:explode:client')
AddEventHandler('bbv-bombs:explode:client', function (data)
    if data == nil then return end
    local offsets = {
        { ["x"] = 0, ["y"] = 0 },
        { ["x"] = 8, ["y"] = 8 },
        { ["x"] = 8, ["y"] = -8 },
        { ["x"] = -8, ["y"] = 8 },
        { ["x"] = -8, ["y"] = -8 },
        { ["x"] = 16, ["y"] = 16 },
        { ["x"] = 16, ["y"] = -16 },
        { ["x"] = -16, ["y"] = 16 },
        { ["x"] = -16, ["y"] = -16 },
        { ["x"] = 16, ["y"] = 0 },
        { ["x"] = -16, ["y"] = 0 },
        { ["x"] = 0, ["y"] = 16 },
        { ["x"] = 0, ["y"] = -16 },
    }
    for k, v in pairs(offsets) do
        AddExplosion(
            data.position.x + v.x,
            data.position.y + v.y,
            data.position.z,
            8,
            10.0,
            true,
            false,
            0.0
        )
    end
    local dist = #(vec3(data.position.x,data.position.y,data.position.z) - GetEntityCoords(PlayerPedId()))
    if dist < 25 then 
        SetEntityHealth(PlayerPedId(), 0)
    end
    Wrapper:DeleteObject('bomb'..Bombs[data.position].position)
    Wrapper:TargetRemove('bomb'..Bombs[data.position].position)
    if Bombs[data.position] ~= nil then 
        Bombs[data.position] = nil
    end
    TriggerServerEvent('bbv-bombs:syncdata',data.position,nil,nil)
end)


RegisterNetEvent('bbv-bombs:beep',function(pos, maxDistance)
    local myCoords = GetEntityCoords(PlayerPedId())
    local distance = #(myCoords - pos)
    print(distance,maxDistance)
    if distance < maxDistance then
        local distanceRatio = distance / maxDistance
        local adjustedVolume = 0.5 * (1 - distanceRatio)
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile  = 'beep',
            transactionVolume = adjustedVolume
        })
    end
end)

function AlertPolice()
    if Config.Settings.PoliceAlert then 
        exports["ps-dispatch"]:CustomAlert({
            coords = GetEntityCoords(PlayerPedId()),
            message = "Bomb Threat",
            dispatchCode = "ICD-10 Bomb Threat",
            description = "Bomb Threat",
            radius = 5,
            sprite = 653,
            color = 21,
            scale = 1.0,
            length = 100,
        }) 
    end
end