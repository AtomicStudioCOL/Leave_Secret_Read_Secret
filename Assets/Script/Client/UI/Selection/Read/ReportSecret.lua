--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil
local _secretRandom = nil
local _readPickedSecret = nil
local _reportedFeedback = nil

-- buttons
--!Bind
local _ReportSecretButton : UIButton = nil
--!Bind
local _cancelButton :UIButton = nil

-- Select Labels UI
--!Bind
local _PanelReportSecret : UILabel = nil
--!Bind
local _ReportSecretText : UILabel = nil
--!Bind
local _paragraph : UILabel = nil
--!Bind
local _ReportSecretLabel : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _cancelLabel : UILabel = nil

-- Set text Labels UI

_PanelReportSecret:SetPrelocalizedText(" ")

_ReportSecretText:SetPrelocalizedText(" ")

_paragraph:SetPrelocalizedText("Is this secret against community guidelines?")

_title:SetPrelocalizedText("Report secret?")

_cancelButton:Add(_cancelLabel)
_cancelLabel:SetPrelocalizedText("X")
_ReportSecretButton:Add(_ReportSecretLabel)
_ReportSecretLabel:SetPrelocalizedText("✓")

-- Set Class

_PanelReportSecret:AddToClassList("Panel");

-- Add text to Button
_ReportSecretButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_ReportSecretButton);
    _uiManager.DeactiveActiveGameObject(self, _reportedFeedback)
    _uiManager.DeactiveActiveGameObject(_readPickedSecret, nil)
    _uiManager.DeactiveActiveGameObject(_secretRandom, nil)

    Timer.After(3, function()
        _uiManager.DeactiveActiveGameObject(_reportedFeedback, _lobby)
    end)
end)

_cancelLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_cancelLabel);
    _uiManager.DeactiveActiveGameObject(self, nil)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");

    _lobby = _uiManager:GetComponent("Lobby")
    _secretRandom = _uiManager:GetComponent("SecretRandom")
    _readPickedSecret = _uiManager:GetComponent("ReadPickedSecret")
    _reportedFeedback = _uiManager:GetComponent("ReprotedFeedback")
end