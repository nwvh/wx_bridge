---Prettier print function
---@param text string Text to print
---@param type 'error' | 'warning' | 'config' | 'info' | 'success' | 'debug'
---@return any
function BetterPrint(text, type)
    local types = {
        ["error"] = "^7[^1 ERROR ^7] ",
        ["warning"] = "^7[^3 WARNING ^7] ",
        ["config"] = "^7[^3 CONFIG WARNING ^7] ",
        ["info"] = "^7[^5 INFO ^7] ",
        ["success"] = "^7[^2 SUCCESS ^7] ",
        ["debug"] = "^7[^6 DEBUG ^7] ",
    }
    return print("^7[^5 WX BRIDGE ^7] " .. (types[string.lower(type or "info")]) .. text)
end

function Debug(resource, export, ...)
    if wx.DebugIgnore[resource] then return end
    local args = { ... }
    local argString = json.encode(args) or "None"
    if wx.Debug then
        BetterPrint(("^7[^5%s^7] Resource %s invoked export %s. Arguments: %s"):format(
            IsDuplicityVersion() and "SERVER" or "CLIENT", resource, export, argString), 'debug')
    end
end
