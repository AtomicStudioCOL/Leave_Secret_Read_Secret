--!Type(ClientAndServer)

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")

-- Remote Functions --
local requireChatState = RemoteFunction.new("requireChatState")

-- client --
function self:ClientAwake()
    Chat.TextMessageReceivedHandler:Connect(function(channel, player, message)
        if channel.name == "General" then
            Chat:DisplayTextMessage(channel, player, message)
        else
            Chat:DisplayTextMessage(channel, player, message)
            requireChatState:InvokeServer(client.localPlayer, function(chatStates)
                if chatStates["secretChat"] == true then
                    _EventManager.setPlayerState:FireServer("currentMessage", message)
                    _EventManager.setText:FireServer("secret")
                elseif chatStates["commentChat"] == true then
                    _EventManager.setPlayerState:FireServer("currentMessage", message)
                    _EventManager.setText:FireServer("comment")
                end
            end)
        end
    end)
end

-- server --

function self:ServerAwake()
    -- tables
    chats = {}

    -- remote function return
    requireChatState.OnInvokeServer = function(localPlayer)
        local _chatStates = {}
        _chatStates["secretChat"] = _DataManager.requestPlayerState(localPlayer, "secretChat")
        _chatStates["commentChat"] = _DataManager.requestPlayerState(localPlayer, "commentChat")
        return _chatStates
    end

    -- activate secret chat and deactivate other chat
    function setSecretChat(player : Player)
        for k, channelContent in pairs(Chat.allChannels) do
            if channelContent.name == `{player.name}'s secret chat.` then
                --print(`{player.name} has been added to {channelContent.name} channel`)
                Chat:AddPlayerToChannel(channelContent, player)
            else
                Chat:RemovePlayerFromChannel(channelContent, player)
            end
        end
    end

    -- activate comment chat and deactivate other chat
    function setCommentChat(player : Player)
        for k, channelContent in pairs(Chat.allChannels) do
            if channelContent.name == `{player.name}'s comment chat.` then
                print(`{player.name} has been added to {channelContent.name} channel`)
                Chat:AddPlayerToChannel(channelContent, player)
            else
                Chat:RemovePlayerFromChannel(channelContent, player)
            end
        end
    end

    -- activate general chat and deactivate other chat
    function setGeneralChat(player : Player)
        for k, channelContent in pairs(Chat.allChannels) do
            if channelContent.name == `General` then
                --print(`{player.name} has been added to {channelContent.name} channel`)
                Chat:AddPlayerToChannel(channelContent, player)
            else
                Chat:RemovePlayerFromChannel(channelContent, player)
            end
        end
    end

        -- creting general chat --
        Chat:CreateChannel("General", true, false)

        -- event receivers --
        _EventManager.setChat:Connect(function(player : Player, chatToSet : string)
            if chatToSet == "Secret" then
                setSecretChat(player)
            elseif chatToSet == "Comment" then
                setCommentChat(player)
            elseif chatToSet == "General" then
                setGeneralChat(player)
            else
                error(`Chat to set not found. Expected 'Secret' ||'Comment' || 'General', got {chatToSet}}`)
            end
        end)

    server.PlayerConnected:Connect(function(player : Player)
        player.CharacterChanged:Connect(function()
            -- sets player to general channel --
            setGeneralChat(player)

            -- Create secret channel for player for current session
            chats[player.name] = Chat:CreateChannel(`{player.name}'s secret chat.`, true, false)
            chats[player.name] = Chat:CreateChannel(`{player.name}'s comment chat.`, true, false)

            -- Register player in data manager for current session
            _DataManager.playerState[player.name] = {}

            -- setting default player's data for current session
            _DataManager.setPlayerState(player.name, "secretChat", true)
            _DataManager.setPlayerState(player.name, "commentChat", false)
            _DataManager.setPlayerState(player.name, "currentMessage", "")

            -- checking if player is registered in "long term" database
            Storage.GetPlayerValue(player, "readTokens", function(readTokens)
                if readTokens == nil then
                    -- If read tokens is nil it means the player is new. Setting default values
                    Storage.SetPlayerValue(player, "readTokens", 10)
                    Storage.SetPlayerValue(player, "commentTokens", 5)
                    Storage.SetPlayerValue(player, "secrets", {})
                    Storage.SetPlayerValue(player, "readSecrets", {})
                    Storage.SetPlayerValue(player, "comments", {})
                    Storage.SetPlayerValue(player, "readComments", {})
                end
            end)
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
end