AddEventHandler("onClientMapStart", function()
    CreateThread(function()
        -- Aspetta un attimo per sicurezza
        Wait(500)

        if exports.spawnmanager then
            exports.spawnmanager:setAutoSpawn(true)
            exports.spawnmanager:forceRespawn()

            -- print("[DEBUG] AutoSpawn abilitato e respawn forzato eseguito.")
        else
            print("[ERRORE] spawnmanager non disponibile!")
        end
    end)
end)
