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

    if channel.name == "General" then
        Chat:DisplayTextMessage(channel, player, message)
    end

    _EventManager.requestPlayerState:FireServer("secretChat")
    _EventManager.requestPlayerState:Connect(function(secretChat, requestedStateKey)
        if requestedStateKey ~= "secretChat" then return end
        if secretChat then
            _EventManager.setPlayerState:FireServer("currentMessage", message)
            _EventManager.setText:FireServer("secret")
        end
    end)
    _EventManager.requestPlayerState:FireServer("commentChat")
    _EventManager.requestPlayerState:Connect(function(commentChat, requestedStateKey)
        if requestedStateKey ~= "commentChat" then return end
        if commentChat then
            _EventManager.setPlayerState:FireServer("currentMessage", message)
            _EventManager.setText:FireServer("comment")
        end
    end)
end)