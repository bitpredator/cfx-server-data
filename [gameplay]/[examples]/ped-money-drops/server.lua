local safePositions = {}

-- Quando un'entità viene uccisa, salviamo la sua posizione per un possibile pickup
RegisterNetEvent("money:allowPickupNear", function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then
        return
    end

    -- Ritardo per evitare race condition
    Wait(250)

    if not DoesEntityExist(entity) then
        return
    end
    if GetEntityHealth(entity) > 100 then
        return
    end

    safePositions[netId] = GetEntityCoords(entity)
end)

-- Quando un giocatore cerca di raccogliere il denaro
RegisterNetEvent("money:tryPickup", function(netId)
    local source = source
    local pedCoords = GetEntityCoords(GetPlayerPed(source))
    local dropCoords = safePositions[netId]

    if not dropCoords then
        return
    end

    -- Verifica distanza prima di dare il denaro
    if #(dropCoords - pedCoords) < 2.5 then
        local success = exports["money"]:addMoney(source, "cash", 40)
        if success then
            safePositions[netId] = nil
        end
    end
end)

-- Pulizia della cache se un'entità viene rimossa
AddEventHandler("entityRemoved", function(entity)
    for netId, _ in pairs(safePositions) do
        local ent = NetworkGetEntityFromNetworkId(netId)
        if ent == entity then
            safePositions[netId] = nil
            break
        end
    end
end)
