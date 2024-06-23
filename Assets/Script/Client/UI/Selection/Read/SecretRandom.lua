--!Type(UI)

-- Managers --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")

-- Select Scripts 
--!Header("Scripts UI")
--!SerializeField
local _GameManager : GameObject = nil;

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil
local _reportSecret = nil
local _commentSecret = nil

-- buttons
--!Bind
local _CommentButton : UIButton = nil
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

-- Create Text Labels UI
local _textSecret = "Once I stole a cookie from the fridge. Mom still does not know. :c"
local _readToken
local _commentToken
initialize = function() end


-- Set text Labels UI
_CommentingIcon:SetPrelocalizedText(" ")
_CommentLabel:SetPrelocalizedText("Comment")

_PanelSecret:SetPrelocalizedText(" ")

_readingIcon:SetPrelocalizedText(" ")

_SecretText:SetPrelocalizedText(_textSecret)

_title:SetPrelocalizedText("The random secret is:")

_tokensContainer:SetPrelocalizedText(" ")

_quitLabel:SetPrelocalizedText("X")

-- Add text to Button
_CommentButton:Add(_CommentLabel);

_CommentButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_CommentButton);
    _uiManager.DeactiveActiveGameObject(self, _commentSecret)
    _commentSecret.setDefaultTexts()
    _EventManager.setChat:FireServer("Secret")
    _EventManager.setPlayerState:FireServer("secretChat", true)
end)

_reportButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_reportButton);
    _uiManager.DeactiveActiveGameObject(self, _reportSecret)
end)

_quitLabel:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitLabel);
    _uiManager.DeactiveActiveGameObject(self, _lobby)
end)

function self:ClientAwake()
    -- setting scripts
    _uiManager = _UIManager:GetComponent(UIManager);

    _lobby = _uiManager:GetComponent(Lobby)
    _reportSecret = _uiManager:GetComponent(ReportSecret)
    _commentSecret = _uiManager:GetComponent(CommentSecret)
    _requestRandomSecret = _GameManager:GetComponent(RequestRandomSecret)

    -- setting initialize function
    initialize = function()
        _EventManager.requestStoragePlayerData:FireServer("readTokens")
        _EventManager.requestStoragePlayerData:FireServer("commentTokens")
        _requestRandomSecret.choseRandomSecret()
    end

    -- setting event receiver
    _EventManager.requestSecret:Connect(function(secret)
        _textSecret = secret.text
        _SecretText:SetPrelocalizedText(_textSecret)
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