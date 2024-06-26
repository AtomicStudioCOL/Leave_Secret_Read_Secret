--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UIs --
local _uiManager = nil
local _lobby = nil
local _readPickedSecret = nil

-- buttons --
--!Bind
local _quitButton :UIButton = nil

-- scroll --
--!Bind
local _secretsScroll : UIScrollView = nil

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
local _quitLabel : UILabel = nil

-- tables --
local _readSecrets = {}

-- functions to be setted on client awake --
initialize = function() end

-- Set text Labels UI
_Panel:SetPrelocalizedText(" ")
_Container:SetPrelocalizedText(" ")
_scrollContainer:SetPrelocalizedText(" ")
_title:SetPrelocalizedText("Read secrets")
_quitLabel:SetPrelocalizedText("X")
_quitButton:Add(_quitLabel)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton)
    _uiManager.DeactiveActiveGameObject(self, _lobby)
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager)

    _lobby = _uiManager:GetComponent(Lobby)
    _readPickedSecret = _uiManager:GetComponent(ReadPickedSecret)
    -- functions called from another scripts --
    initialize = function()
        _EventManager.requestReadSecrets:FireServer()
        _secretsScroll:Clear()
    end

    -- instantiate secrets buttons function --
    local function instantiateSecretButton(i, secret)
        print(`{secret.id} secret was sent to instantiateSecretButton function`)
        secretButton = UIButton.new()
        secretButton:AddToClassList("secretB")
        _secretsScroll:Add(secretButton)
        secretButtonLabel = UILabel.new()
        secretButtonLabel:AddToClassList("secretL")
        secretButtonLabel:SetPrelocalizedText(secret.text)
        secretButton:Add(secretButtonLabel)

        secretButton:RegisterPressCallback(function()
            _uiManager.ButtonPress(secretButton)
            _EventManager.setPlayerState:FireServer("currentSecret", secret)
            _uiManager.DeactiveActiveGameObject(self, _readPickedSecret)
            _readPickedSecret.initialize()
        end)
    end

    -- event receiver --
    _EventManager.requestReadSecrets:Connect(function(readSecrets)
        table.clear(_readSecrets)
        if #readSecrets < 1 then
            _scrollContainer:SetPrelocalizedText("No secrets yet!")
        else
            _scrollContainer:SetPrelocalizedText("")
        end
        for i, secret in ipairs(readSecrets) do
            readSecrets[i] = secret
            instantiateSecretButton(i, secret)
        end
    end)
end