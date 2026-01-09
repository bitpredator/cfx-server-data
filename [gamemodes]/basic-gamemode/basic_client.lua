AddEventHandler("onClientMapStart", function()
    CreateThread(function()
        -- Wait a moment for safety
        Wait(500)

        if exports.spawnmanager then
            exports.spawnmanager:setAutoSpawn(true)
            exports.spawnmanager:forceRespawn()

            -- print("[DEBUG] AutoSpawn enabled and forced respawn executed.")
        else
            print("[ERROR] spawnmanager not available!")
        end
    end)
end)
