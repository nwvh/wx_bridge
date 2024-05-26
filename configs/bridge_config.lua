wx = {}

wx.Debug = true    -- Enables debug prints

wx.DebugIgnore = { -- Ignore debug prints from these resources
    ['wx_unijob'] = true
}

wx.Framework = "auto"       -- [auto / esx / qb / custom]
wx.Dispatch = "cd_dispatch" -- [cd_dispatch / linden / custom]

wx.AdminGroups = {
    ["owner"] = true,
    ["admin"] = true,
    ["moderator"] = true,
    ["helper"] = true,
}
