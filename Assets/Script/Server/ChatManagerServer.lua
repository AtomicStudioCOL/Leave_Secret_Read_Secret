--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")

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

server.PlayerConnected:Connect(function(player : Player)
    player.CharacterChanged:Connect(function()
        -- Create secret channel for player for current session
        chats[player.name] = Chat:CreateChannel(`{player.name}'s secret chat.`, true, false)

        -- Register player in data manager for current session
        _DataManager.playerState[player.name] = {}

        -- setting default player's data for current session
        _DataManager.setPlayerState(player.name, "secretChat", false)
        _DataManager.setPlayerState(player.name, "currentMessage", "")

        -- checking if player is registered in "long term" database
        local _hasAnyTokens = nil
        _hasAnyTokens = _DataManager.requestStoragePlayerData(player, "readTokens")
        if _hasAnyTokens == nil then
            _DataManager.setStoragePlayerData(player, "readTokens", 0)
        end
    end)
end)

server.PlayerDisconnected:Connect(function(player : Player)
    player.CharacterChanged:Connect(function()
        -- Delete secret channel for player for current session
        Chat:DestroyChannel(chats[player.name])

        -- Deletes player in data manager for current session
        _DataManager.playerState[player.name] = nil

    end)
end)