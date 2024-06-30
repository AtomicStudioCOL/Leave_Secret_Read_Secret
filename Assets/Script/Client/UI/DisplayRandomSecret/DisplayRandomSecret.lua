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
local _RandomSecretTitle : UILabel = nil

--!Bind
local _RandomSecretMessage : UILabel = nil

-- Button
--!Bind
local _RandomSecretButton : UIButton = nil

--!Bind
local _RandomSecretLabel : UILabel = nil


initialize = function()
    _EventManager.requestStoragePlayerData:FireServer("readTokens")
    _EventManager.requestStoragePlayerData:FireServer("commentTokens")    
end

_PanelRandomSecret:SetPrelocalizedText("")

_RandomSecretTitle:SetPrelocalizedText("Secrets Tree")

_RandomSecretMessage:SetPrelocalizedText("Estamos probando ............")


_RandomSecretButton:Add(_RandomSecretLabel)
_RandomSecretLabel:SetPrelocalizedText("Secrets Random")

_RandomSecretButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_RandomSecretButton)
    
    if _readToken <= 0 then 
        _RandomSecretMessage:SetPrelocalizedText("You have no secret tokens! You'll get some each secret you leave!")
        -- Timer.After(3, function()
        --     _RandomSecretMessage:SetPrelocalizedText(_textSecret)
        -- end)
        return
    end
    _secretRandom.initialize();
end)

function self:ClientAwake()
        -- setting scripts
        _uiManager = _UIManager:GetComponent(UIManager)

        _secretRandom = _uiManager:GetComponent(SecretRandom)

        _requestRandomSecret = _GameManager:GetComponent(RequestRandomSecret)

        ---[[
        -- setting initialize function
    -- event receiver
    -- setting event receiver
    _EventManager.requestSecret:Connect(function(secret)
        _currentSecret = secret
        _EventManager.setPlayerState:FireServer("currentSecret", secret)

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

        print(_textSecret)
        -- _textSecret = secret.text
        _RandomSecretMessage:SetPrelocalizedText(_textSecret)
    end)
        --]]
    
end