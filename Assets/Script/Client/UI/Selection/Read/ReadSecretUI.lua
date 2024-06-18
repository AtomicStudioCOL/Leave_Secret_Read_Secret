--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- buttons
--!Bind
local _ReadSecretButton : UIButton = nil
--!Bind
local _quitButton :UIButton = nil

-- Select Labels UI
--!Bind
local _PanelReadSecret : UILabel = nil
--!Bind
local _ReadSecretText : UILabel = nil
--!Bind
local _ReadSecretLabel : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

-- Create Text Labels UI
local _textReadSecret = "You have 5 read tokens and 1 comment token";

-- Set text Labels UI

_PanelReadSecret:SetPrelocalizedText(" ")

_ReadSecretText:SetPrelocalizedText(_textReadSecret)

_ReadSecretLabel:SetPrelocalizedText("Read Secrets")

_title:SetPrelocalizedText("Read a secret!")

_quitLabel:SetPrelocalizedText("X")

-- Set Class

_PanelReadSecret:AddToClassList("Panel");

_ReadSecretText:AddToClassList("ReadSecretText");

-- Add text to Button
_ReadSecretButton:Add(_ReadSecretLabel);

_ReadSecretButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_ReadSecretButton, nil);
    -- _uiManager.DeactiveActiveGameObject(self);
end)

_quitLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitLabel, nil);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");
end