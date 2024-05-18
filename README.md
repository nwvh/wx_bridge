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


## Contributing
Contributions are welcome! If you have any suggestions or improvements, please submit a pull request or open an issue.

## License
WX Bridge is licensed under the MIT License. See the LICENSE file for more details.

## Support
If you encounter any issues, feel free to open an issue. Do not open issues with questions on how to use this.

