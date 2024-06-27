--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- Select Labels UI
--!Bind
local _Panel : UILabel = nil
--!Bind
local _text : UILabel = nil

_Panel:SetPrelocalizedText(" ")

_text:SetPrelocalizedText("Comment sent!")

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager);
end