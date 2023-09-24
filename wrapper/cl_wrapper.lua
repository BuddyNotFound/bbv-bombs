
Wrapper = {
    blip = {},
    cam = {},
    zone = {},
    cars = {},
    object = {},
    ServerCallbacks = {}
}


function Wrapper:CreateObject(id,prop,coords,network,misson) -- Create object / prop
    Wrapper.object[id] = CreateObject(GetHashKey(prop), coords.x,coords.y,coords.z - 1, network or false,misson or false)
    -- PlaceObjectOnGroundProperly(Wrapper.object[id])
    SetEntityHeading(Wrapper.object[id], coords.w)
    FreezeEntityPosition(Wrapper.object[id], true)
    SetEntityAsMissionEntity(Wrapper.object[id], true, true)
    if Config.Debug then 
        SetEntityDrawOutline(Wrapper.object[id],true)
    end
end

function Wrapper:Blip(id,label,pos,sprite,color,scale) -- Create Normal Blip on Map
    Wrapper.blip[id] = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite (Wrapper.blip[id], sprite)
    SetBlipDisplay(Wrapper.blip[id], 4)
    SetBlipScale  (Wrapper.blip[id], scale)
    SetBlipAsShortRange(Wrapper.blip[id], true)
    SetBlipColour(Wrapper.blip[id], color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(Wrapper.blip[id])
    return
end

function Wrapper:RemoveBlip(id)
    RemoveBlip(Wrapper.blip[id])
end



function Wrapper:DeleteObject(id)
    DeleteObject(Wrapper.object[id])
end

function Wrapper:LoadModel(model) -- Load Model
    local modelHash = model
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
      Wait(0)
      --print(modelHash)
    end
end


function Wrapper:Target(id,label,pos,event,type) -- QBTarget target create
    if Config.Settings.Target == "QB" then 
        local sizex = 1
        local sizey = 1
        exports["qb-target"]:AddBoxZone(id, pos, sizex, sizey, {
            name = id,
            heading = "90.0",
            minZ = pos - 5,
            maxZ = pos + 5
        }, {
            options = {
                {
                    type = "client",
                    event = "np-miscscripts:bombs:checkTime",
                    icon = "stopwatch",
                    label = "Check remaining time",
                },
                {
                    type = "client",
                    event = "np-miscscripts:bombs:cut",
                    icon = "cut",
                    label = "Cut red wire",
                },
                {
                    type = "client",
                    event = "np-miscscripts:bombs:cut",
                    icon = "cut",
                    label = "Cut green wire",
                },
                {
                    type = "client",
                    event = "np-miscscripts:bombs:cut",
                    icon = "cut",
                    label = "Cut blue wire",
                },
                {
                    type = "client",
                    event = "np-miscscripts:bombs:cut",
                    icon = "cut",
                    label = "Cut yellow wire",
                },
                {
                    type = "client",
                    event = "np-miscscripts:bombs:cut",
                    icon = "cut",
                    label = "Cut purple wire",
                },
                {
                    type = "client",
                    event = "np-miscscripts:bombs:cut",
                    icon = "cut",
                    label = "Cut white wire",
                },
            },
            distance = 1.5
        })
    end
    if Config.Settings.Target == "OX" then 
        Wrapper.zone[id] = exports["ox_target"]:addBoxZone({
        coords = vec3(pos.x,pos.y,pos.z - 1),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = false,
        options = {
            {
                id = "c4_check_time",
                event = "bbv-bombs:bomb:checkTime",
                icon = "fas fa-stopwatch",
                label = "Check remaining time",
            },
            {
                id = "c4_cut_red",
                event = "bbv-bombs:cut:red",
                icon = "fas fa-cut",
                label = "Cut red wire",
            },
            {
                id = "c4_cut_green",
                event = "bbv-bombs:cut:green",
                icon = "fas fa-cut",
                label = "Cut green wire",
            },
            {
                id = "c4_cut_blue",
                event = "bbv-bombs:cut:blue",
                icon = "fas fa-cut",
                label = "Cut blue wire",
            },
            {
                id = "c4_cut_yellow",
                event = "bbv-bombs:cut:yellow",
                icon = "fas fa-cut",
                label = "Cut yellow wire",
            },
            {
                id = "c4_cut_purple",
                event = "bbv-bombs:cut:purple",
                icon = "fas fa-cut",
                label = "Cut purple wire",
            },
            {
                id = "c4_cut_white",
                event = "bbv-bombs:cut:white",
                icon = "fas fa-cut",
                label = "Cut white wire",
            },
        }
    })
    end
    if Config.Settings.Target == "BT" then 
        local _id = id
        exports["bt-target"]:AddBoxZone(_id, vector3(pos.x,pos.y,pos.z), 0.4, 0.6, {
            name=_id,
            heading=91,
            minZ = pos.z - 1,
            maxZ = pos.z + 1
            }, {
                options = {
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:checkTime",
                        icon = "stopwatch",
                        label = "Check remaining time",
                    },
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:cut",
                        icon = "cut",
                        label = "Cut red wire",
                    },
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:cut",
                        icon = "cut",
                        label = "Cut green wire",
                    },
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:cut",
                        icon = "cut",
                        label = "Cut blue wire",
                    },
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:cut",
                        icon = "cut",
                        label = "Cut yellow wire",
                    },
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:cut",
                        icon = "cut",
                        label = "Cut purple wire",
                    },
                    {
                        type = "client",
                        event = "np-miscscripts:bombs:cut",
                        icon = "cut",
                        label = "Cut white wire",
                    },
                },
                distance = 1.5
            })
    end
end

function Wrapper:TargetRemove(sendid) -- Remove QBTarget target
    if Config.Settings.Target == "QB" then 
    exports["qb-target"]:RemoveZone(sendid)
    end 
    if Config.Settings.Target == "OX" then 
        exports["ox_target"]:removeZone(Wrapper.zone[sendid])
    end
    if Config.Settings.Target == "BT" then 
        exports["bt-taget"]:RemoveZone(sendid)
    end
end


function Wrapper:Notify(txt,tp,time) -- QBCore notify
    if Config.Settings.Framework == "QB" then 
    QBCore.Functions.Notify(txt, tp, time)
    end
    if Config.Settings.Framework == "ESX" then 
        ESX.ShowNotification(txt)
    end
    if Config.Settings.Framework == "ST" then 
        SetNotificationTextEntry('STRING')
        AddTextComponentString(txt)
        DrawNotification(0,1)    
    end
end

RegisterCommand('check2',function()
    for k,v in pairs(Wrapper.object) do 
        --print(v)
    end
end)

function Wrapper:Drawtxt(x,y,txt)
    --print(x,y,txt .. ' txt')
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawText(x,y)
end

function Wrapper:RemoveItem(item,amount)
    if item == nil then 
        return 
    end
    TriggerServerEvent("Wrapper:bomb:RemoveItem", item, amount)
end


function Wrapper:Log(txt) -- Log all of your abusive staff
    TriggerServerEvent("Wrapper:bomb:Log",txt)
end


AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(Wrapper.cars) do 
        DeleteVehicle(v)
    end
    for k,v in pairs(Wrapper.object) do 
        DeleteObject(v)
    end
end)
