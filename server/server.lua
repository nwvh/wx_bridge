BRIDGE = {}
local framework = wx.Framework:lower()
local B = BRIDGE

if framework == "esx" then
    if GetResourceState("es_extended") ~= "started" then
        return BetterPrint(
            "Framework has been set to ESX, but es_extended was not found! Make sure you're starting the bridge AFTER es_extended.",
            "error")
    end
    ESX = exports.es_extended:getSharedObject()
end

if framework == "qb" then
    if GetResourceState("qb-core") ~= "started" then
        return BetterPrint(
            "Framework has been set to QB Core, but qb-core was not found! Make sure you're starting the bridge AFTER qb-core.",
            "error")
    end
    QBCore = exports['qb-core']:GetCoreObject()
end

---Returns player object (like xPlayer in ESX)
---@param id number
---@return table
function B:GetPlayer(id)
    if framework == "esx" then
        return ESX.GetPlayerFromId(id)
    elseif framework == "qb" then
        return QBCore.Functions.GetPlayer(id).PlayerData
    end
    return {}
end

---Returns all online players
---@return table
function B:GetAllPlayers()
    if framework == "esx" then
        return ESX.GetPlayers()
    end
    return {}
end

---Returns player's job
---@param id number
---@return string
function B:GetPlayerJob(id)
    local xPlayer = BRIDGE:GetPlayer(id)
    return xPlayer.job.name
end

---Returns player's job grade number
---@param id number
---@return number
function B:GetPlayerJobGrade(id)
    local xPlayer = BRIDGE:GetPlayer(id)
    if framework == "esx" then
        return xPlayer.getJob().grade
    elseif framework == "qb" then
        return xPlayer.job.grade.level
    end
    return 0
end

---Returns boolean - check if player has one of the configured admin groups
---@param playerId number
---@return boolean
function B:HasPermission(playerId)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        return wx.AdminGroups[xPlayer.getGroup()]
    elseif framework == "qb" then
        for group, _ in pairs(wx.AdminGroups) do
            if QBCore.Functions.HasPermission(playerId, group) then
                return true
            end
        end
    end
    return false
end

---Adds money to player. (with most frameworks to their inventory)
---@param playerId number Target player ID
---@param amount number Amount to add
function B:AddMoney(playerId, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.addMoney(amount)
    end
end

---Removes money from player. (with most frameworks from their inventory)
---@param playerId number Target player ID
---@param amount number Amount to remove
function B:RemoveMoney(playerId, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.removeMoney(amount)
    end
end

---Removes money from player's bank.
---@param playerId number Target player ID
---@param amount number Amount to remove
function B:RemoveBankMoney(playerId, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.removeAccountMoney("bank", amount)
    end
end

---Retrieves player's money (with most frameworks from their inventory)
---@param playerId number Target player ID
---@return number amount Player's money
function B:GetMoney(playerId)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        return xPlayer.getMoney()
    end
    return 0
end

---Retrieves player's money from bank
---@param playerId number Target player ID
---@return number amount Player's bank balance
function B:GetBankMoney(playerId)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        return xPlayer.getAccount("bank").money
    end
    return 0
end

---Transfers bank money from one player to another
---@param from number Sender's ID
---@param to number Receiver's ID
---@param amount number Amount to transfer
---@return boolean status, string statusMessage
function B:TransferMoney(from, to, amount)
    if framework == "esx" then
        if not GetPlayerName(to) then return false, "Not Online" end -- Check if player is online
        local xPlayer = B:GetPlayer(from)
        local xTarget = B:GetPlayer(to)
        if xPlayer.getAccount("bank").money >= amount then
            xPlayer.removeAccountMoney("bank", amount)
            xTarget.addAccountMoney("bank", amount)
            return true, "Success"
        else
            return false, "Not enough money in sender's account"
        end
    end
    return false, "Invalid Framework"
end

---Adds item to player's inventory
---@param playerId number Target player ID
---@param item_name string Item name to give
---@param amount number Amount to give
function B:AddItem(playerId, item_name, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.addInventoryItem(item_name, amount)
    end
end

---Removes item from player's inventory
---@param playerId number Target player ID
---@param item_name string Item name to remove
---@param amount number Amount to remove
function B:RemoveItem(playerId, item_name, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.removeInventoryItem(item_name, amount)
    end
end

---Retrieves info about an item from player's inventory
---@param playerId number Target player ID
---@param item_name string Item to check
---@return table
function B:GetItem(playerId, item_name)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        return xPlayer.getInventoryItem(item_name)
    end
    return {}
end

---Returns boolean - Checks if player can carry the given item and count
---@param playerId number Target player ID
---@param item_name string Item Name
---@param amount number Item Count
function B:CanCarryItem(playerId, item_name, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        return xPlayer.canCarryItem(item_name, amount)
    end
    return false
end

---Set player's job
---@param playerId number Target player ID
---@param job_name string Job name
---@param job_grade number Job Grade
function B:SetJob(playerId, job_name, job_grade)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.setJob(job_name, job_grade)
    end
end

---Returns player's rockstar identifier
---@param playerId number Target player ID
---@return string license license: identifier
function B:GetIdentifier(playerId)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        return xPlayer.getIdentifier()
    end
    return GetPlayerIdentifierByType(playerId, 'license')
end

---Returns the coords of given player ID
---@param playerId number Target player ID
---@return vector3 coords Player Coords
function B:GetPlayerCoords(playerId)
    local ped = GetPlayerPed(playerId)
    return GetEntityCoords(ped)
end

exports("GetPlayer", B.GetPlayer)
exports("GetAllPlayers", B.GetAllPlayers)
exports("GetPlayerJob", B.GetPlayerJob)
exports("GetPlayerJobGrade", B.GetPlayerJobGrade)
exports("HasPermission", B.HasPermission)
exports("AddMoney", B.AddMoney)
exports("RemoveMoney", B.RemoveMoney)
exports("RemoveBankMoney", B.RemoveBankMoney)
exports("GetMoney", B.GetMoney)
exports("GetBankMoney", B.GetBankMoney)
exports("TransferMoney", B.TransferMoney)
exports("AddItem", B.AddItem)
exports("RemoveItem", B.RemoveItem)
exports("GetItem", B.GetItem)
exports("CanCarryItem", B.CanCarryItem)
exports("SetJob", B.SetJob)
exports("GetIdentifier", B.GetIdentifier)
exports("GetPlayerCoords", B.GetPlayerCoords)
