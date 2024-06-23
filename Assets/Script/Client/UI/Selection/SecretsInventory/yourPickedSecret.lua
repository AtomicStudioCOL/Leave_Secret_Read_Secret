--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;
local _yourSecrets = nil
local _reportComment = nil

-- buttons
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _reportBPH1 :UIButton = nil
--!Bind
local _reportBPH2 :UIButton = nil
--!Bind
local _reportBPH3 :UIButton = nil
--!Bind
local _reportBPH4 :UIButton = nil
--!Bind
local _reportBPH5 :UIButton = nil

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
local _paragraph : UILabel = nil
--!Bind
local _commentLPH1 : UILabel = nil
--!Bind
local _commentLPH2 : UILabel = nil
--!Bind
local _commentLPH3 : UILabel = nil
--!Bind
local _commentLPH4 : UILabel = nil
--!Bind
local _commentLPH5 : UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

-- Create Text Labels UI
local _textSecret = "Once I stole a cookie from the fridge. Mom still does not know. :c";

-- report comment function
function reportSelectedComment()
    _uiManager.DeactiveActiveGameObject(nil, _reportComment);
end

-- Set text Labels UI
_Panel:SetPrelocalizedText(" ")
_Container:SetPrelocalizedText(" ")
_scrollContainer:SetPrelocalizedText(" ")

_title:SetPrelocalizedText("Cookie thief. qwq")
_paragraph:SetPrelocalizedText(_textSecret)

_quitLabel:SetPrelocalizedText("X")

_commentLPH1:SetPrelocalizedText("comment 1")
_commentLPH2:SetPrelocalizedText("comment 2")
_commentLPH3:SetPrelocalizedText("comment 3")
_commentLPH4:SetPrelocalizedText("comment 4")
_commentLPH5:SetPrelocalizedText("comment 5")

_commentLPH1:Add(_reportBPH1)
_commentLPH2:Add(_reportBPH2)
_commentLPH3:Add(_reportBPH3)
_commentLPH4:Add(_reportBPH4)
_commentLPH5:Add(_reportBPH5)

-- Add text to Button
_quitButton:Add(_quitLabel)

_reportBPH1:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportBPH1);
    reportSelectedComment()
end)

_reportBPH2:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportBPH2);
    reportSelectedComment()
end)

_reportBPH3:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportBPH3);
    reportSelectedComment()
end)

_reportBPH4:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportBPH4);
    reportSelectedComment()
end)

_reportBPH5:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportBPH5);
    reportSelectedComment()
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _yourSecrets);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");

    _yourSecrets = _uiManager:GetComponent("YourSecrets")
    _reportComment = _uiManager:GetComponent("reportComment")
end