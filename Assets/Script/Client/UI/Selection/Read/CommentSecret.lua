--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

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
local _textSecret = "Once I stole a cookie from the fridge. Mom still does not know. :c";

-- Set text Labels UI
_Container:SetPrelocalizedText(" ")

_paragraph:SetPrelocalizedText(_textSecret)

_title:SetPrelocalizedText("Cookie thief. qwq")

_quitLabel:SetPrelocalizedText("X")

_textInput:SetPrelocalizedText("This is a text placeholder. :3")

_sendLabel:SetPrelocalizedText("Send")

-- Add text to Button
_sendButton:Add(_sendLabel);
_quitButton:Add(_quitLabel)

_sendButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_sendButton, nil);
    _uiManager.DeactiveActiveGameObject(nil, _sendSecretConfirmation)
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton, nil);
    _uiManager.DeactiveActiveGameObject(self, _secretRandom)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");

    _secretRandom = _uiManager:GetComponent("SecretRanom")
    _sendSecretConfirmation = _uiManager:GetComponent("SendConfirmation")
end