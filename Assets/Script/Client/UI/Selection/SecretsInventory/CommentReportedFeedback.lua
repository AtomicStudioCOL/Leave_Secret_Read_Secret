--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- Select Labels UI
--!Bind
local _PanelReportSecret : UILabel = nil
--!Bind
local _reportedFeedback : UILabel = nil

_PanelReportSecret:SetPrelocalizedText(" ")
_reportedFeedback:SetPrelocalizedText("Comment reported for moderation. It'll be hidden after three reports.")

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager);
end