--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil
local _leaveSecretUi = nil
local _feedbackSent = nil

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

_paragraph:SetPrelocalizedText("You won't be able to edit this secret in the future.")

_title:SetPrelocalizedText("Send?")

_cancelButton:Add(_cancelLabel)
_cancelLabel:SetPrelocalizedText("X")
_sendButton:Add(_sendLabel)
_sendLabel:SetPrelocalizedText("✓")

-- Add text to Button
_sendButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_sendButton)
    _EventManager.requestPlayerState:FireServer("currentMessage")
    _EventManager.setStoragePlayerData:FireServer("readTokens", 5)
end)

_cancelLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_cancelButton);
    _uiManager.DeactiveActiveGameObject(self);
end)

function self:ClientAwake()
    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent(UIManager);

    -- Access Dependent UI
    _lobby = _uiManager:GetComponent(Lobby)
    _leaveSecretUi = _uiManager:GetComponent(LeaveSecret)
    _feedbackSent = _uiManager:GetComponent(SecretSentFeedback)

    -- event receiver
    _EventManager.requestPlayerState:Connect(function(currentMessage, requestedState)
        if requestedState ~= "currentMessage" then return end
        _uiManager.DeactiveActiveGameObject(self, _feedbackSent)
        _EventManager.newSecret:FireServer(currentMessage)
        _EventManager.requestStoragePlayerData:FireServer("secrets")
    
        -- automatically disabling feedback ui and reenabling lobby ui
        Timer.After(3, function()
            _EventManager.setPlayerState:FireServer("currentMessage", "")    
            _uiManager.DeactiveActiveGameObject(_leaveSecretUi, nil)
            _uiManager.DeactiveActiveGameObject(_feedbackSent, _lobby)
            _EventManager.setChat:FireServer("General")
        end)
    end)

    _EventManager.requestStoragePlayerData:Connect(function(requestedStateKey, secretsArray)
        if requestedStateKey ~= "secrets" then return end
        local _numberOfSecrets = #secretsArray + 1
        if _numberOfSecrets == 1 or _numberOfSecrets % 3 == 0 then
            _EventManager.setStoragePlayerData:FireServer("commentTokens", 1)
        end
    end)
end