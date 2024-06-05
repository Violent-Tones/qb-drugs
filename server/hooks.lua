local options = {
    print = false,
    inventoryFilter = {
        '^Dealer_[%w]+',
    }
}

exports.ox_inventory:registerHook('buyItem', function(payload)
    local src = payload.source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end

    local currentRep = Player.PlayerData.metadata['dealerrep']
    local minRep = payload.metadata['minrep']
    if currentRep < minRep then
        TriggerClientEvent('ox_lib:notify', src, {
            title = minRep .. ' rep needed to buy this!.',
            description = 'You currently have ' .. currentRep .. ' rep with the dealer.',
            position = 'center-right',
            type = 'error',
            duration = 5000,
        })
        return false
    end

end, options)