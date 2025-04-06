ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('esx:playerLoaded', function(playerId)
    TriggerClientEvent('esx_safezones:sync', playerId)
end)

AddEventHandler('entityDamaged', function(victim, attacker, damage, weapon)
    if not IsEntityAPed(victim) then return end
    
    local victimPed = victim
    local victimCoords = GetEntityCoords(victimPed)
    local inSafezone = false
    
    for _, zone in pairs(Config.Safezones) do
        if #(vector2(victimCoords.x, victimCoords.y) - vector2(zone.coords.x, zone.coords.y)) <= zone.radius then
            inSafezone = true
            break
        end
    end
    
    if inSafezone then
        CancelEvent()
    end
    
    if IsEntityAPed(attacker) then
        local attackerCoords = GetEntityCoords(attacker)
        local attackerInSafezone = false
        
        for _, zone in pairs(Config.Safezones) do
            if #(vector2(attackerCoords.x, attackerCoords.y) - vector2(zone.coords.x, zone.coords.y)) <= zone.radius then
                attackerInSafezone = true
                break
            end
        end
        
        if inSafezone and not attackerInSafezone then
            CancelEvent()
        end
    end
end)