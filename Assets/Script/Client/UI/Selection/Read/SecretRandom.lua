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
local _lobby = nil
local _reportSecret = nil
local _commentSecret = nil

-- buttons
--!Bind
local _CommentButton : UIButton = nil
--!Bind
local _NextSecretButton : UIButton = nil
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _reportButton :UIButton = nil

-- Select Labels UI
--!Bind
local _CommentingIcon : UILabel = nil
--!Bind
local _CommentLabel : UILabel = nil
--!Bind
local _NextSecretLabel : UILabel = nil
--!Bind
local _CommentingCount : UILabel = nil
--!Bind
local _PanelSecret : UILabel = nil
--!Bind
local _SecretText : UILabel = nil
--!Bind
local _readingIcon : UILabel = nil
--!Bind
local _readingCount : UILabel = nil
--!Bind
local _title :UILabel = nil
--!Bind
local _tokensContainer :UILabel = nil
--!Bind
local _quitLabel : UILabel = nil

-- Strings --
local _textSecret = "Getting secret!"
local _allSecretsRead = "You have read all the secrets! Please come back some another time to get some new ones!"
local _readToken
local _commentToken

-- tables --
local _currentSecret
local _secretRandom = nil

-- functions which will be called from another script --
initialize = function() end
refreshTokens = function() end

-- Set text Labels UI
_CommentingIcon:SetPrelocalizedText(" ")
_CommentLabel:SetPrelocalizedText("Comment")
_NextSecretLabel:SetPrelocalizedText("Next Secret")
_PanelSecret:SetPrelocalizedText(" ")
_readingIcon:SetPrelocalizedText(" ")
_SecretText:SetPrelocalizedText(_textSecret)
_title:SetPrelocalizedText("The random secret is:")
_tokensContainer:SetPrelocalizedText(" ")
_quitLabel:SetPrelocalizedText("X")


-- Add text to Button
_CommentButton:Add(_CommentLabel);
_NextSecretButton:Add(_NextSecretLabel);

_CommentButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_CommentButton)
    if _commentToken > 0 then
        _uiManager.DeactiveActiveGameObject(self, _commentSecret)
        _EventManager.setPlayerState:FireServer("currentMessage", "")
        _commentSecret.initialize()
        _EventManager.setPlayerState:FireServer("commentChat", true)
        _EventManager.setChat:FireServer("Comment")
    else
        _SecretText:SetPrelocalizedText("You have no comment tokens! You'll get one each 3 secrets you leave!")
        Timer.After(3, function()
            _SecretText:SetPrelocalizedText(_textSecret)
        end)
    end
end)

_NextSecretButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_NextSecretButton)
    
    if _readToken <= 0 then 
        _SecretText:SetPrelocalizedText("You have no secret tokens! You'll get some each secret you leave!")
        Timer.After(3, function()
            _SecretText:SetPrelocalizedText(_textSecret)
        end)
        return
    end
    _secretRandom.initialize();
end)

_reportButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportButton)
    _uiManager.DeactiveActiveGameObject(nil, _reportSecret)
end)

_quitLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitLabel)
    _uiManager.DeactiveActiveGameObject(self, _lobby)
end)

function self:ClientAwake()
    -- setting scripts
    _uiManager = _UIManager:GetComponent(UIManager)

    _secretRandom = _uiManager:GetComponent(SecretRandom)

    _lobby = _uiManager:GetComponent(Lobby)
    _reportSecret = _uiManager:GetComponent(ReportSecret)
    _commentSecret = _uiManager:GetComponent(CommentSecret)
    _requestRandomSecret = _GameManager:GetComponent(RequestRandomSecret)

    -- setting initialize function
    initialize = function()
        _CommentButton:RemoveFromClassList("inactive")
        _EventManager.setStoragePlayerData:FireServer("readTokens", -1)
        _EventManager.requestStoragePlayerData:FireServer("readTokens")
        _EventManager.requestStoragePlayerData:FireServer("commentTokens")
        _EventManager.requestSecret:FireServer()
    end

    -- refreshing tokens
    refreshTokens = function()
        _EventManager.requestStoragePlayerData:FireServer("readTokens")
        _EventManager.requestStoragePlayerData:FireServer("commentTokens")
    end

    -- setting event receiver
    _EventManager.requestSecret:Connect(function(secret)
        _currentSecret = secret
        _EventManager.setPlayerState:FireServer("currentSecret", secret)
        _textSecret = secret.text
        _SecretText:SetPrelocalizedText(_textSecret)
    end)

    _EventManager.setText:Connect(function(text)
        if text ~= _allSecretsRead then return end
        _CommentButton:AddToClassList("inactive")
        _SecretText:SetPrelocalizedText(text)
        _EventManager.requestStoragePlayerData:FireServer("readTokens")
    end)
    
    _EventManager.requestStoragePlayerData:Connect(function(propertyName, value)
        if propertyName == "readTokens" then
            _readToken = value
            _readingCount:SetPrelocalizedText(`{_readToken}`)
        elseif propertyName == "commentTokens" then
            _commentToken = value
            _CommentingCount:SetPrelocalizedText(`{_commentToken}`)
        end
    end)
end