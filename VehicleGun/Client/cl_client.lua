RegisterCommand("vehiclegun", function(source, args, rawCommand)
    vehicleGun = not vehicleGun
    print("Vehicle Gun has been toggled")
end, false)


Citizen.CreateThread(function()
    local playerPed = PlayerPedId()

    while true do
        Citizen.Wait(0)
        if IsPedShooting(playerPed) and vehicleGun then
            isWeaponFired = true
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isWeaponFired then
            isWeaponFired = false

            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)

            local rot = GetGameplayCamRot(2)
            local heading = math.rad(rot.z)
            local pitch = math.rad(rot.x)

            local forwardVector = vector3(-math.sin(heading) * math.cos(pitch), math.cos(heading) * math.cos(pitch), math.sin(pitch))

            local spawnPos = vector3(pos.x + forwardVector.x * 10, pos.y + forwardVector.y * 10, pos.z + forwardVector.z * 10)

            local vehicleHash = GetHashKey(Config.Vehicle)

            RequestModel(vehicleHash)

            while not HasModelLoaded(vehicleHash) do
                Wait(500)
            end

            local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, false)

            local forceMultiplier = 50000.0
            ApplyForceToEntity(vehicle, 1, forwardVector.x * forceMultiplier, forwardVector.y * forceMultiplier, forwardVector.z * forceMultiplier, 0.0, 0.0, 0.0, false, false, true, true, false, true)
        end
    end
end)

