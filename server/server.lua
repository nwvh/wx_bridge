BRIDGE = {}
local framework
local B = BRIDGE

if wx.Framework:lower() == "auto" then
    CreateThread(function()
        local qb = GetResourceState('qb-core') == "started"
        local esx = GetResourceState('es_extended') == "started"
        local ox_core = GetResourceState('ox_core') == "started"
        local nd_core = GetResourceState('nd_core') == "started"

        if qb then
            framework = "qb" --! TODO: QB Core Support
        elseif esx then
            framework = "esx"
        elseif ox_core then
            framework = "ox" --! TODO: OX Core Support
        elseif nd_core then
            framework = "nd" --! TODO: ND Core Support
        else
            BetterPrint(
                "Couldn't detect your framework! Please make sure that wx_bridge starts AFTER your framework resource.",
                "error"
            )
            return error("Unknown Framework")
        end
    end)
else
    framework = wx.Framework:lower()
end

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
    Debug(GetInvokingResource(), "GetPlayer", id)
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
    Debug(GetInvokingResource(), "GetAllPlayers")
    if framework == "esx" then
        return ESX.GetPlayers()
    end
    return {}
end

---Returns player's job
---@param id number
---@return string
function B:GetPlayerJob(id)
    Debug(GetInvokingResource(), "GetPlayerJob", id)
    local xPlayer = BRIDGE:GetPlayer(id)
    return xPlayer.job.name
end

---Returns player's job grade number
---@param id number
---@return number
function B:GetPlayerJobGrade(id)
    Debug(GetInvokingResource(), "GetPlayerJobGrade", id)
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
    Debug(GetInvokingResource(), "HasPermission", playerId)
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
    Debug(GetInvokingResource(), "AddMoney", playerId, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.addMoney(amount)
    end
end

---Removes money from player. (with most frameworks from their inventory)
---@param playerId number Target player ID
---@param amount number Amount to remove
function B:RemoveMoney(playerId, amount)
    Debug(GetInvokingResource(), "RemoveMoney", playerId, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.removeMoney(amount)
    end
end

---Removes money from player's bank.
---@param playerId number Target player ID
---@param amount number Amount to remove
function B:RemoveBankMoney(playerId, amount)
    Debug(GetInvokingResource(), "RemoveBankMoney", playerId, amount)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.removeAccountMoney("bank", amount)
    end
end

---Retrieves player's money (with most frameworks from their inventory)
---@param playerId number Target player ID
---@return number amount Player's money
function B:GetMoney(playerId)
    Debug(GetInvokingResource(), "GetMoney", playerId)
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
    Debug(GetInvokingResource(), "GetBankMoney", playerId)
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
    Debug(GetInvokingResource(), "TransferMoney", from, to, amount)
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
    Debug(GetInvokingResource(), "AddItem", item_name, amount)
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
    Debug(GetInvokingResource(), "RemoveItem", playerId, item_name, amount)
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
    Debug(GetInvokingResource(), "GetItem", playerId, item_name)
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
    Debug(GetInvokingResource(), "CanCarryItem", playerId, item_name, amount)
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
    Debug(GetInvokingResource(), "SetJob", playerId, job_name, job_grade)
    if framework == "esx" then
        local xPlayer = B:GetPlayer(playerId)
        xPlayer.setJob(job_name, job_grade)
    end
end

---Returns player's rockstar identifier
---@param playerId number Target player ID
---@return string license license: identifier
function B:GetIdentifier(playerId)
    Debug(GetInvokingResource(), "GetIdentifier", playerId)
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
    Debug(GetInvokingResource(), "GetPlayerCoords", playerId)
    local ped = GetPlayerPed(playerId)
    return GetEntityCoords(ped)
end

exports("GetPlayer", function(id)
    Debug(GetInvokingResource(), "GetPlayer", id)
    return B:GetPlayer(id)
end)

exports("GetAllPlayers", function()
    Debug(GetInvokingResource(), "GetAllPlayers")
    return B:GetAllPlayers()
end)

exports("GetPlayerJob", function(id)
    Debug(GetInvokingResource(), "GetPlayerJob", id)
    return B:GetPlayerJob(id)
end)

exports("GetPlayerJobGrade", function(id)
    Debug(GetInvokingResource(), "GetPlayerJobGrade", id)
    return B:GetPlayerJobGrade(id)
end)

exports("HasPermission", function(playerId)
    Debug(GetInvokingResource(), "HasPermission", playerId)
    return B:HasPermission(playerId)
end)

exports("AddMoney", function(playerId, amount)
    Debug(GetInvokingResource(), "AddMoney", playerId, amount)
    return B:AddMoney(playerId, amount)
end)

exports("RemoveMoney", function(playerId, amount)
    Debug(GetInvokingResource(), "RemoveMoney", playerId, amount)
    return B:RemoveMoney(playerId, amount)
end)

exports("RemoveBankMoney", function(playerId, amount)
    Debug(GetInvokingResource(), "RemoveBankMoney", playerId, amount)
    return B:RemoveBankMoney(playerId, amount)
end)

exports("GetMoney", function(playerId)
    Debug(GetInvokingResource(), "GetMoney", playerId)
    return B:GetMoney(playerId)
end)

exports("GetBankMoney", function(playerId)
    Debug(GetInvokingResource(), "GetBankMoney", playerId)
    return B:GetBankMoney(playerId)
end)

exports("TransferMoney", function(from, to, amount)
    Debug(GetInvokingResource(), "TransferMoney", from, to, amount)
    return B:TransferMoney(from, to, amount)
end)

exports("AddItem", function(playerId, item_name, amount)
    Debug(GetInvokingResource(), "AddItem", playerId, item_name, amount)
    return B:AddItem(playerId, item_name, amount)
end)

exports("RemoveItem", function(playerId, item_name, amount)
    Debug(GetInvokingResource(), "RemoveItem", playerId, item_name, amount)
    return B:RemoveItem(playerId, item_name, amount)
end)

exports("GetItem", function(playerId, item_name)
    Debug(GetInvokingResource(), "GetItem", playerId, item_name)
    return B:GetItem(playerId, item_name)
end)

exports("CanCarryItem", function(playerId, item_name, amount)
    Debug(GetInvokingResource(), "CanCarryItem", playerId, item_name, amount)
    return B:CanCarryItem(playerId, item_name, amount)
end)

exports("SetJob", function(playerId, job_name, job_grade)
    Debug(GetInvokingResource(), "SetJob", playerId, job_name, job_grade)
    return B:SetJob(playerId, job_name, job_grade)
end)

exports("GetIdentifier", function(playerId)
    Debug(GetInvokingResource(), "GetIdentifier", playerId)
    return B:GetIdentifier(playerId)
end)

exports("GetPlayerCoords", function(playerId)
    Debug(GetInvokingResource(), "GetPlayerCoords", playerId)
    return B:GetPlayerCoords(playerId)
end)
