--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")

-- tables
chats = {}

-- activate secret chat and deactivate general chat
function setSecretChat(player : Player)
    print("secret chat activated")
    for k, channelContent in pairs(Chat.allChannels) do
        if channelContent.name == `{player.name}'s secret chat.` then
            Chat:AddPlayerToChannel(channelContent, player)
        else
            Chat:RemovePlayerFromChannel(channelContent, player)
        end
    end
end

-- activate general chat and deactivate secret chat
function setGeneralChat(player : Player)
    print("general chat activated")
    for k, channelContent in pairs(Chat.allChannels) do
        if channelContent.name == `General` then
            Chat:AddPlayerToChannel(channelContent, player)
        else
            Chat:RemovePlayerFromChannel(channelContent, player)
        end
    end
end

-- Create secret channel for player
server.PlayerConnected:Connect(function(player : Player)
    player.CharacterChanged:Connect(function()
        chats[player.name] = Chat:CreateChannel(`{player.name}'s secret chat.`, true, false)
    end)
end)

-- event receivers --
_EventManager.setChat:Connect(function(player : Player, chatToSet : string)
    if chatToSet == "Secret" then
        setSecretChat(player)
    elseif chatToSet == "General" then
        setGeneralChat(player)
    else
        error(`Chat to set not found. Expected 'Secret' or 'General', got {chatToSet}}`)
    end
end)