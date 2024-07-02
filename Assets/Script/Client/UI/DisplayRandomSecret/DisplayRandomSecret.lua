--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")


-- Select Scripts 
--!Header("Scripts UI")
--!SerializeField
local _GameManager : GameObject = nil;

-- Scripts --
local _uiManager = nil;
local _readToken;
local _secretRandom = nil;

-- Panel
--!Bind
local _PanelRandomSecret : UILabel = nil

-- Message
--!Bind
local _RandomSecretMessage : UILabel = nil

_PanelRandomSecret:SetPrelocalizedText("")

_RandomSecretMessage:SetPrelocalizedText("Check out the secrets and support ...")

function self:ClientAwake()
    -- setting scripts
    _uiManager = _UIManager:GetComponent(UIManager)
    _secretRandom = _uiManager:GetComponent(SecretRandom)

    _EventManager.requestLakeSecret:FireServer()
    Timer.Every(210, function() _EventManager.requestLakeSecret:FireServer() end)

    _EventManager.requestLakeSecret:Connect(function(secret)

        _currentSecret = secret

        local _textSecret = ""
        local count = 0

        for i in string.gmatch(secret.text, "%S+") do
            _textSecret = _textSecret .. " " .. i
            count = count + 1
            if count >= 5 then
                _textSecret = _textSecret .. " ..."
                break
            end
        end

        _RandomSecretMessage:SetPrelocalizedText(_textSecret)
    end)    
end