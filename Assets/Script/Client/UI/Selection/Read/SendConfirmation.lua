--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for scripts --
local _uiManager = nil;
local _secretRandom = nil
local _commentSecret = nil
local _sentFeedback = nil

-- strings --
local _currentMessage

-- bools --
local _canSend
local _canNewComment

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
_cancelLabel:SetPrelocalizedText("X")
_sendLabel:SetPrelocalizedText("✓")

_cancelButton:Add(_cancelLabel)
_sendButton:Add(_sendLabel)


_cancelLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_cancelLabel, nil);
    _uiManager.DeactiveActiveGameObject(self, nil)
    _EventManager.setPlayerState:FireServer("currentMessage", "")
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager);

    _secretRandom = _uiManager:GetComponent(SecretRandom)
    _commentSecret = _uiManager:GetComponent(CommentSecret)
    _sentFeedback = _uiManager:GetComponent(SentFeedback)

    -- Send button
    _sendButton:RegisterPressCallback(function()
        _uiManager.ButtonPress(_sendButton)
        _commentSecret.sendComment()
        _secretRandom.refreshTokens()
        _uiManager.DeactiveActiveGameObject(self, _sentFeedback)
        Timer.After(3, function()
            _EventManager.setPlayerState:FireServer("currentMessage", "")    
            _uiManager.DeactiveActiveGameObject(_sentFeedback, nil)
            _uiManager.DeactiveActiveGameObject(_commentSecret, _secretRandom)
            _EventManager.setChat:FireServer("General")
        end)
    end)
end