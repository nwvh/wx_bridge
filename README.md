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


#### `exports.wx_bridge:GetPlayerData()`
Returns current player's data, like character info (name, job, etc.). Returned data may vary depending on the framework.
- **Return Type**: `table`

#### `exports.wx_bridge:IsPlayerLoaded()`
Returns `true` if the player has chosen their character.
- **Return Type**: `boolean`

#### `exports.wx_bridge:SetPlayerData(key, value)`
Modifies the current player's data.
- **Parameters**:
  - `key` (`string`): The key for the data to be set.
  - `value` (`any`): The value to be set for the key.

#### `exports.wx_bridge:OpenInventory()`
Opens the inventory through the framework.

#### `exports.wx_bridge:ShowNotification(text)`
Shows a notification through the framework.
- **Parameters**:
  - `text` (`string`): The text to be displayed in the notification.

### Server
#### `exports.wx_bridge:GetPlayer(id)`
Returns player object (like xPlayer in ESX).
- **Parameters**:
  - `id` (`number`): Player ID.
- **Return Type**: `table`

#### `exports.wx_bridge:GetAllPlayers()`
Returns all online players.
- **Return Type**: `table`

#### `exports.wx_bridge:GetPlayerJob(id)`
Returns player's job.
- **Parameters**:
  - `id` (`number`): Player ID.
- **Return Type**: `string`

#### `exports.wx_bridge:GetPlayerJobGrade(id)`
Returns player's job grade number.
- **Parameters**:
  - `id` (`number`): Player ID.
- **Return Type**: `number`

#### `exports.wx_bridge:HasPermission(playerId)`
Returns boolean - check if player has one of the configured admin groups.
- **Parameters**:
  - `playerId` (`number`): Player ID.
- **Return Type**: `boolean`

#### `exports.wx_bridge:AddMoney(playerId, amount)`
Adds money to player. (with most frameworks to their inventory)
- **Parameters**:
  - `playerId` (`number`): Target player ID.
  - `amount` (`number`): Amount to add.

#### `exports.wx_bridge:RemoveMoney(playerId, amount)`
Removes money from player. (with most frameworks from their inventory)
- **Parameters**:
  - `playerId` (`number`): Target player ID.
  - `amount` (`number`): Amount to remove.

#### `exports.wx_bridge:RemoveBankMoney(playerId, amount)`
Removes money from player's bank.
- **Parameters**:
  - `playerId` (`number`): Target player ID.
  - `amount` (`number`): Amount to remove.

#### `exports.wx_bridge:GetMoney(playerId)`
Retrieves player's money (with most frameworks from their inventory)
- **Parameters**:
  - `playerId` (`number`): Target player ID.
- **Return Type**: `number`

#### `exports.wx_bridge:GetBankMoney(playerId)`
Retrieves player's money from bank
- **Parameters**:
  - `playerId` (`number`): Target player ID.
- **Return Type**: `number`

#### `exports.wx_bridge:TransferMoney(from, to, amount)`
Transfers bank money from one player to another
- **Parameters**:
  - `from` (`number`): Sender's ID.
  - `to` (`number`): Receiver's ID.
  - `amount` (`number`): Amount to transfer.
- **Return Type**: `boolean, string`

## Contributing
Contributions are welcome! If you have any suggestions or improvements, please submit a pull request or open an issue.

## License
WX Bridge is licensed under the MIT License. See the LICENSE file for more details.

## Support
If you encounter any issues, feel free to open an issue. Do not open issues with questions on how to use this.

