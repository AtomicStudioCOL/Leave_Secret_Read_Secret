--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UI scripts --
local _uiManager = nil;
local _readSecrets = nil
local _reportSecret = nil
local _reportComment = nil

-- buttons
--!Bind
local _quitButton : UIButton = nil
--!Bind
local _reportButton : UIButton = nil

-- scroll --
--!Bind
local _commentsScroll

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

-- tables --
local _commentsArray = {}

-- functions to be setted on client awake --
initialize = function() end

-- Create Text Labels UI
local _textSecret = "Loading secret!";

-- report functions
function reportCurrentSecret ()
    _uiManager.DeactiveActiveGameObject(nil, _reportSecret)
end

function reportPickedComment()
    _uiManager.DeactiveActiveGameObject(nil, _reportComment)
end

-- Set text Labels UI
_Panel:SetPrelocalizedText(" ")
_Container:SetPrelocalizedText(" ")
_scrollContainer:SetPrelocalizedText(" ")

_title:SetPrelocalizedText("Your random secret:")
_paragraph:SetPrelocalizedText(_textSecret)

_quitLabel:SetPrelocalizedText("X")

-- Add text to Button
_quitButton:Add(_quitLabel)

_reportButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportButton);
    reportCurrentSecret()
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _readSecrets)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager)

    _readSecrets = _uiManager:GetComponent(ReadSecrets)
    _reportSecret = _uiManager:GetComponent(ReportSecret)
    _reportComment = _uiManager:GetComponent(reportComment)

    -- functions called from another scripts --
    initialize = function()
        _EventManager.requestPlayerState:FireServer("currentSecret")
    end

    -- instantiate secrets buttons function --
    local function instantiateComments(i, comment)
        print(`{comment.id} secret was sent to instantiatereportCommentB function`)
        commentLabel = UILabel.new()
        reportCommentB = UIButton.new()
        commentLabel:AddToClassList("commentL")
        reportCommentB:AddToClassList("secretB")
        _commentsScroll:Add(commentLabel)
        commentLabel:Add(reportCommentB)
        commentLabel:SetPrelocalizedText(comment.text)

        reportCommentB:RegisterPressCallback(function()
            _uiManager.ButtonPress(reportComment)
            _EventManager.setPlayerState:FireServer("currentSecret", comment)
            _uiManager.DeactiveActiveGameObject(nil, _reportComment)
        end)
    end

    -- event receiver --
    _EventManager.requestPlayerState:Connect(function(currentSecret, requestedStateKey)
        if requestedStateKey ~= "currentSecret" then return end
        _textSecret = currentSecret.text
        _paragraph:SetPrelocalizedText(_textSecret)
        
        _EventManager.requestSecretsComments:FireServer(currentSecret.id)
    end)

    _EventManager.requestSecretsComments:Connect(function(commentsArray)
        table.clear(_commentsArray)
        if #commentsArray < 1 then
            _scrollContainer:SetPrelocalizedText("No comments yet!")
        else
            _scrollContainer:SetPrelocalizedText("")
        end
        for i, secret in ipairs(commentsArray) do
            commentsArray[i] = secret
            instantiateComments(i, commentLabel)
        end
    end)
end