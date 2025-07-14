local moneyTypes = {
    cash = `MP0_WALLET_BALANCE`,
    bank = `BANK_BALANCE`,
}

RegisterNetEvent("money:displayUpdate", function(moneyType, amount)
    local stat = moneyTypes[moneyType]
    if not stat then
        return
    end

    StatSetInt(stat, math.floor(amount), true)
end)

-- Richiede al server la visualizzazione iniziale all'avvio
TriggerServerEvent("money:requestDisplay")

-- Mostra HUD GTA per contanti e banca se si preme Z (default GTA: INPUT_MULTIPLAYER_INFO)
CreateThread(function()
    local displayKey = 20 -- INPUT_MULTIPLAYER_INFO (tasto Z)
    while true do
        Wait(0)
        if IsControlJustPressed(0, displayKey) then
            SetMultiplayerBankCash()
            SetMultiplayerWalletCash()

            Wait(4500)

            RemoveMultiplayerBankCash()
            RemoveMultiplayerWalletCash()
        end
    end
end)
