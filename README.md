![banner](.assets/bridge-banner.png)

# About

WX Bridge is an advanced system for FiveM that allows you to bridge multiple frameworks. With WX Bridge, you don't have to write your own support for multiple framework-dependent functions, such as retrieving a player's job. You can use snippets from this system or add the entire system as a dependency, and then use it with exports.

# Usage
* Choose your framework in `configs/bridge_config.lua`

```lua
-- client.lua
local PlayerData = exports.wx_bridge:GetPlayerData()
print(json.encode(PlayerData, {
    indent = true
}))
```
# Available Exports:
### Client


| Function                                          | Description                                                                   | Parameters                               | Return Type       |
|---------------------------------------------------|-------------------------------------------------------------------------------|------------------------------------------|-------------------|
| `exports.wx_bridge:GetPlayerData()`               | Returns current player's data, like character info (name, job, etc.).         | None                                     | table             |
| `exports.wx_bridge:IsPlayerLoaded()`              | Returns `true` if the player has chosen their character.                       | None                                     | boolean           |
| `exports.wx_bridge:SetPlayerData(key, value)`     | Modifies the current player's data.                                           | `key` (string), `value` (any)           | None              |
| `exports.wx_bridge:OpenInventory()`               | Opens the inventory through the framework.                                     | None                                     | None              |
| `exports.wx_bridge:ShowNotification(text)`        | Shows a notification through the framework.                                    | `text` (string)                          | None              |

### Server

### Available Functions

| Function                                          | Description                                                                   | Parameters                               | Return Type       |
|---------------------------------------------------|-------------------------------------------------------------------------------|------------------------------------------|-------------------|
| `exports.wx_bridge:GetPlayer(id)`                 | Returns player object (like xPlayer in ESX).                                 | `id` (number)                            | table             |
| `exports.wx_bridge:GetAllPlayers()`               | Returns all online players.                                                   | None                                     | table             |
| `exports.wx_bridge:GetPlayerJob(id)`              | Returns player's job.                                                         | `id` (number)                            | string            |
| `exports.wx_bridge:GetPlayerJobGrade(id)`         | Returns player's job grade number.                                            | `id` (number)                            | number            |
| `exports.wx_bridge:HasPermission(playerId)`       | Returns boolean - check if player has one of the configured admin groups.     | `playerId` (number)                     | boolean           |
| `exports.wx_bridge:AddMoney(playerId, amount)`    | Adds money to player. (with most frameworks to their inventory)               | `playerId` (number), `amount` (number) | None              |
| `exports.wx_bridge:RemoveMoney(playerId, amount)` | Removes money from player. (with most frameworks from their inventory)         | `playerId` (number), `amount` (number) | None              |
| `exports.wx_bridge:RemoveBankMoney(playerId, amount)` | Removes money from player's bank.                                         | `playerId` (number), `amount` (number) | None              |
| `exports.wx_bridge:GetMoney(playerId)`           | Retrieves player's money (with most frameworks from their inventory)          | `playerId` (number)                     | number            |
| `exports.wx_bridge:GetBankMoney(playerId)`       | Retrieves player's money from bank.                                           | `playerId` (number)                     | number            |
| `exports.wx_bridge:TransferMoney(from, to, amount)` | Transfers bank money from one player to another                              | `from` (number), `to` (number), `amount` (number) | boolean, string |

### Example: Getting Player's Job

```lua
local jobId = exports.wx_bridge:GetPlayerJob(playerId)
print("Player's job ID: " .. jobId)


## Contributing
Contributions are welcome! If you have any suggestions or improvements, please submit a pull request or open an issue.

## License
WX Bridge is licensed under the MIT License. See the LICENSE file for more details.

## Support
If you encounter any issues, feel free to open an issue. Do not open issues with questions on how to use this.

