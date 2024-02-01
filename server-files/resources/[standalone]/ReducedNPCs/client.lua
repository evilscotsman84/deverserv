Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- prevent crashing

		-- These natives have to be called every frame.
		SetVehicleDensityMultiplierThisFrame(0.2) -- set traffic density to 0 
		SetRandomVehicleDensityMultiplierThisFrame(0.6) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
		SetParkedVehicleDensityMultiplierThisFrame(0.3) -- set random parked vehicles (parked car scenarios) to 0
		SetPedDensityMultiplierThisFrame(0.9)
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(true) -- Stop random boats from spawning in the waer.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
	
	end
end)