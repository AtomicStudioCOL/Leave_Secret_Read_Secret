--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UIs --
local _uiManager = nil;
local _lobby = nil
local _secretSendConf = nil

-- scripts --
local _chatManager = nil
local _menssageText = nil

-- bools --
local _activateConf : boolean

-- buttons
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _sendButton :UIButton = nil

-- Select Labels UI
--!Bind
local _Container : UILabel = nil
--!Bind
local _title : UILabel = nil
--!Bind
local _paragraph : UILabel = nil
--!Bind
local _textInput : UILabel = nil
--!Bind
local _quitLabel : UILabel = nil
--!Bind
local _sendLabel : UILabel = nil

local textInputPlaceholder = "Type your secret in the chat. Don't worry! It won't display on other player's chat or over your avatar's head. You'll see your secret here once you send it. To edit it, type the secret again. If your secret is not getting registered, reboot the game."

-- Set text Labels UI
initialize = function() end

-- set secret's text --
function setSecretText(newText)
    _textInput:SetPrelocalizedText(newText)
    _menssageText = newText
end

-- Add text to Button
_sendButton:Add(_sendLabel)
_quitButton:Add(_quitLabel)

_sendButton:RegisterPressCallback(function() 
    -- Requests if there is any current message. Callback is in the event handler.
    _uiManager.ButtonPress(_sendButton)
    _activateConf = true
    _EventManager.requestPlayerState:FireServer("currentMessage")
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton)
    _uiManager.DeactiveActiveGameObject(self, _lobby);
    _EventManager.setChat:FireServer("General")
    _EventManager.setPlayerState:FireServer("secretChat", false)
    _EventManager.setPlayerState:FireServer("currentMessage", "")
end)

function self:ClientAwake()
    -- Access Modular Funtion --
    _uiManager = _UIManager:GetComponent(UIManager)

    -- Access Dependent UI --
    _lobby = _uiManager:GetComponent(Lobby)
    _secretSendConf = _uiManager:GetComponent(SecretSendConfirmation)

    -- functions --
    initialize = function()
        _Container:SetPrelocalizedText("")
        _title:SetPrelocalizedText("Leave a secret!")
        _paragraph:SetPrelocalizedText("Remember that secrets are anonymous but they will be reported if it goes against community guidelines. Please be respectful!")
        _quitLabel:SetPrelocalizedText("X")
        _textInput:SetPrelocalizedText(textInputPlaceholder)
        _sendLabel:SetPrelocalizedText("Send")
    end
    initialize()

    -- events --
    _EventManager.setText:Connect(function(newText)
        print(`text {newText} recived on {client.localPlayer.name}'s client.`)
        setSecretText(newText)
    end)

    _EventManager.requestPlayerState:Connect(function(currentMessage, requestedState)
        if requestedState ~= "currentMessage" then return end
        print(currentMessage)
        if currentMessage == "" or currentMessage == nil then
            _textInput:SetPrelocalizedText("No text yet! For leaving a secret, you need to actually type a secret!")
            Timer.After(3, function()
                if currentMessage == "" or currentMessage == nil then
                    _textInput:SetPrelocalizedText(textInputPlaceholder)                
                end
            end)
        elseif _activateConf == true then
            _activateConf = false
            _uiManager.DeactiveActiveGameObject(nil, _secretSendConf)
        end
    end) 
end