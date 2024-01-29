-- Credit : pushkart2
-- Minigame from : https://github.com/pushkart2/memorygame


local successCb
local failCb
local resultReceived = false

RegisterNUICallback('ThermiteResult', function(data, cb)
    SetNuiFocus(false, false)
    resultReceived = true
    if data.success then
        successCb()
    else
        failCb()
    end
    cb('ok')
end)



exports('thermiteminigame', function(correctBlocks, incorrectBlocks, timetoShow, timetoLose, success, fail)
    resultReceived = false
    successCb = success
    failCb = fail
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "Start",
        correct = correctBlocks,
        incorrect = incorrectBlocks,
        showtime = timetoShow,
        losetime = timetoLose + timetoShow,
    })
end)
