AddEventHandler("gameEventTriggered", function(eventName, args)
    if eventName ~= "CEventNetworkEntityDamage" then
        return
    end

    local victim = args[1]
    local culprit = args[2]
    local isDead = args[4] == 1

    if not isDead or not DoesEntityExist(victim) then
        return
    end

    local coords = GetEntityCoords(victim)
    local netId = PedToNet(victim)

    -- Crea il pickup a terra
    local pickup = CreatePickupRotate(`PICKUP_MONEY_VARIABLE`, coords.x, coords.y, coords.z - 0.7, 0.0, 0.0, 0.0, 512, 0,
    false, 0)

    -- Flag per terminare i thread
    local pickupHandled = false

    -- Thread che controlla se il pickup è stato raccolto
    CreateThread(function()
        local playerPed = PlayerPedId()
        while not pickupHandled do
            Wait(100)

            if #(GetEntityCoords(playerPed) - coords) < 2.5 and HasPickupBeenCollected(pickup) then
                TriggerServerEvent("money:tryPickup", netId)
                RemovePickup(pickup)
                pickupHandled = true
            end
        end
    end)

    -- Timeout di 15 secondi per rimuovere il pickup se non raccolto
    SetTimeout(15000, function()
        if not pickupHandled then
            RemovePickup(pickup)
            pickupHandled = true
        end
    end)

    -- Salva la posizione sul server per verifica futura
    TriggerServerEvent("money:allowPickupNear", netId)
end)
