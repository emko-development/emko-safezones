ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local inSafezone = false

        for _, zone in pairs(Config.Safezones) do
            local distance2D = #(vector2(playerCoords.x, playerCoords.y) - vector2(zone.coords.x, zone.coords.y))

            if distance2D <= zone.radius then
                inSafezone = true
            end

            if distance2D <= zone.radius + 100.0 then
                DrawSafezoneOutline(zone.coords, zone.radius)
            end
        end

        if inSafezone then
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            SetPlayerCanDoDriveBy(PlayerId(), false)
        else
            EnableControlAction(0, 24, true)
            EnableControlAction(0, 25, true)
            EnableControlAction(0, 140, true)
            EnableControlAction(0, 141, true)
            EnableControlAction(0, 142, true)
            SetPlayerCanDoDriveBy(PlayerId(), true)
        end

        Citizen.Wait(0)
    end
end)

function DrawSafezoneOutline(coords, radius)
    local height = 3.5
    DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, radius * 2.0, radius * 2.0, height, 0, 153, 255, 120, false, false, 2, true, nil, nil, false)
end

Citizen.CreateThread(function()
    local inZone = false
    local lastZone = nil

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInAnyZone = false

        for _, zone in pairs(Config.Safezones) do
            local distance2D = #(vector2(playerCoords.x, playerCoords.y) - vector2(zone.coords.x, zone.coords.y))
            if distance2D <= zone.radius then
                isInAnyZone = true
                if not inZone or lastZone ~= zone.name then
                    inZone = true
                    lastZone = zone.name
                end
                break
            end
        end

        if not isInAnyZone and inZone then
            inZone = false
            lastZone = nil
        end

        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local inSafezone = false

        for _, zone in pairs(Config.Safezones) do
            if #(vector2(playerCoords.x, playerCoords.y) - vector2(zone.coords.x, zone.coords.y)) <= zone.radius then
                inSafezone = true
                break
            end
        end

        if inSafezone then
            SetEntityInvincible(playerPed, true)
        else
            SetEntityInvincible(playerPed, false)
        end

        Citizen.Wait(0)
    end
end)
