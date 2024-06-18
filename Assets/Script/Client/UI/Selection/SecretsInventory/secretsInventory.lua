--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- buttons
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _ySecretsButton :UIButton = nil
--!Bind
local _rSecretsButton :UIButton = nil

-- Select Labels UI
--!Bind
local _Container : UILabel = nil
--!Bind
local _title : UILabel = nil
--!Bind
local _Panel : UILabel = nil
--!Bind
local _ySecretsLabel : UILabel = nil
--!Bind
local _rSecretsLabel : UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

-- Set text Labels UI
_Container:SetPrelocalizedText(" ")
_Panel:SetPrelocalizedText(" ")

_title:SetPrelocalizedText("Secrets inventory")

_quitLabel:SetPrelocalizedText("X")

_ySecretsLabel:SetPrelocalizedText("Your secrets")

_rSecretsLabel:SetPrelocalizedText("Secrets read")

-- Add text to Button
_ySecretsButton:Add(_ySecretsLabel);
_rSecretsButton:Add(_rSecretsLabel);
_quitButton:Add(_quitLabel)

_ySecretsButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_ySecretsButton, nil);
end)

_rSecretsButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_rSecretsButton, nil);
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton, nil);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");
end