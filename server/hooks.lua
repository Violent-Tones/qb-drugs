QBCore = exports['qb-core']:GetCoreObject()

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

    local curRep = Player.Functions.GetRep('dealer')
    local minRep = payload.fromSlot.metadata['minrep']
    if curRep < minRep then
        TriggerClientEvent('ox_lib:notify', src, {
            title = minRep .. ' rep needed to buy this!',
            description = 'You currently have ' .. curRep .. ' rep with the dealer.',
            position = 'center-right',
            type = 'error',
            duration = 5000,
        })
        return false
    end

end, options)