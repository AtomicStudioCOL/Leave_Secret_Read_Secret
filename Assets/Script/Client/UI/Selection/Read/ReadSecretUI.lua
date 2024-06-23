--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil
local _secretRandom = nil

-- buttons
--!Bind
local _ReadSecretButton : UIButton = nil
--!Bind
local _quitButton :UIButton = nil

-- Select Labels UI
--!Bind
local _PanelReadSecret : UILabel = nil
--!Bind
local _ReadSecretText : UILabel = nil
--!Bind
local _ReadSecretLabel : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

initialize = function()
    _EventManager.requestStoragePlayerData:FireServer("readTokens")
    _EventManager.requestStoragePlayerData:FireServer("commentTokens")    
end

-- token variables
local _readToken
local _commentToken

-- Create Text Labels UI
local _textReadSecret = `You have {_readToken} read tokens and {_commentToken} comment token`;

-- Set text Labels UI

_PanelReadSecret:SetPrelocalizedText(" ")
_ReadSecretText:SetPrelocalizedText(_textReadSecret)
_ReadSecretLabel:SetPrelocalizedText("Read Secrets")
_title:SetPrelocalizedText("Read a secret!")
_quitLabel:SetPrelocalizedText("X")

-- Add text to Button
_ReadSecretButton:Add(_ReadSecretLabel);

-- callbacks

_quitLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitLabel, nil);
    _uiManager.DeactiveActiveGameObject(self, _lobby);
end)

function self:ClientAwake()
    
    _uiManager = _UIManager:GetComponent(UIManager);
    
    _lobby = _uiManager:GetComponent(Lobby)
    _secretRandom = _uiManager:GetComponent(SecretRandom)

    -- button callback dependent of another script
    _ReadSecretButton:RegisterPressCallback(function() 
        _uiManager.ButtonPress(_ReadSecretButton, nil);
        _uiManager.DeactiveActiveGameObject(self, _secretRandom);
        _secretRandom.initialize()
    end)

    -- event receiver
    _EventManager.requestStoragePlayerData:Connect(function(propertyName, value)
        if propertyName == "readTokens" then
            _readToken = value
        elseif propertyName == "commentTokens" then
            _commentToken = value
        end
        _textReadSecret = `You have {_readToken} read tokens and {_commentToken} comment token`
        _ReadSecretText:SetPrelocalizedText(_textReadSecret)
    end)
end