-- [ Simple Job Retrieving Command ]
CreateThread(function()
    RegisterCommand("myJob", function()
        local job = exports.wx_bridge:GetJob()
        if GetResourceState("chat") == "started" then -- Check if chat resource is available
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "Job", "Your job is: " .. job }
            })
        else
            print("Your Job is: ", job)
        end
    end, false)
end)

-- [ Wait for player to load, show a notification after and print PlayerData ]
CreateThread(function()
    -- [ Wait for player to choose their character ]
    while not exports.wx_bridge:IsPlayerLoaded() do
        Wait(500)
        print("Player is not loaded, waiting...")
    end

    -- [Player has chosen their character ]
    print("Player has loaded!")

    -- [ Show a welcome notification ]
    exports.wx_bridge:ShowNotification("Welcome!")

    -- [ Retrieve and print the player's data as JSON ]
    local playerData = exports.wx_bridge:GetPlayerData()
    print("Player Data: " .. json.encode(playerData))
end)

-- [ Check if player has required item and amount in inventory ]
CreateThread(function()
    -- [ Set the needed item and count ]
    local neededItem = "bread"
    local neededCount = 5

    local hasItem, itemCount = exports.wx_bridge:HasItem(neededItem)

    -- [ Check if player has the required item and count ]
    if hasItem and neededCount >= itemCount then
        print("Player has enough bread!")
    else
        print(("Player doesn't have enough bread. Missing: %s bread"):format(neededCount - itemCount))
    end
end)
