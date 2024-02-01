local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('evil-atmrob:reward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local random = math.random(3000, 4000)
    Player.Functions.AddMoney('cash', random)
end)


RegisterServerEvent("evil-atmrob:clrspawn")
AddEventHandler("evil-atmrob:clrspawn", function()
    TriggerClientEvent("evil-atmrob:clrspawn", -1)
end)

RegisterServerEvent("evil-atmrob:attro1")
AddEventHandler("evil-atmrob:attro1", function(pr1, pr2)
    TriggerClientEvent("evil-atmrob:attro1", -1, pr1, pr2)
end)

RegisterServerEvent("evil-atmrob:attro2")
AddEventHandler("evil-atmrob:attro2", function(dpratm, atmco1, atmco2, atmco3, netveh, propsdad)
    TriggerClientEvent("evil-atmrob:attro2", -1, dpratm, atmco1, atmco2, atmco3, netveh, propsdad)
end)

RegisterServerEvent("evil-atmrob:propas")
AddEventHandler("evil-atmrob:propas", function(psa)
    TriggerClientEvent("evil-atmrob:propas", -1, psa)
end)

RegisterServerEvent("evil-atmrob:deles")
AddEventHandler("evil-atmrob:deles", function(sda)
    TriggerClientEvent("evil-atmrob:deles", -1, sda)
end)

RegisterServerEvent("evil-atmrob:delesr")
AddEventHandler("evil-atmrob:delesr", function(rope)
    TriggerClientEvent("evil-atmrob:delesr", -1, rope)
end)

QBCore.Functions.CreateUseableItem(RHO.RopeItemName, function(source)
    TriggerClientEvent("evil-atmrob:policecheck", source)
end)

