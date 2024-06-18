--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

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
    _uiManager.ButtonPress(_ReportSecretButton, nil);
end)

_cancelLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_cancelLabel, nil);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");
end