-- [[ Resource Info ]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'
author 'wx / woox'
description 'Advanced bridge system for your fivem resources, utilised via exports'


-- [[ Client-Side Files ]]

client_scripts {
    'client/*.lua'
}

-- [[ Server-Side Files ]]

server_scripts {
    'server/*.lua'
}

-- [[ Shared Files & Configs ]]

shared_scripts {
    'configs/*.lua',
    'shared/*.lua'
}

client_exports {
    'GetPlayerData',   -- exports.wx_bridge:GetPlayerData()
    'IsPlayerLoaded',  -- exports.wx_bridge:IsPlayerLoaded()
    'SetPlayerData',   -- exports.wx_bridge:SetPlayerData(key, value)
    'OpenInventory',   -- exports.wx_bridge:OpenInventory()
    'ShowNotification' -- exports.wx_bridge:ShowNotification(text)
}


server_exports {
    'GetPlayer',         -- exports.wx_bridge:GetPlayer(id)
    'GetAllPlayers',     -- exports.wx_bridge:GetAllPlayers()
    'GetPlayerJob',      -- exports.wx_bridge:GetPlayerJob(id)
    'GetPlayerJobGrade', -- exports.wx_bridge:GetPlayerJobGrade(id)
    'HasPermission',     -- exports.wx_bridge:HasPermission(playerId)
    'AddMoney',          -- exports.wx_bridge:AddMoney(playerId, amount)
    'RemoveMoney',       -- exports.wx_bridge:RemoveMoney(playerId, amount)
    'RemoveBankMoney',   -- exports.wx_bridge:RemoveBankMoney(playerId, amount)
    'GetMoney',          -- exports.wx_bridge:GetMoney(playerId)
    'GetBankMoney',      -- exports.wx_bridge:GetBankMoney(playerId)
    'TransferMoney',     -- exports.wx_bridge:TransferMoney(from, to, amount)
    'AddItem',           -- exports.wx_bridge:AddItem(playerId, item_name, amount)
    'RemoveItem',        -- exports.wx_bridge:RemoveItem(playerId, item_name, amount)
    'GetItem',           -- exports.wx_bridge:GetItem(playerId, item_name)
    'CanCarryItem',      -- exports.wx_bridge:CanCarryItem(playerId, item_name, amount)
    'SetJob',            -- exports.wx_bridge:SetJob(playerId, job_name, job_grade)
    'GetIdentifier',     -- exports.wx_bridge:GetIdentifier(playerId)
    'GetPlayerCoords'    -- exports.wx_bridge:GetPlayerCoords(playerId)
}
