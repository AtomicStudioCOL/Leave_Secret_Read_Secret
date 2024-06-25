--!Type(UI)

-- Managers ..
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- UI scripts --
local _uiManager = nil;
local _pickedSecret = nil
local _secretsInventory = nil

-- buttons --
--!Bind
local _quitButton :UIButton = nil

-- scroll --
--!Bind
local _secretsScroll : UIScrollView = nil

-- Select Labels UI --
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
local _ownSecrets = {}

-- functions to be setted on client awake --
initialize = function() end

-- Set text Labels UI
_Panel:SetPrelocalizedText("")
_Container:SetPrelocalizedText("")
_title:SetPrelocalizedText("Your secrets")
_quitLabel:SetPrelocalizedText("X")

-- Add text to Button
_quitButton:Add(_quitLabel)

-- Select secret function
function selectSecret(currentSecret)
    _uiManager.DeactiveActiveGameObject(self, _pickedSecret)
end

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _secretsInventory)
end)

-- instantiate secrets buttons function --
local function instantiateSecretButton(i, secret)
    print(`{secret.id} secret was sent to instantiateSecretButton function`)
    secretButton = UIButton.new()
    secretButton:AddToClassList("secretB")
    _secretsScroll:Add(secretButton)
    secretButtonLabel = UILabel.new()
    secretButtonLabel:SetPrelocalizedText(secret.text)
    secretButton:Add(secretButtonLabel)
end

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager)

    _pickedSecret = _uiManager:GetComponent(yourPickedSecret)
    _secretsInventory = _uiManager:GetComponent(secretsInventory)

    -- functions called from another scripts --
    initialize = function()
        _EventManager.requestOwnSecrets:FireServer()
        _secretsScroll:Clear()
    end

    -- event receiver --
    _EventManager.requestOwnSecrets:Connect(function(ownSecrets)
        table.clear(_ownSecrets)
        if #ownSecrets < 1 then
            _scrollContainer:SetPrelocalizedText("No secrets yet!")
        else
            _scrollContainer:SetPrelocalizedText("")
        end
        for i, secret in ipairs(ownSecrets) do
            ownSecrets[i] = secret
            instantiateSecretButton(i, secret)
        end
    end)
end