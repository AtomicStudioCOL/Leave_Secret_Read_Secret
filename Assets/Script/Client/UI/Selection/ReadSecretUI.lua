--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- Select Labels UI
--!Bind
local _PanelReadSecret : UILabel = nil

--!Bind
local _ReadSecretText : UILabel = nil

--!Bind
local _ReadSecretButton : UILabel = nil

--!Bind
local _ReadSecretLabel : UILabel = nil


-- Create Text Labels UI
local _textReadSecret = "You have 5 read in solane and 1 connversation";

-- Set text Labels UI

_PanelReadSecret:SetPrelocalizedText(" ", true)

_ReadSecretText:SetPrelocalizedText(_textReadSecret, true)

_ReadSecretLabel:SetPrelocalizedText("Read Secrets", true)

-- Set Class

_PanelReadSecret:AddToClassList("Panel");

_ReadSecretText:AddToClassList("ReadSecretText");

-- Add text to Button
_ReadSecretButton:Add(_ReadSecretLabel);

_ReadSecretButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_ReadSecretButton);
    -- _uiManager.DeactiveActiveGameObject(self);
end)

function self:ClientAwake()

    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent("UIManager");
        
end