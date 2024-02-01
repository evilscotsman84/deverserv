local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Functions.CreateCallback('qb-spawn:server:getOwnedHouses', function(source, cb, cid)
    if cid ~= nil then
        local houses = exports.oxmysql:executeSync("SELECT * FROM player_houses WHERE identifier = ? OR JSON_CONTAINS(keyholders, JSON_ARRAY(?))", {cid, cid})
        if houses[1] ~= nil then
            cb(houses)
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)

RegisterNetEvent("orangutan:spawn:getHouseCoords", function(houseName)
    local src = source
    if houseName then
        local house = exports.oxmysql:executeSync("SELECT * FROM houselocations WHERE name = ?", {houseName})
        if house[1] then
            local ped = GetPlayerPed(src)
            local data = json.decode(house[1].coords)
            local x, y, z = data.enter.x, data.enter.y, data.enter.z
            -- print(x, y, z)
            SetEntityCoords(ped, x, y, z, false, false, false, true)
        end
    end
end)

QBCore.Commands.Add("addloc", "Add location for spawn (God Only)", {}, false, function(source)
    local src = source
    TriggerClientEvent('qb-spawn:client:OpenUIForSelectCoord', src)
end, "god")
