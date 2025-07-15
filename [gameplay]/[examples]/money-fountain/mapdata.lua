-- SHARED SCRIPT: Money Fountain Registry

moneyFountains = {}
local nextFountainIndex = 1

AddEventHandler("getMapDirectives", function(add)
    -- Register a custom map directive for 'money_fountain'
    add("money_fountain", function(state, name)
        return function(data)
            local coords = data[1]
            local amount = tonumber(data.amount) or 100

            if type(coords) ~= "vector3" then
                print(("Invalid coordinates for fountain '%s'"):format(name))
                return
            end

            local index = nextFountainIndex
            nextFountainIndex += 1

            moneyFountains[index] = {
                id = name,
                coords = coords,
                amount = amount,
            }

            -- Save index to later remove it
            state.add("idx", index)
        end
    end, function(state)
        -- Cleanup when the directive is removed
        local idx = state.idx
        if moneyFountains[idx] then
            moneyFountains[idx] = nil
        end
    end)
end)
