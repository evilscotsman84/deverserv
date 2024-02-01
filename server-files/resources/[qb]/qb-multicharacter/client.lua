local loadScreenCheckState = false

local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb:Multicharacter')
			return
		end
	end
end)

local function DisableHudIcons()
    TriggerEvent('qb-hud:client:ToggleBugMode', false)
    TriggerEvent('qb-hud:client:ToggleDevMode', false) 
    TriggerEvent('qb-hud:client:ToggleWeaponMode', false) 
    TriggerEvent('qb-hud:client:ToggleDrunkMode', false) 
end

RegisterNetEvent('qb:Multicharacter', function()
    local ped = PlayerPedId()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    ShutdownLoadingScreen() 
    ShutdownLoadingScreenNui()
    DoScreenFadeOut(1)
    SetEntityCoords(ped, Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
    FreezeEntityPosition(ped, true)
    Wait(3000)
    DoScreenFadeIn(3000)
    SetDisplay()
    SetEntityInvincible(PlayerPedId(), true)
    TriggerEvent('qb_open:multicharacter')
end)

function SetDisplay()
    SetNuiFocus(true, true)
    SendNUIMessage({
        open = true
    })
end

local getSpawnLocation = nil
local getCamPos = nil
local GethiddenCoords = nil

local function cameraPov()
    getSpawnLocation = Config.SpawnLocation
    getCamPos = Config.Camera
    GethiddenCoords = Config.HiddenCoords

    FreezeEntityPosition(GetPlayerPed(-1), false)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1)

    SetCamCoord(cam, getCamPos.x, getCamPos.y, getCamPos.z + 0.2)
	SetCamRot(cam, 5.0, 0.0, 47.0)
    SetCamFov(cam, 22.0)

    SetEntityCoords(PlayerPedId(), GethiddenCoords.x, GethiddenCoords.y, GethiddenCoords.z)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, 0.4)
    SetCamFarDof(cam, 1.3)
    SetCamDofStrength(cam, 0.80)

    SetCamActive(cam, true)
    RenderScriptCams(true,  false,  0,  true,  true)

    while DoesCamExist(cam) do
        SetUseHiDof()
        Citizen.Wait(0)
    end
end

RegisterNetEvent('qb_open:multicharacter', function()
    cameraPov()   
end)

RegisterNUICallback('getCharacterbyCid', function(data, cb)
    QBCore.Functions.TriggerCallback('qb:Multicharacter_setupcharacter', function(result)
        cb(result)
    end, data.number)
end)

RegisterNUICallback('cDataPed', function(data)
    QBCore.Functions.TriggerCallback('qb_Getskin', function(model, data)
        if model == nil then
            Citizen.CreateThread(function()
                local randommodels = {
                    "np_m_character_select",
                    "np_f_character_select",
                }
                DeleteEntity(charPed)
                local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(0)
                end

                charPed  = CreatePed(1, model, Config.SpawnLocation.x, Config.SpawnLocation.y, Config.SpawnLocation.z - 0.98, Config.SpawnLocation.w, false, true)
                SetPedComponentVariation(charPed, 0, 0, 0, 2)
                SetBlockingOfNonTemporaryEvents(charPed, true) 
                SetPedDiesWhenInjured(charPed, false) 
                SetPedCanPlayAmbientAnims(charPed, true) 
                SetPedCanRagdollFromPlayerImpact(charPed, false) 
                SetEntityInvincible(charPed, true)    
                FreezeEntityPosition(charPed, true) 
                SetEntityAlpha(charPed,0.99,false)
            end)
        else
            model = model ~= nil and tonumber(model) or false
            Citizen.CreateThread(function()
                RequestModel(model)
                DeleteEntity(charPed)
                while not HasModelLoaded(model) do
                    Wait(0)
                end

                charPed  = CreatePed(1, model, Config.SpawnLocation.x, Config.SpawnLocation.y, Config.SpawnLocation.z - 0.98, Config.SpawnLocation.w, false, true)
                local  RandomAnimins = {     
                    "WORLD_HUMAN_PARTYING",
                    "WORLD_HUMAN_STAND_MOBILE",
                    "WORLD_HUMAN_SMOKING_POT",
                    "WORLD_HUMAN_MUSCLE_FLEX"
                }
                local PlayAnimin = RandomAnimins[math.random(#RandomAnimins)] 
                SetPedCanPlayAmbientAnims(charPed, true)
                TaskStartScenarioInPlace(charPed, PlayAnimin, 0, true)
                SetPedComponentVariation(charPed, 0, 0, 0, 2)
                SetBlockingOfNonTemporaryEvents(charPed, true) 
                SetPedDiesWhenInjured(charPed, false) 
                SetPedCanPlayAmbientAnims(charPed, true) 
                SetPedCanRagdollFromPlayerImpact(charPed, false) 
                SetEntityInvincible(charPed, true)    
                FreezeEntityPosition(charPed, true) 
                data = json.decode(data)
                TriggerEvent('illenium-appearance:client:loadPlayerClothing', data, charPed)
            end)
        end
    end, data.citizenid)
end)

RegisterNUICallback('createNewCharacter', function(data)
    SetNuiFocus(false, false)
    DoScreenFadeOut(150)
    if data.gender == "male" then
        data.gender = 0
    elseif data.gender == "female" then
        data.gender = 1
    end
    TriggerServerEvent('qb_createCharacter', data)
    Wait(500)
end)

RegisterNUICallback('removeCharacter', function(data)
    TriggerServerEvent('qb_removeCharacter', data.citizenid)
    DeleteEntity(charPed)
end)

RegisterNUICallback('selectCharacter', function(data)
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb_Loaduserdata', data)
end)