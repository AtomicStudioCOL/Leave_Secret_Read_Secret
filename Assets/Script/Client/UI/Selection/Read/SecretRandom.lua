--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil
local _reportSecret = nil
local _commentSecret = nil

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
local _readToken = 1
local _commentToken = 4

-- Set text Labels UI
_CommentingIcon:SetPrelocalizedText(" ")
_CommentingCount:SetPrelocalizedText(`{_readToken}`)
_CommentLabel:SetPrelocalizedText("Comment")

_PanelSecret:SetPrelocalizedText(" ")

_readingIcon:SetPrelocalizedText(" ")
_readingCount:SetPrelocalizedText(`{_commentToken}`)

_SecretText:SetPrelocalizedText(_textSecret)

_title:SetPrelocalizedText("Cookie thief. qwq")

_tokensContainer:SetPrelocalizedText(" ")

_quitLabel:SetPrelocalizedText("X")

-- Add text to Button
_CommentButton:Add(_CommentLabel);

_CommentButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_CommentButton);
    _uiManager.DeactiveActiveGameObject(self, _commentSecret)
    _commentSecret.setDefaultTexts()
    _EventManager.setChat:FireServer("Secret")
    _EventManager.setPlayerState:FireServer("secretChat", true)
end)

_reportButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportButton);
    _uiManager.DeactiveActiveGameObject(self, _reportSecret)
end)

_quitLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitLabel);
    _uiManager.DeactiveActiveGameObject(self, _commentSecret)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager);

    _lobby = _uiManager:GetComponent(Lobby)
    _reportSecret = _uiManager:GetComponent(ReportSecret)
    _commentSecret = _uiManager:GetComponent(CommentSecret)
end