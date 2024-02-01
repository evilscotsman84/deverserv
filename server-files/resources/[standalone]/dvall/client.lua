local QBCore = exports['qb-core']:GetCoreObject()
local dvall = false

RegisterNetEvent('dvallevent')
  AddEventHandler("dvallevent", function ()
    if dvall then return QBCore.Functions.Notify('There Is Already Dvall In Progress', 'error') end
  SetDisplayDvAll(true)
  dvall = true
  Wait((Config.commandTimerM*1000*60)+(Config.commandTimerS*1000)+2000)
  TriggerEvent("of:delallveh")
  TriggerEvent("clearArea:CleanUp")
  dvall = false
end)


RegisterNetEvent("of:delallveh")
AddEventHandler("of:delallveh", function()
  for vehicle in EnumerateVehicles() do
    if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
      local vehicleModel = GetEntityModel(vehicle)
      local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)

      if vehicleName ~= "STOCKADE" then
        SetVehicleHasBeenOwnedByPlayer(vehicle, false)
        SetEntityAsMissionEntity(vehicle, false, false)
        DeleteVehicle(vehicle)
      end
    end
  end
end)

-- RegisterNetEvent("of:delallveh")
-- AddEventHandler("of:delallveh", function ()
--     for vehicle in EnumerateVehicles() do
--         if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) or not GetVehicleDoorLockStatus(vehicle) == 2 then 
--             SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
--             SetEntityAsMissionEntity(vehicle, false, false) 
--             local plate = GetVehicleNumberPlateText(vehicle)
--             TriggerServerEvent("dvall:server:server",plate)
--             DeleteVehicle(vehicle)
--             if (DoesEntityExist(vehicle)) then 
--                 DeleteVehicle(vehicle) 
--             end
--         end
--     end
-- end)

RegisterNetEvent('clearArea:CleanUp')
AddEventHandler('clearArea:CleanUp', function(entities)
      local deadPeds = {}
      for ped in EnumeratePeds() do
          if IsEntityDead(ped) then
              table.insert(deadPeds, ped)
          end
      end
    --TriggerServerEvent("clearArea:deletepedsClient", deadPeds)
end)

RegisterNetEvent('clearArea:deletepedsServer')
AddEventHandler('clearArea:deletepedsServer', function(entities)
  for i, entity in pairs(entities) do
    SetEntityAsNoLongerNeeded(entity)
    DeleteEntity(entity)
  end
end)

local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
  }
  
  local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
      local iter, id = initFunc()
      if not id or id == 0 then
        disposeFunc(iter)
        return
      end
      
      local enum = {handle = iter, destructor = disposeFunc}
      setmetatable(enum, entityEnumerator)
      
      local next = true
      repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
      until not next
      
      enum.destructor, enum.handle = nil, nil
      disposeFunc(iter)
    end)
  end
  
  function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
  end
  
  function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
  end
  
  function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
  end
  
  function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
  end
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

function SetDisplayDvAll(bool)
    SendNUIMessage({
        type = "changeTime",
        status = bool,
        minutes=Config.commandTimerM,
        seconds= Config.commandTimerS
    })
end

function SetDisplayci(bool)
    SendNUIMessage({
        type = "changeTime",
        status = bool,
        minutes=Config.cooldownAlertM,
        seconds= Config.cooldownAlertS
    })
end


