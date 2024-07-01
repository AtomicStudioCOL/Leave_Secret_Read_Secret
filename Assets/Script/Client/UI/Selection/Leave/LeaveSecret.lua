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

local _textInputPlaceholder = "Type your secret in the chat. Don't worry! It won't display on other player's chat or over your avatar's head. You'll see your secret here once you send it. To edit it, type the secret again. If your secret is not getting registered, reboot the game."
local _textNoText = "No text yet! For leaving a secret, you need to actually type a secret!"

-- Set text Labels UI
initialize = function() end

-- set secret's text --
function setSecretText(newText)
    _menssageText = newText
    _textInput:SetPrelocalizedText(newText)
end

-- function to send new secret
function sendSecret()
    _EventManager.newSecret:FireServer(_textInput.text)
    _EventManager.setStoragePlayerData:FireServer("readTokens", 5)
end

-- Add text to Button
_sendButton:Add(_sendLabel)
_quitButton:Add(_quitLabel)

_sendButton:RegisterPressCallback(function() 
    -- Requests if there is any current message. Callback is in the event handler.
    _uiManager.ButtonPress(_sendButton)

    if _textInput.text == _textInputPlaceholder or _textInput.text == _textNoText then
        _textInput:SetPrelocalizedText(_textNoText)
        Timer.After(3, function()
            if _textInput.text == _textInputPlaceholder or _textInput.text == _textNoText then
                _textInput:SetPrelocalizedText(_textInputPlaceholder)                
            end
        end)
    else
        _uiManager.DeactiveActiveGameObject(nil, _secretSendConf)
    end
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton)
    _uiManager.DeactiveActiveGameObject(self, _lobby);
    _EventManager.setChat:FireServer("General")
end)

function self:ClientStart()
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
        _textInput:SetPrelocalizedText(_textInputPlaceholder)
        _sendLabel:SetPrelocalizedText("Send")
    end
    initialize()
end