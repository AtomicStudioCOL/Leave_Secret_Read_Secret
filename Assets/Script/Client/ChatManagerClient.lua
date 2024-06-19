--!Type(Client)

-- variables --
local _localPlayer = client.localPlayer

-- recive text
Chat.TextMessageReceivedHandler:Connect(function(channel, player, message)
    if channel.name == `{_localPlayer.name}'s secret chat.` then
        print("Secret channel active")
    else
        print("general channel active")
    end
    Chat:DisplayTextMessage(channel, _localPlayer, message)
end)