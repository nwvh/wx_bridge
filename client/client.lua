local BRIDGE = {}
local framework
local B = BRIDGE

local ESX, QBCore


-- Eliminate the need to manually configure framework, instead detect it manually
if wx.Framework:lower() == "auto" then
    CreateThread(function()
        local qb = GetResourceState('qb-core') == "started"
        local esx = GetResourceState('es_extended') == "started"
        local ox_core = GetResourceState('ox_core') == "started"
        local nd_core = GetResourceState('nd_core') == "started"

        if qb then
            QBCore = exports['qb-core']:GetCoreObject()
            framework = "qb" --! TODO: Full QB Core Support
        elseif esx then
            ESX = exports["es_extended"]:getSharedObject()
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
end

if framework == "qb" then
    if GetResourceState("qb-core") ~= "started" then
        return BetterPrint(
            "Framework has been set to QB Core, but qb-core was not found! Make sure you're starting the bridge AFTER qb-core.",
            "error")
    end
end

if framework == "ox" then
    --TODO: OX Core
    return
end

if framework == "nd" then
    --TODO: ND Core
    return
end

---Returns current's player data, like the character info (name, job, ...). Returned data may vary depending on the framework
---@return table
function B:GetPlayerData()
    Debug(GetInvokingResource(), "GetPlayerData")
    if framework == "esx" then
        local data = ESX.GetPlayerData()
        return data
    elseif framework == "qb" then
        return QBCore.Functions.GetPlayerData()
    end
    return {}
end

---Returns boolean if player has chosen his character
---@return boolean
function B:IsPlayerLoaded()
    Debug(GetInvokingResource(), "IsPlayerLoaded")
    if framework == "esx" then
        return ESX.IsPlayerLoaded()
    elseif framework == "qb" then
        return QBCore.isPlayerLoaded()
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
    elseif framework == "qb" then
        return error("QB Core doesn't support SetPlayerData!") -- afaik
    end
end

---Opens inventory through the framework
function B:OpenInventory()
    Debug(GetInvokingResource(), "OpenInventory")
    if framework == "esx" then
        ESX.ShowInventory()
    elseif framework == "qb" then
        TriggerEvent("inventory:client:OpenInventory") -- Couldn't find any other function in QB
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

---Client side function for police dispatch
---@param code string Dispatch code (10-XX)
---@param title string Dispatch title message
---@param message string Dispatch description
---@param blip number Blip sprite number. [Blip List](https://docs.fivem.net/docs/game-references/blips/)
---@param jobs table Table containing recipient jobs
---@param important boolean | number Is the dispatch important?
function B:Dispatch(code, title, message, blip, jobs, important)
    if wx.Dispatch:lower() == "cd_dispatch" then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = jobs or { "police" },
            coords = data.coords,
            title = ("%s - %s"):format(code or "10-00", title or "Missing Title"),
            message = message or "Sample Message",
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = blip,
                scale = 1.2,
                colour = 3,
                flashes = false,
                text = title,
                time = 5,
                radius = 0,
            }
        })
    elseif wx.Dispatch:lower() == "linden" then
        local data = {
            displayCode = code,
            description = title,
            isImportant = important and 1 or 0,
            recipientList = jobs,
            length =
            '10000',
            infoM = 'fa-info-circle',
            info = message
        }
        local dispatchData = { dispatchData = data, caller = 'Alarm', coords = GetEntityCoords(PlayerPedId()) }
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    elseif wx.Dispatch:lower() == "custom" then
        -- your custom dispatch system here
    end
end

---Returns player's job name
---@return string
function B:GetJob()
    if framework == "esx" or framework == "qb" then
        return B:GetPlayerData().job.name or "unemployed"
    end
    return "unemployed"
end

---Returns player's job grade number
---@return number
function B:GetJobGrade()
    if framework == "esx" then
        return B:GetPlayerData().job.grade
    elseif framework == "qb" then
        return B:GetPlayerData().job.grade.level
    end
    return 0
end

---Returns boolean - Checks if player has given item in inventory
---@param item_name string Item name
---@return boolean, number hasItem Returns true if player has given item in inventory and item count
function B:HasItem(item_name)
    local count = 0
    if framework == "esx" then
        for _, v in pairs(B:GetPlayerData().inventory) do
            if v.name == item_name then
                count = v.count
                return true, count
            end
        end
    elseif framework == "qb" then
        return QBCore.Functions.HasItem(item_name), 0 --! TODO: Retrieve item count in QB
    end
    return false, 0
end

---Returns player's inventory contents
---@return table
function B:GetInventory()
    if framework == "esx" then
        local playerData = B:GetPlayerData()
        return playerData.inventory
    elseif framework == "qb" then
        return QBCore.Functions.GetPlayerData().items
    end
    return {}
end

---Closes any open menu (like esx_menu_default)
function B:CloseMenu()
    if framework == "esx" then
        ESX.UI.Menu.CloseAll()
    elseif framework == "qb" then
        TriggerEvent("qb-menu:client:closeMenu")
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

exports("Dispatch", function(code, title, message, blip, jobs, important)
    B:Dispatch(code, title, message, blip, jobs, important)
end)

exports("GetJob", function()
    return B:GetJob()
end)

exports("GetJobGrade", function()
    return B:GetJobGrade()
end)

exports("HasItem", function(item_name)
    return B:HasItem(item_name)
end)

exports("GetInventory", function()
    return B:GetInventory()
end)

exports("CloseMenu", function()
    return B:CloseMenu()
end)
