--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UI scripts --
local _uiManager = nil
local _lobby = nil
local _leaveSecretUi = nil
local _feedbackSent = nil

-- bools --
local canSend : boolean

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

_cancelLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_cancelButton)
    _uiManager.DeactiveActiveGameObject(self)
end)

function self:ClientAwake()
    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent(UIManager)

    -- Access Dependent UI
    _lobby = _uiManager:GetComponent(Lobby)
    _leaveSecretUi = _uiManager:GetComponent(LeaveSecret)
    _feedbackSent = _uiManager:GetComponent(SecretSentFeedback)

    -- send button
    _sendButton:RegisterPressCallback(function()
        _uiManager.ButtonPress(_sendButton)
        _leaveSecretUi.sendSecret()
        _EventManager.requestStoragePlayerData:FireServer("secrets")
        _uiManager.DeactiveActiveGameObject(self, _feedbackSent)

        -- automatically disabling feedback ui and reenabling lobby ui
        Timer.After(3, function()
            _uiManager.DeactiveActiveGameObject(_leaveSecretUi, nil)
            _uiManager.DeactiveActiveGameObject(_feedbackSent, _lobby)
            _EventManager.setChat:FireServer("General")
        end)
    end)    

    -- adds one comment token every three secrets sent
    _EventManager.requestStoragePlayerData:Connect(function(requestedStateKey, secretsArray)
        if requestedStateKey ~= "secrets" then return end
        local _numberOfSecrets = #secretsArray + 1
        if _numberOfSecrets == 1 or _numberOfSecrets % 3 == 0 then
            print(`added one secret token to {client.localPlayer.name}.`)
            _EventManager.setStoragePlayerData:FireServer("commentTokens", 1)
        else
            print(`Player needs to leave {_numberOfSecrets % 3} more secrets to get a coment token.`)
        end
    end)
end