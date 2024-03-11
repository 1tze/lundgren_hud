RegisterNUICallback('ready', function(data, callback)
    if data.show then 
        Wait(500)
        SendNUIMessage({
            action = 'show'
        })
        isHudVisible = true
    end
end)

local lastValues = {
    health = -1,
    armour = -1,
    food = -1,
    water = -1,
    fuel = -1,
    speed = -1,
    isPaused = false
}

if not Config.ESX then
    RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
        food = newHunger
        water = newThirst
    end)
end

Citizen.CreateThread(function()
    while true do
        if isHudVisible then
            local isPaused = IsPauseMenuActive()
            if isPaused ~= lastValues.isPaused then
                SendNUIMessage({action = 'hide', opacity = isPaused and 0 or 1})
                lastValues.isPaused = isPaused
            end

            local player = PlayerPedId()
            local health = math.max(GetEntityHealth(player) - 100, 0)
            local armour = GetPedArmour(player)

            if Config.ESX then
                TriggerEvent('esx_status:getStatus', 'hunger', function(status) food = status.val / 10000 end)
                TriggerEvent('esx_status:getStatus', 'thirst', function(status) water = status.val / 10000 end)
            end

            SendIfChanged('health', health, lastValues.health)
            SendIfChanged('armour', armour, lastValues.armour)
            SendIfChanged('food', food, lastValues.food)
            SendIfChanged('water', water, lastValues.water)
        end
        Citizen.Wait(1000)
    end
end)

function SendIfChanged(action, value, lastValue)
    if value ~= lastValue then
        SendNUIMessage({action = action, [action] = value})
        lastValues[action] = value
    end
end