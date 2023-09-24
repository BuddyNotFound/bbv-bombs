RegisterNetEvent('Wrapper:Client:TriggerCallback', function(name, ...)
    if Wrapper.ServerCallbacks[name] ~= nil then
        Wrapper.ServerCallbacks[name](...)
        Wrapper.ServerCallbacks[name] = nil
    end
end)

Wrapper.TriggerCallback = function(name, cb, ...)
    Wrapper.ServerCallbacks[name] = cb
    TriggerServerEvent("Wrapper:Server:TriggerCallback", name, ...)
end