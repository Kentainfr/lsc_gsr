RegisterNetEvent("lsc_gsr:TestPlayer")
AddEventHandler("lsc_gsr:TestPlayer", function(tested)
    TriggerClientEvent("lsc_gsr:TestHandler", tested, source)
    TriggerClientEvent("lsc_gsr:TestNotify", tested, Config.GSRTest .. GetPlayerName(source)) -- Getting tested notification
end)

RegisterNetEvent("lsc_gsr:TestCallback")
AddEventHandler("lsc_gsr:TestCallback", function(tester, result)
    if result then
        TriggerClientEvent("lsc_gsr:TestNotify", tester, Config.PositiveGSR) 
    else
        TriggerClientEvent("lsc_gsr:TestNotify", tester, Config.NegativeGSR)
    end
end)
