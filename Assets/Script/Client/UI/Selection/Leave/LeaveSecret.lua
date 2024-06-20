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

local textInputPlaceholder = "Type your secret in the chat. Don't worry! It won't display on other player's chat or over your avatar's head. You'll see your secret here once you send it. To edit it, type the secret again."

-- Set text Labels UI
function setDefaultTexts()
    _Container:SetPrelocalizedText("")
    _title:SetPrelocalizedText("Leave a secret!")
    _paragraph:SetPrelocalizedText("Remember that secrets are anonymous but they will be reported if it goes against community guidelines. Please be respectful!")
    _quitLabel:SetPrelocalizedText("X")
    _textInput:SetPrelocalizedText(textInputPlaceholder)
    _sendLabel:SetPrelocalizedText("Send")
end

setDefaultTexts()

-- set secret's text --
function setSecretText(newText)
    _textInput:SetPrelocalizedText(newText)
end

-- Add text to Button
_sendButton:Add(_sendLabel);
_quitButton:Add(_quitLabel)

_sendButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_sendButton);
    _uiManager.DeactiveActiveGameObject(nil, _secretSendConf);
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _lobby);
    _EventManager.setChat:FireServer("General")
    _EventManager.setPlayerState:FireServer("secretChat", false)
end)

function self:ClientAwake()
    -- Access Modular Funtion --
    _uiManager = _UIManager:GetComponent(UIManager);

    -- Access Dependent UI --
    _lobby = _uiManager:GetComponent(Lobby)
    _secretSendConf = _uiManager:GetComponent(SecretSendConfirmation)

    -- events --
    _EventManager.setText:Connect(function(newText)
        setSecretText(newText)
    end)
end