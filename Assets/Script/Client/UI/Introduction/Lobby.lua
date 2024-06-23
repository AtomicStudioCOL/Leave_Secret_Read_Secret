--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UIs --
local _uiManager = nil;
local _leaveSecretUi = nil
local _secretsInventoryUi = nil
local _readSecretUi = nil

-- scripts --
local _chatManager = nil

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

_PanelLobby:SetPrelocalizedText(" ")
_YourSecrectLabel:SetPrelocalizedText("YOUR SECRETS")
_LeaveSecrectLabel:SetPrelocalizedText("LEAVE A SECRET")
_ReadSecrectLabel:SetPrelocalizedText("READ A SECRET")

-- Add text to Button
_YourSecrectButton:Add(_YourSecrectLabel);
_ReadSecrectButton:Add(_ReadSecrectLabel);
_LeaveSecrectButton:Add(_LeaveSecrectLabel);

_LeaveSecrectLabel:AddToClassList("textlabel")
_YourSecrectLabel:AddToClassList("textlabel")
_ReadSecrectLabel:AddToClassList("textlabel")

_YourSecrectButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_YourSecrectButton);
    _uiManager.DeactiveActiveGameObject(self, _secretsInventoryUi);
end)

_LeaveSecrectButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_LeaveSecrectButton);
    _uiManager.DeactiveActiveGameObject(self, _leaveSecretUi);
    _leaveSecretUi.setDefaultTexts()
    _EventManager.setChat:FireServer("Secret")
    _EventManager.setPlayerState:FireServer("secretChat", true)
end)


function self:ClientAwake()
    
    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent(UIManager);
    
    -- Access Dependent UI
    _leaveSecretUi = _uiManager:GetComponent(LeaveSecret)
    _secretsInventoryUi = _uiManager:GetComponent(secretsInventory)
    _readSecretUi = _uiManager:GetComponent(ReadSecretUI)
    
    -- callback --
    _ReadSecrectButton:RegisterPressCallback(function()
        _uiManager.ButtonPress(_ReadSecrectButton);
        _uiManager.DeactiveActiveGameObject(self, _readSecretUi);
        _readSecretUi.initialize()
    end)
end