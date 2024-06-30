--!Type(Client)

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")


--[[
-- recive text
function self:ClientStart()
    Chat.TextMessageReceivedHandler:Connect(function(channel, player, message)
        if channel.name == "General" then
            Chat:DisplayTextMessage(channel, player, message)
        end

        _EventManager.requestPlayerState:FireServer("secretChat")
        _EventManager.requestPlayerState:Connect(function(secretChat, requestedStateKey)
            print(`request player state event is arriving to chat manager client`)
            if requestedStateKey ~= "secretChat" then return end
            print(`requested key from chat manager client is {requestedStateKey}`)
            if secretChat then
                _EventManager.setPlayerState:FireServer("currentMessage", message)
                _EventManager.setText:FireServer("secret")
            end
        end)
        _EventManager.requestPlayerState:FireServer("commentChat")
        _EventManager.requestPlayerState:Connect(function(commentChat, requestedStateKey)
            if requestedStateKey ~= "commentChat" then return end
            print(`requested key from chat manager client is {requestedStateKey}`)
            if commentChat then
                _EventManager.setPlayerState:FireServer("currentMessage", message)
                _EventManager.setText:FireServer("comment")
            end
        end)
    end)
end
--]]
