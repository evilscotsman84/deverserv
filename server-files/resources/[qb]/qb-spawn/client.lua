local QBCore = exports['qb-core']:GetCoreObject()
local camZPlus1 = 1500
local camZPlus2 = 50
local pointCamCoords = 75
local pointCamCoords2 = 0
local cam1Time = 500
local cam2Time = 1000
local choosingSpawn = false
local Houses = {}
local cam = nil
local cam2 = nil

-- Functions

local function SetDisplay(bool)
    -- If the player should be in prison
	QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] > 0 then
            print("Sending back to jail")
			TriggerEvent("prison:client:Enter", PlayerData.metadata["injail"])
            return
		end
	end)

    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

-- Events

RegisterNetEvent('qb-spawn:client:openUI', function(value)
    SetEntityVisible(PlayerPedId(), false)
    DoScreenFadeOut(250)
    Wait(1000)
    DoScreenFadeIn(250)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus1, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end)
    Wait(500)
    SetDisplay(value)
end)

-- RegisterNetEvent('qb-houses:client:setHouseConfig', function(houseConfig)
--     Houses = houseConfig
-- end)

RegisterNetEvent('qb-spawn:client:setupSpawns', function(cData, new, apps)
    if not new then
        QBCore.Functions.TriggerCallback('qb-spawn:server:getOwnedHouses', function(houses)
            local myHouses = {}
            if houses ~= nil then
                for i = 1, (#houses), 1 do
                    myHouses[#myHouses+1] = {
                        house = houses[i].house,
                        -- label = houses[i].house,
                    }
                end
            end
            Wait(400)
            local Apartment = nil
            local ApartmentName = nil
            QBCore.Functions.TriggerCallback('apartments:GetOwnedApartment', function(result)
                Apartment = Apartments.Locations[result.type]  
                ApartmentName = result.name
            end)
            Wait(400)
            SendNUIMessage({
                action = "setupLocations",
                locations = QB.Spawns,
                houses = myHouses,
                Apartment = Apartment,
                ApartmentNames = ApartmentName,
                Access = QB.SpawnAccess,
            })
        end, cData.citizenid)
    elseif new then
        SendNUIMessage({
            action = "setupAppartements",
            locations = apps,
        })
    end
end)

-- NUI Callbacks


local cam = nil
local cam2 = nil

local function SetCam(campos)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
    SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end
    Wait(cam1Time)

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
    PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
    SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
    SetEntityCoords(PlayerPedId(), campos.x, campos.y, campos.z)
end

RegisterNUICallback('setCam', function(data, cb)
    local location = tostring(data.posname)
    local type = tostring(data.type)

    DoScreenFadeOut(200)
    Wait(500)
    DoScreenFadeIn(200)

    if DoesCamExist(cam) then DestroyCam(cam, true) end
    if DoesCamExist(cam2) then DestroyCam(cam2, true) end

    if type == "current" then
        QBCore.Functions.GetPlayerData(function(PlayerData)
            SetCam(PlayerData.position)
        end)
    -- elseif type == "house" then
    --     SetCam(Houses[location].coords.enter)
    elseif type == "normal" then
        SetCam(QB.Spawns[location].coords)
    elseif type == "appartment" then
        SetCam(Apartments.Locations[location].coords.enter)
    end
    cb('ok')
end)

RegisterNUICallback('chooseAppa', function(data, cb)
    local ped = PlayerPedId()
    local appaYeet = data.appType
    print('spawnplayer', appaYeet)
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(5000)
    TriggerServerEvent("apartments:server:CreateApartment", appaYeet, Apartments.Locations[appaYeet].label)
    print("check changes")
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(ped, true)
    cb('ok')
    Wait(1000)
    TriggerServerEvent("clothing:checkIfNew")
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end)

local function PreSpawnPlayer()
    SetDisplay(false)
    DoScreenFadeOut(500)
    Wait(2000)
end

local function PostSpawnPlayer(ped)
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(PlayerPedId(), true)
    TriggerServerEvent("clothing:checkIfNew")
    Wait(3000)
    DoScreenFadeIn(500)
end

RegisterNUICallback('spawnplayerappartment2', function(data, cb)
    print('spawnplayer2', appaYeet)
    PreSpawnPlayer()
    local Data = data.spawnloc
    local Data2 = data.apartName
    -- TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    TriggerEvent('qb-apartments:client:LastLocationHouse', Data, Data2)
    TriggerServerEvent("clothing:checkIfNew")
    PostSpawnPlayer()
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    cb('ok')
end)

RegisterNUICallback('spawnplayer', function(data, cb)
    local location = tostring(data.spawnloc)
    local type = tostring(data.typeLoc)
    local ped = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local insideMeta = PlayerData.metadata["inside"]
    print(tostring(data.typeLoc), location)
    if type == "current" then
        PreSpawnPlayer()
        QBCore.Functions.GetPlayerData(function(pd)
            ped = PlayerPedId()
            SetEntityCoords(ped, pd.position.x, pd.position.y, pd.position.z)
            SetEntityHeading(ped, pd.position.a)
            FreezeEntityPosition(ped, false)
        end)

        if insideMeta.house ~= nil then
            local houseId = insideMeta.house
            -- TriggerEvent('qb-houses:client:LastLocationHouse', houseId)
        elseif insideMeta.apartment.apartmentType ~= nil or insideMeta.apartment.apartmentId ~= nil then
            local apartmentType = insideMeta.apartment.apartmentType
            local apartmentId = insideMeta.apartment.apartmentId
            TriggerEvent('qb-apartments:client:LastLocationHouse', apartmentType, apartmentId)
        end

        PostSpawnPlayer()
        TriggerServerEvent("clothing:checkIfNew")

    elseif type == "house" then
        PreSpawnPlayer()
        TriggerServerEvent("orangutan:spawn:getHouseCoords", location)
        -- TriggerEvent('qb-houses:client:enterOwnedHouse', location)
        -- TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
        PostSpawnPlayer()
    elseif type == "normal" then
        local pos = QB.Spawns[location].coords
        PreSpawnPlayer()
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        -- TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
        Wait(500)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.w)
        PostSpawnPlayer()
    end
    TriggerServerEvent("clothing:checkIfNew")
    TriggerEvent("hospital:client:Revive")
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    cb('ok')
end)

RegisterNetEvent('qb-spawn:client:OpenUIForSelectCoord', function()
    local PlayerCoord = GetEntityCoords(PlayerPedId(), 1)
    local PlayerHeading = GetEntityHeading(PlayerPedId())
    SendNUIMessage({
        action = "AddCoord",
        Coord = {x = PlayerCoord[1], y = PlayerCoord[2], z = PlayerCoord[3], h = PlayerHeading},
            
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('CloseAddCoord', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Threads

CreateThread(function()
    while true do
        Wait(0)
        if choosingSpawn then
            DisableAllControlActions(0)
        else
            Wait(1000)
        end
    end
end)
