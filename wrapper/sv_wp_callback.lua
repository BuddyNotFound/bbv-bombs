Wrapper.CreateCallback = function(name, cb)
    Wrapper.ServerCallbacks[name] = cb
end

Wrapper.TriggerCallback = function(name, source, cb, ...)
    if Wrapper.ServerCallbacks[name] ~= nil then
        Wrapper.ServerCallbacks[name](source, cb, ...)
    end
end

RegisterNetEvent('Wrapper:Server:TriggerCallback', function(name, ...)
    local src = source
    Wrapper.TriggerCallback(name, src, function(...)
        TriggerClientEvent('Wrapper:Client:TriggerCallback', src, name, ...)
    end, ...)
end)