--[[
!!

? Used to load the bridge functions inside other resources
? through the fxmanifest.lua. Can be used to use the functions
? directly instead of exports (why would anyone do that?)

? Instead of exports.wx_bridge you can do just BRIDGE:FUNCTION()

!!
]]

if IsDuplicityVersion() then
    return BRIDGE
else
    return BRIDGE
end
