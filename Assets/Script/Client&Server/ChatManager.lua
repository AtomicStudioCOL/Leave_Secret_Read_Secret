--!Type(ClientAndServer)

-- events for debugging --
local playerChannel

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")
--!SerializeField
local _uiManager : GameObject = nil

-- UI's scripts --
local _leaveSecret = nil
local _commentSecret = nil


local _chatSecret = nil;
local _chatComment = nil;
local _chatGeneral = nil;

-- client --
function self:ClientStart()
    -- setting UI scripts --
    _leaveSecret = _uiManager:GetComponent(LeaveSecret)
    _commentSecret = _uiManager:GetComponent(CommentSecret)

    Chat.TextMessageReceivedHandler:Connect(function(channel, player, message)
        
        if channel.name == "All" then
            Chat:DisplayTextMessage(channel, player, `{message}`)
        elseif channel.name == `{player.name}'s secret chat.` then
            _leaveSecret.setSecretText(message)
        elseif channel.name == `{player.name}'s comment chat.` then
            _commentSecret.setSecretText(message)
        end

    end)
end

-- server --

function self:ServerStart()
    -- tables
    chats = {}

    -- activate secret chat and deactivate other chat
    function setSecretChat(player : Player)
        for k, channelContent in pairs(Chat.allChannels) do
            if channelContent.name == `{player.name}'s secret chat.` then
                print(`{player.name} has been added to {channelContent.name} channel`)
                Chat:AddPlayerToChannel(channelContent, player)
            else
                Chat:RemovePlayerFromChannel(channelContent, player)
            end
        end

        Chat:RemovePlayerFromChannel(_chatGeneral,  player)
        Chat:RemovePlayerFromChannel(_chatComment,  player)
        Chat:AddPlayerToChannel(_chatSecret, player)
        
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
                if channelContent.name == `All` then
                    print(`{player.name} has been added to {channelContent.name} channel`)
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
            -- Create secret channel for player for current session

            _chatSecret = Chat:CreateChannel(`{player.name}'s secret chat.`, true, false, 0);
            _chatComment = Chat:CreateChannel(`{player.name}'s comment chat.`, true, false, 0);
            _chatGeneral = Chat:CreateChannel("All", true, false, 0);

            chats[player.name] = _chatSecret;
            chats[player.name] = _chatComment;

            -- sets player to general channel --
		    Chat:AddPlayerToChannel(_chatSecret, player)
		    Chat:AddPlayerToChannel(_chatComment, player)

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