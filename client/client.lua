local BRIDGE = {}
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

---Returns current's player data, like the character info (name, job, ...). Returned data may vary depending on the framework
---@return table
function B:GetPlayerData()
    Debug(GetInvokingResource(), "GetPlayerData")
    if framework == "esx" then
        return ESX.GetPlayerData()
    end
    return {}
end

---Returns boolean if player has chosen his character
---@return boolean
function B:IsPlayerLoaded()
    Debug(GetInvokingResource(), "IsPlayerLoaded")
    if framework == "esx" then
        return ESX.IsPlayerLoaded()
    end
    return false
end

---Modifies the current player's data
---@param key string
---@param value any
function B:SetPlayerData(key, value)
    Debug(GetInvokingResource(), "SetPlayerData", key, value)
    if framework == "esx" then
        ESX.SetPlayerData(key, value)
    end
end

---Opens inventory through the framework
function B:OpenInventory()
    Debug(GetInvokingResource(), "OpenInventory")
    if framework == "esx" then
        ESX.ShowInventory()
    end
end

---Shows notification thorough the framework
---@param text string
function B:ShowNotification(text)
    Debug(GetInvokingResource(), "ShowNotification", text)
    if framework == "esx" then
        ESX.ShowNotification(text)
    elseif framework == "qb" then
        QBCore.Functions.Notify(text)
    end
end

-- function B:Example()
--     if framework == "esx" then
--     end
-- end


exports("GetPlayerData", function()
    return B:GetPlayerData()
end)

exports("IsPlayerLoaded", function()
    return B:IsPlayerLoaded()
end)

exports("SetPlayerData", function(key, value)
    B:SetPlayerData(key, value)
end)

exports("OpenInventory", function()
    B:OpenInventory()
end)

exports("ShowNotification", function(text)
    B:ShowNotification(text)
end)
