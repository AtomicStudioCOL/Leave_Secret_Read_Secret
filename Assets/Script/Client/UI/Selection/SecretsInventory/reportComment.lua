--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UI scripts --
local _uiManager = nil
local _commentReportedFeedback = nil
local _yourPickedSecret = nil

-- buttons
--!Bind
local _ReportCommentButton : UIButton = nil
--!Bind
local _cancelButton :UIButton = nil

-- secret id --
local _commentToReportId = nil

-- functions to be set on client awake --
initialize = function() end

-- Select Labels UI
--!Bind
local _Panel : UILabel = nil
--!Bind
local _Container : UILabel = nil
--!Bind
local _paragraph : UILabel = nil
--!Bind
local _ReportCommentLabel : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _cancelLabel : UILabel = nil

-- Set text Labels UI

_Panel:SetPrelocalizedText(" ")
_Container:SetPrelocalizedText(" ")

_title:SetPrelocalizedText("Report comment?")
_paragraph:SetPrelocalizedText("Is this comment against community guidelines?")

_cancelButton:Add(_cancelLabel)
_cancelLabel:SetPrelocalizedText("X")
_ReportCommentButton:Add(_ReportCommentLabel)
_ReportCommentLabel:SetPrelocalizedText("✓")

-- Add text to Button
_ReportCommentButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_ReportCommentButton, nil)
    _uiManager.DeactiveActiveGameObject(self, _commentReportedFeedback)
    _EventManager.reportPots:FireServer("Comments", _commentToReportId)

    -- automatically disabling feedback
    Timer.After(3, function()
        _uiManager.DeactiveActiveGameObject(_commentReportedFeedback, nil)
    end)
end)

_cancelLabel:RegisterPressCallback(function()
    _commentToReportId = nil
    _uiManager.ButtonPress(_cancelLabel, nil)
    _uiManager.DeactiveActiveGameObject(self, nil)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager)
    _commentReportedFeedback = _uiManager:GetComponent(CommentReportedFeedback)
    _yourPickedSecret = _uiManager:GetComponent(yourPickedSecret)

    -- functions to be called from another scripts --
    initialize = function(comment)
        _commentToReportId = comment.id
        print(`comment to report has {_commentToReportId} id`)
    end

    _ReportCommentButton:RegisterPressCallback(function() 
        _uiManager.ButtonPress(_ReportCommentButton, nil)
        _uiManager.DeactiveActiveGameObject(self, _commentReportedFeedback)
        _EventManager.reportPots:FireServer("Comments", _commentToReportId)
        _yourPickedSecret.initialize()
        
        -- automatically disabling feedback
        Timer.After(3, function()
            _uiManager.DeactiveActiveGameObject(_commentReportedFeedback, nil)
        end)
    end)
end