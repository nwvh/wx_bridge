-- [ Simple player kick command ]
CreateThread(function()
    RegisterCommand("kick", function(source, args, rawCommand)
        -- [ Make sure the command is not being run from the server console ]
        if source == 0 then return end

        -- [ Check player's permissions ]
        local hasPermission = exports.wx_bridge:HasPermission(source)
        if not hasPermission then
            return print("You don't have permissions to use this command!")
        end

        -- [ Check if specified player ID is valid]
        if not args[1] then
            return print("Please specify a player ID")
        end
        if not tonumber(args[1]) then
            return print("Specify a number!")
        end
        if not GetPlayerName(args[1]) then
            return print("Player is not online.")
        end

        -- [ Kick the specified player ]

        -- Because each word counts as an argument, we use table.concat() to add them together
        local kickMessage = table.concat(
            args:sub(             -- Remove the first argument (player ID) from the kick message
                tonumber(
                    args[1]:len() -- Length of the first argument
                )
            )
        )
        DropPlayer(args[1], kickMessage or "You have been kicked by an admin") -- If no kick message is provided, use a default one
    end, false)
end)
