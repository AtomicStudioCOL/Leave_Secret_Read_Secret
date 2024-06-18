--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;

-- buttons
--!Bind
local _CommentButton : UIButton = nil
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _reportButton :UIButton = nil

-- Select Labels UI
--!Bind
local _CommentingIcon : UILabel = nil
--!Bind
local _CommentLabel : UILabel = nil
--!Bind
local _CommentingCount : UILabel = nil
--!Bind
local _PanelSecret : UILabel = nil
--!Bind
local _SecretText : UILabel = nil
--!Bind
local _readingIcon : UILabel = nil
--!Bind
local _readingCount : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _tokensContainer :UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

-- Create Text Labels UI
local _textSecret = "Once I stole a cookie from the fridge. Mom still does not know. :c";
local _countC = "1"
local _countR = "4"

-- Set text Labels UI
_CommentingIcon:SetPrelocalizedText(" ")
_CommentingCount:SetPrelocalizedText(_countC)
_CommentLabel:SetPrelocalizedText("Comment")

_PanelSecret:SetPrelocalizedText(" ")

_readingIcon:SetPrelocalizedText(" ")
_readingCount:SetPrelocalizedText(_countR)

_SecretText:SetPrelocalizedText(_textSecret)

_title:SetPrelocalizedText("Cookie thief. qwq")

_tokensContainer:SetPrelocalizedText(" ")

_quitLabel:SetPrelocalizedText("X")

-- Set Class

_PanelSecret:AddToClassList("Panel");

_SecretText:AddToClassList("SecretText");

-- Add text to Button
_CommentButton:Add(_CommentLabel);

_CommentButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_CommentButton, nil);
    -- _uiManager.DeactiveActiveGameObject(self);
end)

_quitLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitLabel, nil);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");
end