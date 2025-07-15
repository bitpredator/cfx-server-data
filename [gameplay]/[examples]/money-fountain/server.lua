-- Global registry for sent state to prevent duplicate syncs
local sentState = {}

-- Money system export
local moneySystem = exports["money"]

-- Recupera la quantità di denaro in una fontana
local function getMoneyForFountain(fountainId)
    return GetResourceKvpInt(("money:%s"):format(fountainId)) / 100.0
end

-- Imposta la quantità di denaro in una fontana e aggiorna GlobalState
local function setMoneyForFountain(fountainId, amount)
    local intAmount = math.tointeger(amount * 100.0)
    GlobalState["fountain_" .. fountainId] = intAmount
    return SetResourceKvpInt(("money:%s"):format(fountainId), intAmount)
end

-- Trova una fontana vicina a un giocatore specifico
local function getNearbyFountain(fountainId, source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    for _, fountain in pairs(moneyFountains) do
        if fountain.id == fountainId and #(fountain.coords - playerCoords) < 2.5 then
            return fountain
        end
    end

    return nil
end

-- Funzione generica per raccogliere o depositare denaro nella fontana
local function processFountainInteraction(source, fountainId, isPickup)
    local fountain = getNearbyFountain(fountainId, source)
    if not fountain then
        return
    end

    local player = Player(source)
    local cooldown = player.state["fountain_nextUse"] or 0
    local currentTime = GetGameTimer()

    if cooldown > currentTime then
        return
    end

    local fountainMoney = getMoneyForFountain(fountain.id)
    local amount = fountain.amount
    local success = false

    if isPickup then
        if fountainMoney >= amount then
            success = moneySystem:addMoney(source, "cash", amount)
            if success then
                fountainMoney -= amount
            end
        end
    else
        success = moneySystem:removeMoney(source, "cash", amount)
        if success then
            fountainMoney += amount
        end
    end

    if success then
        setMoneyForFountain(fountain.id, fountainMoney)
        player.state["fountain_nextUse"] = currentTime + GetConvarInt("moneyFountain_cooldown", 5000)
    end
end

-- Evento: preleva denaro dalla fontana
RegisterNetEvent("money_fountain:tryPickup", function(fountainId)
    processFountainInteraction(source, fountainId, true)
end)

-- Evento: deposita denaro nella fontana
RegisterNetEvent("money_fountain:tryPlace", function(fountainId)
    processFountainInteraction(source, fountainId, false)
end)

-- Thread per sincronizzare lo stato delle fontane non ancora inviate
CreateThread(function()
    while true do
        Wait(500)
        for _, fountain in pairs(moneyFountains) do
            if not sentState[fountain.id] then
                GlobalState["fountain_" .. fountain.id] = math.tointeger(getMoneyForFountain(fountain.id))
                sentState[fountain.id] = true
            end
        end
    end
end)
