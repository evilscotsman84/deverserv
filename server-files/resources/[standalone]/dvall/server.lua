
local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('dvall', 'Delete All Vehicles', {}, false, function(source, args)
    TriggerClientEvent("dvallevent", -1)
end, 'admin')