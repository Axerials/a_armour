RegisterNetEvent('a_armour:setArmour')
AddEventHandler('a_armour:setArmour', function(amount)
    SetPedArmour(PlayerPedId(), amount)
end)

RegisterNetEvent('a_armour:capArmour')
AddEventHandler('a_armour:capArmour', function(maxAllowed)
    local ped = PlayerPedId()
    if GetPedArmour(ped) > maxAllowed then
        SetPedArmour(ped, maxAllowed)
        lib.notify({
            title = 'Armour',
            description = ('Your armour was reduced to %s for your job.'):format(maxAllowed),
            type = 'inform',
        })
    end
end)
