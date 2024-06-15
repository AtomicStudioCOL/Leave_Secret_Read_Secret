--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- Select Labels UI
--!Bind
local _PanelLobby : UILabel = nil

--!Bind
local _YourSecrectButton : UILabel = nil

--!Bind
local _YourSecrectLabel : UILabel = nil

--!Bind
local _LeaveSecrectButton : UILabel = nil

--!Bind
local _LeaveSecrectLabel : UILabel = nil

--!Bind
local _ReadSecrectButton : UILabel = nil

--!Bind
local _ReadSecrectLabel : UILabel = nil

-- Set text Labels UI

_PanelLobby:SetPrelocalizedText(" ", true)

_YourSecrectLabel:SetPrelocalizedText("Your Secret", true)

_LeaveSecrectLabel:SetPrelocalizedText("Leave Secret", true)

_ReadSecrectLabel:SetPrelocalizedText("Read Secret", true)

-- Set Class
_PanelLobby:AddToClassList("Panel");
_YourSecrectButton:AddToClassList("ButtonCenter")
_ReadSecrectButton:AddToClassList("ButtonRight")
_LeaveSecrectButton:AddToClassList("ButtonLeft")

-- Add text to Button
_YourSecrectButton:Add(_YourSecrectLabel);
_ReadSecrectButton:Add(_ReadSecrectLabel);
_LeaveSecrectButton:Add(_LeaveSecrectLabel);

_YourSecrectButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_YourSecrectButton);

end)

_LeaveSecrectButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_LeaveSecrectButton);

end)

_ReadSecrectButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_ReadSecrectButton);

end)

function self:ClientAwake()

    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent("UIManager");
        
end