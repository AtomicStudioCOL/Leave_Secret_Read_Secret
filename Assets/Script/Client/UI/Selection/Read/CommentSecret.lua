--!Type(UI)

-- Manager --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for gamemanager
local _uiManager = nil;
local _secretRandom = nil
local _sendSecretConfirmation = nil

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

-- Create Text Labels UI
local _textSecret = "Type your secret in the chat. Don't worry! It won't display on other player's chat or over your avatar's head. You'll see your secret here once you send it. To edit it, type the secret again."

-- Set text Labels UI
function setDefaultTexts()
    _Container:SetPrelocalizedText(" ")
    _paragraph:SetPrelocalizedText(_textSecret)
    _title:SetPrelocalizedText("Cookie thief. qwq")
    _quitLabel:SetPrelocalizedText("X")
    _textInput:SetPrelocalizedText("This is a text placeholder. :3")
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
    _uiManager.DeactiveActiveGameObject(nil, _sendSecretConfirmation)
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _secretRandom)
    _EventManager.setChat:FireServer("General")
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager);

    _secretRandom = _uiManager:GetComponent(SecretRandom)
    _sendSecretConfirmation = _uiManager:GetComponent(SendConfirmation)

    -- events --
    _EventManager.setText:Connect(function(newText)
        setSecretText(newText)
    end)
end