local StolenDrugs = {}

local function GetItemCount(source, item, type)
    if type and type == 'weed' then
        metadata = exports['violent-weed']:GetMetadata(item) or {}
        return exports.ox_inventory:GetItemCount(source, type, metadata, true)
    else
        return exports.ox_inventory:GetItemCount(source, item)
    end
end

local function GetDrugItem(source, drugName, type)
    local itemCount = GetItemCount(source, drugName, type)
    if itemCount == 0 then
        return nil
    else
        local metadata = exports['violent-weed']:GetMetadata(drugName)
        return {
            name = drugName,
            amount = itemCount,
            label = metadata and metadata.label or QBCore.Shared.Items[drugName]['label'],
            type = type
        }
    end
end

local function getAvailableDrugs(source)
    local AvailableDrugs = {}
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player then return nil end

    for k,v in pairs(Config.DrugsPrice) do
        local item = GetDrugItem(source, k, v.type)

        if item then
            AvailableDrugs[#AvailableDrugs + 1] = {
                item = item.name,
                amount = item.amount,
                label = item.label,
                type = item.type
            }
        end
    end
    return table.type(AvailableDrugs) ~= 'empty' and AvailableDrugs or nil
end

QBCore.Functions.CreateCallback('qb-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    cb(getAvailableDrugs(source))
end)

local function AddDrugToInventory(source, itemName, amount, itemType)
    if not source then return end
    if not itemName then return end

    if itemType and itemType == 'weed' then
        local metadata = exports['violent-weed']:GetMetadata(itemName) or {}
        exports.ox_inventory:AddItem(source, itemType, amount, metadata)
    else
        exports.ox_inventory:AddItem(source, itemName, amount)
    end
end

local function RemoveDrugFromInventory(source, itemName, amount, itemType)
    if not source then return end
    if not itemName then return end

    if itemType and itemType == 'weed' then
        local metadata = exports['violent-weed']:GetMetadata(itemName) or {}
        exports.ox_inventory:RemoveItem(source, itemType, amount, metadata)
    else
        exports.ox_inventory:RemoveItem(source, itemName, amount)
    end
end

RegisterNetEvent('qb-drugs:server:giveStealItems', function(drugType, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or StolenDrugs == {} then return end
    for k, v in pairs(StolenDrugs) do
        if drugType == v.item and amount == v.amount then
            AddDrugToInventory(source, v.item, v.amount, v.type)
            table.remove(StolenDrugs, k)
        end
    end
end)

RegisterNetEvent('qb-drugs:server:sellCornerDrugs', function(drugType, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)
    if not availableDrugs or not Player then return end
    local item = availableDrugs[drugType].item
    local type = availableDrugs[drugType].type
    local itemCount = GetItemCount(src, item, type)
    if itemCount >= amount then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.offer_accepted'), 'success')
        RemoveDrugFromInventory(src, item, amount, type)
        Player.Functions.AddMoney('cash', price, 'qb-drugs:server:sellCornerDrugs')
        TriggerClientEvent('qb-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
    else
        TriggerClientEvent('qb-drugs:client:cornerselling', src)
    end
end)

RegisterNetEvent('qb-drugs:server:robCornerDrugs', function(drugType, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)
    if not availableDrugs or not Player then return end
    local item = availableDrugs[drugType].item
    local type = availableDrugs[drugType].type
    RemoveDrugFromInventory(source, item, amount, type)
    table.insert(StolenDrugs, { item = item, amount = amount, type = type })
    TriggerClientEvent('qb-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
end)
