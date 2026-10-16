ESX = exports['es_extended']:getSharedObject()
local function GetMaxArmourForJob(jobName)
    return Config.JobArmourLimits[jobName] or Config.DefaultMaxArmour
end
local function NotifyPlayer(source, message, notifyType)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Armour',
        description = message,
        type = notifyType or 'inform',
    })
end
local function TryGiveArmour(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local maxAllowed = GetMaxArmourForJob(xPlayer.job.name)
    local finalAmount = math.min(amount, maxAllowed)

    TriggerClientEvent('a_armour:setArmour', source, finalAmount)

    if finalAmount < amount then
        NotifyPlayer(source, ('Your job only allows up to %s armour.'):format(finalAmount), 'error')
    else
        NotifyPlayer(source, ('Armour set to %s.'):format(finalAmount), 'success')
    end
end
exports('TryGiveArmour', TryGiveArmour)
RegisterNetEvent('a_armour:buyArmour')
AddEventHandler('a_armour:buyArmour', function(amount)
    local source = source
    TryGiveArmour(source, amount)
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(source, job)
    SetTimeout(500, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        local maxAllowed = GetMaxArmourForJob(xPlayer.job.name)
        TriggerClientEvent('a_armour:capArmour', source, maxAllowed)
    end)
end)
if Config.EnforceInterval and Config.EnforceInterval > 0 then
    CreateThread(function()
        while true do
            Wait(Config.EnforceInterval)
            local players = ESX.GetPlayers()
            for _, playerId in pairs(players) do
                local xPlayer = ESX.GetPlayerFromId(playerId)
                if xPlayer then
                    local maxAllowed = GetMaxArmourForJob(xPlayer.job.name)
                    TriggerClientEvent('a_armour:capArmour', playerId, maxAllowed)
                end
            end
        end
    end)
end
