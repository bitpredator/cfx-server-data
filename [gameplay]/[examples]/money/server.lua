local playerData = exports["cfx.re/playerData.v1alpha1"]

local validMoneyTypes = {
    bank = true,
    cash = true,
}

local function isValidAmount(amount)
    amount = tonumber(amount)
    return amount and amount > 0 and amount < (1 << 30)
end

local function getMoneyKey(playerId, moneyType)
    return ("money:%s:%s"):format(playerId, moneyType)
end

local function getMoneyForId(playerId, moneyType)
    local key = getMoneyKey(playerId, moneyType)
    return GetResourceKvpInt(key) / 100.0
end

local function setMoneyForId(playerId, moneyType, amount)
    local source = playerData:getPlayerById(playerId)

    TriggerEvent("money:updated", {
        dbId = playerId,
        source = source,
        moneyType = moneyType,
        money = amount,
    })

    local key = getMoneyKey(playerId, moneyType)
    return SetResourceKvpInt(key, math.tointeger(amount * 100.0))
end

local function addMoneyForId(playerId, moneyType, delta)
    local current = getMoneyForId(playerId, moneyType)
    local newAmount = current + delta

    if newAmount >= 0 then
        setMoneyForId(playerId, moneyType, newAmount)
        return true, newAmount
    end

    return false, current
end

exports("addMoney", function(playerIdx, moneyType, amount)
    if not isValidAmount(amount) or not validMoneyTypes[moneyType] then
        return false
    end

    local playerId = playerData:getPlayerId(playerIdx)
    if not playerId then
        return false
    end

    local success, updatedAmount = addMoneyForId(playerId, moneyType, amount)
    if success then
        Player(playerIdx).state["money_" .. moneyType] = updatedAmount
    end
    return success
end)

exports("removeMoney", function(playerIdx, moneyType, amount)
    if not isValidAmount(amount) or not validMoneyTypes[moneyType] then
        return false
    end

    local playerId = playerData:getPlayerId(playerIdx)
    if not playerId then
        return false
    end

    local success, updatedAmount = addMoneyForId(playerId, moneyType, -amount)
    if success then
        Player(playerIdx).state["money_" .. moneyType] = updatedAmount
    end
    return success
end)

exports("getMoney", function(playerIdx, moneyType)
    local playerId = playerData:getPlayerId(playerIdx)
    if not playerId then
        return 0.0
    end
    return getMoneyForId(playerId, moneyType)
end)

-- 🔄 Sincronizzazione al client
AddEventHandler("money:updated", function(data)
    if data.source then
        TriggerClientEvent("money:displayUpdate", data.source, data.moneyType, data.money)
    end
end)

RegisterNetEvent("money:requestDisplay", function()
    local src = source
    local playerId = playerData:getPlayerId(src)
    if not playerId then
        return
    end

    for moneyType in pairs(validMoneyTypes) do
        local amount = getMoneyForId(playerId, moneyType)
        TriggerClientEvent("money:displayUpdate", src, moneyType, amount)
        Player(src).state["money_" .. moneyType] = amount
    end
end)

-- 💰 Comandi di debug / test
RegisterCommand("earn", function(source, args)
    local moneyType = args[1]
    local amount = tonumber(args[2])
    exports["money"]:addMoney(source, moneyType, amount)
end, true)

RegisterCommand("spend", function(source, args)
    local moneyType = args[1]
    local amount = tonumber(args[2])
    if not exports["money"]:removeMoney(source, moneyType, amount) then
        print("You are broke?")
    end
end, true)
