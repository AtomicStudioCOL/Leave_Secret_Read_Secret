--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- buttons
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _secretBPH1 :UIButton = nil
--!Bind
local _secretBPH2 :UIButton = nil
--!Bind
local _secretBPH3 :UIButton = nil
--!Bind
local _secretBPH4 :UIButton = nil
--!Bind
local _secretBPH5 :UIButton = nil

-- Select Labels UI
--!Bind
local _Panel : UILabel = nil
--!Bind
local _Container : UILabel = nil
--!Bind
local _scrollContainer : UILabel = nil
--!Bind
local _title : UILabel = nil
--!Bind
local _secretLPH1 : UILabel = nil
--!Bind
local _secretLPH2 : UILabel = nil
--!Bind
local _secretLPH3 : UILabel = nil
--!Bind
local _secretLPH4 : UILabel = nil
--!Bind
local _secretLPH5 : UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

-- Set text Labels UI
_Panel:SetPrelocalizedText(" ")
_Container:SetPrelocalizedText(" ")
_scrollContainer:SetPrelocalizedText(" ")

_title:SetPrelocalizedText("Your secrets")

_quitLabel:SetPrelocalizedText("X")

_secretLPH1:SetPrelocalizedText("Secret 1")
_secretLPH2:SetPrelocalizedText("Secret 2")
_secretLPH3:SetPrelocalizedText("Secret 3")
_secretLPH4:SetPrelocalizedText("Secret 4")
_secretLPH5:SetPrelocalizedText("Secret 5")

-- Add text to Button
_secretBPH1:Add(_secretLPH1)
_secretBPH2:Add(_secretLPH2)
_secretBPH3:Add(_secretLPH3)
_secretBPH4:Add(_secretLPH4)
_secretBPH5:Add(_secretLPH5)
_quitButton:Add(_quitLabel)

_secretBPH1:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_secretBPH1, nil);
end)

_secretBPH2:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_secretBPH2, nil);
end)

_secretBPH3:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_secretBPH3, nil);
end)

_secretBPH4:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_secretBPH4, nil);
end)

_secretBPH5:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_secretBPH5, nil);
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton, nil);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");
end