--!Type(Client)

-- Managers --
local _EventManager = require("EventManager")

-- variables --
local _localPlayer = client.localPlayer

-- recive text
Chat.TextMessageReceivedHandler:Connect(function(channel, player, message)
    --[[ debugging
    if channel.name == `{_localPlayer.name}'s secret chat.` then
        print("Secret channel active")
    else
        print("general channel active")
    end
    --]]

    Chat:DisplayTextMessage(channel, player, message)

    _EventManager.requestPlayerState:FireServer("secretChat")
    _EventManager.requestPlayerState:Connect(function(secretChat)
        if secretChat then
            _EventManager.setPlayerState:FireServer("currentMessage", message)
            _EventManager.setText:FireServer()
        end
    end)
end)