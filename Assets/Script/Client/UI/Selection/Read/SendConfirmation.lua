--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil
local _commentSecret = nil
local _sentFeedback = nil

-- buttons
--!Bind
local _sendButton : UIButton = nil
--!Bind
local _cancelButton :UIButton = nil

-- Select Labels UI
--!Bind
local _Panel : UILabel = nil
--!Bind
local _Container : UILabel = nil
--!Bind
local _paragraph : UILabel = nil
--!Bind
local _sendLabel : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _cancelLabel : UILabel = nil

-- Set text Labels UI

_Panel:SetPrelocalizedText(" ")

_Container:SetPrelocalizedText(" ")

_paragraph:SetPrelocalizedText("You won't be able to edit this comment in the future.")

_title:SetPrelocalizedText("Send?")

_cancelButton:Add(_cancelLabel)
_cancelLabel:SetPrelocalizedText("X")
_sendButton:Add(_sendLabel)
_sendLabel:SetPrelocalizedText("✓")

-- Add text to Button
_sendButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_sendButton, nil);
    _uiManager.DeactiveActiveGameObject(self, _sentFeedback)

    Timer.After(2, function()
        _uiManager.DeactiveActiveGameObject(_sentFeedback, _lobby)
        _uiManager.DeactiveActiveGameObject(_commentSecret, nil)
    end)
end)

_cancelLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_cancelLabel, nil);
    _uiManager.DeactiveActiveGameObject(self, nil)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent("UIManager");

    _lobby = _uiManager:GetComponent("Lobby")
    _commentSecret = _uiManager:GetComponent("CommentSecret")
    _sentFeedback = _uiManager:GetComponent("SentFeedback")
end