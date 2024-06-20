--!Type(Module)

-- Managers --
local _eventManager = require("EventManager")

-- tables --
playerState = {}

-- functions --

function requestPlayerState(player : Player, property)
    if property == nil then
        return playerState[player.name]
    else
        return playerState[player.name][property]
    end
end

function setPlayerState(playerName, property, value)
    playerState[playerName][property] = value
end

-- client to server events --
function self:ServerAwake()
    _eventManager.testStorage:Connect(function(player, key, value)
        Storage.SetValue(key, value)
        Storage.GetValue(key, function()
            _eventManager.testStorage:FireClient(player, key, value)
        end)
    end)

    _eventManager.requestPlayerState:Connect(function(player : Player, property)
        _eventManager.requestPlayerState:FireClient(player, requestPlayerState(player, property))
    end)

    _eventManager.setPlayerState:Connect(function(player : Player, property, value)
        setPlayerState(player.name, property, value)
    end)

    _eventManager.setText:Connect(function(player : Player)
        _eventManager.setText:FireClient(player, playerState[player.name].currentMessage)
    end)
end