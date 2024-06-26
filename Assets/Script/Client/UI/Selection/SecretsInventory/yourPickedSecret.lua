--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for gamemanager
local _uiManager = nil;
local _yourSecrets = nil
local _reportComment = nil

-- buttons
--!Bind
local _quitButton :UIButton = nil

-- scroll --
--!Bind
local _commentsScroll : UIScrollView = nil

-- tables --
local _commentsArray = {}

-- functions to be setted on client awake --
initialize = function() end

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
local _quitLabel : UILabel = nil

-- Create Text Labels UI
local _textSecret = "Once I stole a cookie from the fridge. Mom still does not know. :c";

-- Set text Labels UI
_Panel:SetPrelocalizedText(" ")
_Container:SetPrelocalizedText(" ")
_scrollContainer:SetPrelocalizedText(" ")

_title:SetPrelocalizedText("Your secret:")
_paragraph:SetPrelocalizedText(_textSecret)

_quitLabel:SetPrelocalizedText("X")

-- Add text to Button
_quitButton:Add(_quitLabel)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _yourSecrets);
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager)

    _yourSecrets = _uiManager:GetComponent(YourSecrets)
    _reportComment = _uiManager:GetComponent(reportComment)

    -- functions called from another scripts --
    initialize = function()
        _EventManager.requestPlayerState:FireServer("currentSecret")
    end

    -- instantiate secrets buttons function --
    local function instantiateComments(i, comment)
        commentLabel = UILabel.new()
        reportCommentB = UIButton.new()
        commentLabel:Add(reportCommentB)
        commentLabel:SetPrelocalizedText(comment.text)
        commentLabel:AddToClassList("commentL")
        reportCommentB:AddToClassList("reportB")
        print(`{_commentsScroll}`)
        _commentsScroll:Add(commentLabel)

        reportCommentB:RegisterPressCallback(function()
            _uiManager.ButtonPress(reportCommentB)
            _uiManager.DeactiveActiveGameObject(nil, _reportComment)
            _reportComment.initialize(comment)
        end)
    end

    -- event receiver --
    _EventManager.requestPlayerState:Connect(function(currentSecret, requestedStateKey)
        if requestedStateKey ~= "currentSecret" then return end
        _EventManager.requestSecretsComments:FireServer(currentSecret.id)
        _textSecret = currentSecret.text
        _paragraph:SetPrelocalizedText(_textSecret)
    end)

    _EventManager.requestSecretsComments:Connect(function(commentsArray)
        table.clear(_commentsArray)
        _commentsScroll:Clear()
        if #commentsArray < 1 then
            _scrollContainer:SetPrelocalizedText("No comments yet!")
        else
            _scrollContainer:SetPrelocalizedText("")
        end
        for i, comment in ipairs(commentsArray) do
            _commentsArray[i] = comment
            instantiateComments(i, comment)
        end
        print(`comments received: {#_commentsArray}`)
    end)
end