local gsrTimer = 0
local gsrPositive = false
local plyPed = PlayerPedId()
local gsrTestDistance = 5

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        GSRThread()
    end
end)

exports.ox_target:addGlobalPlayer({
    {
        icon = 'fa-solid fa-gun',
        label = 'Test GSR',
        groups = Config.Jobs,  -- Put your jobs here
        canInteract = function(entity, distance, coords, name)
            return distance < 1.5
        end,
        items = {Config.Item}, -- This is the item you need to use the target on the player if you don't have it no GSR
        onSelect = function(data)
            local playerCoords = GetEntityCoords(plyPed)
            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                local targetId = GetPlayerServerId(player)
                local distance = #(playerCoords - GetEntityCoords(targetPed))
                if targetPed ~= plyPed then
                    if distance <= gsrTestDistance then
                        print('Player ID: ' .. targetId) -- You can remove this line if you don't want to see the player ID in the console
                        TriggerServerEvent('lsc_gsr:TestPlayer', targetId)
                    else
                        lib.notify({
                            title = 'Error',
                            description = 'The target is too far', -- Error message when the target is too far
                            type = 'error'
                        })
                    end
                end
            end
        end
    }
})

RegisterNetEvent("lsc_gsr:TestNotify")
AddEventHandler("lsc_gsr:TestNotify", function(message)
    lib.notify({
        title = 'Notification GSR',
        description = message,
        type = 'inform'
    })
end)

RegisterNetEvent("lsc_gsr:TestHandler")
AddEventHandler("lsc_gsr:TestHandler", function(tester)
    if gsrPositive then
        TriggerServerEvent("lsc_gsr:TestCallback", tester, true)
    elseif not gsrPositive then
        TriggerServerEvent("lsc_gsr:TestCallback", tester, false)
    end
end)

function GSRThread()
    plyPed = PlayerPedId()
    if IsPedShooting(plyPed) then
        if gsrPositive then
            gsrTimer = Config.GSRAutoClean
        else
            gsrPositive = true
            gsrTimer = 3600  -- 10 seconds 
            Citizen.CreateThread(GSRThreadTimer)
        end
    end
end


function GSRThreadTimer()
    while gsrPositive do
        Citizen.Wait(1000)
        if gsrTimer == 0 then
            gsrPositive = false
        else
            gsrTimer = gsrTimer - 1
        end
    end
end

function Notify(text)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {'GSR', text}
    })      
end
