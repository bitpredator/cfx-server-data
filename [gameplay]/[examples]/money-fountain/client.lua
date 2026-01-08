-- Text entries
AddTextEntry("FOUNTAIN_HELP",
    "This fountain currently contains $~1~.~n~Press ~INPUT_PICKUP~ to obtain $~2~.~n~Press ~INPUT_DETONATE~ to place $~3~.")
AddTextEntry("FOUNTAIN_HELP_DRAINED", "This fountain currently contains $~1~.~n~Press ~INPUT_DETONATE~ to place $~2~.")
AddTextEntry("FOUNTAIN_HELP_BROKE", "This fountain currently contains $~1~.~n~Press ~INPUT_PICKUP~ to obtain $~2~.")
AddTextEntry("FOUNTAIN_HELP_BROKE_N_DRAINED", "This fountain currently contains $~1~.")
AddTextEntry("FOUNTAIN_HELP_INUSE", "This fountain currently contains $~1~.~n~You can use it again in ~a~.")

-- Upvalue aliases
local Wait = Wait
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId

-- Constants
local INPUT_PICKUP = 38
local INPUT_PLACE = 47
local MARKER_DISTANCE = 40.0
local INTERACT_DISTANCE = 1.0

-- Relevance check timer
local relevanceTimer = 500

-- Main logic thread
CreateThread(function()
    local pressing = false

    while true do
        Wait(relevanceTimer)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for _, data in pairs(moneyFountains) do
            local dist = #(coords - data.coords)

            if dist < MARKER_DISTANCE then
                relevanceTimer = 0
                DrawMarker(29, data.coords.x, data.coords.y, data.coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 150, 0,
                    120, false, true, 2, false, nil, nil, false)
            else
                relevanceTimer = 500
            end

            if dist < INTERACT_DISTANCE then
                local player = LocalPlayer
                local nextUse = player.state["fountain_nextUse"]
                local fountainAmount = GlobalState["fountain_" .. data.id] or 0
                local playerCash = player.state["money_cash"] or 0

                if nextUse and nextUse >= GetNetworkTime() then
                    BeginTextCommandDisplayHelp("FOUNTAIN_HELP_INUSE")
                    AddTextComponentInteger(fountainAmount)
                    AddTextComponentSubstringTime(math.tointeger(nextUse - GetNetworkTime()), 2 | 4)
                    EndTextCommandDisplayHelp(0, false, false, 1000)
                else
                    if not pressing then
                        if IsControlPressed(0, INPUT_PICKUP) then
                            TriggerServerEvent("money_fountain:tryPickup", data.id)
                            pressing = true
                        elseif IsControlPressed(0, INPUT_PLACE) then
                            TriggerServerEvent("money_fountain:tryPlace", data.id)
                            pressing = true
                        end
                    elseif not IsControlPressed(0, INPUT_PICKUP) and not IsControlPressed(0, INPUT_PLACE) then
                        pressing = false
                    end

                    local canPlayerPlace = playerCash >= data.amount
                    local canFountainGive = fountainAmount >= data.amount

                    local helpName = "FOUNTAIN_HELP_BROKE_N_DRAINED"
                    if canPlayerPlace and canFountainGive then
                        helpName = "FOUNTAIN_HELP"
                    elseif canPlayerPlace then
                        helpName = "FOUNTAIN_HELP_DRAINED"
                    elseif canFountainGive then
                        helpName = "FOUNTAIN_HELP_BROKE"
                    end

                    BeginTextCommandDisplayHelp(helpName)
                    AddTextComponentInteger(fountainAmount)

                    if canFountainGive then
                        AddTextComponentInteger(data.amount)
                    end
                    if canPlayerPlace then
                        AddTextComponentInteger(data.amount)
                    end

                    EndTextCommandDisplayHelp(0, false, false, 1000)
                end
            end
        end
    end
end)
