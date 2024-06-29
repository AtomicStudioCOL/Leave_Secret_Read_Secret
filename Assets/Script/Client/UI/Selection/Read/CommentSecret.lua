--!Type(UI)

-- Manager --
local _UIManager = require("UIManager")
local _EventManager = require("EventManager")

-- Variables for gamemanager
local _uiManager = nil;
local _secretRandom = nil
local _sendCommentConfirmation = nil

-- bools --
local _activateConf : boolean

-- buttons
--!Bind
local _quitButton :UIButton = nil
--!Bind
local _sendButton :UIButton = nil

-- Select Labels UI
--!Bind
local _Container : UILabel = nil
--!Bind
local _title : UILabel = nil
--!Bind
local _paragraph : UILabel = nil
--!Bind
local _textInput : UILabel = nil
--!Bind
local _quitLabel : UILabel = nil
--!Bind
local _sendLabel : UILabel = nil

-- Create Text Labels UI
local _textSecret = "Here goes the secret! If you're reading this, something in the code failed! :D! I need to fix it somehow then! :D!"
local _textInputPlaceholder = "Type your comment in the chat. Don't worry! It won't display on other player's chat or over your avatar's head. You'll see your secret here once you send it. To edit it, type the secret again. If your comment is not getting registered, reboot the game."

initialize = function() end

-- Add text to Button
_sendButton:Add(_sendLabel);
_quitButton:Add(_quitLabel)

_sendButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_sendButton);
    _EventManager.requestPlayerState:FireServer("currentMessage")
end)

_quitButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_quitButton);
    _uiManager.DeactiveActiveGameObject(self, _secretRandom)
    _EventManager.setChat:FireServer("General")
end)

function self:ClientAwake()
    _uiManager = _UIManager:GetComponent(UIManager);

    _secretRandom = _uiManager:GetComponent(SecretRandom)
    _sendCommentConfirmation = _uiManager:GetComponent(SendConfirmation)

    -- events --
    _EventManager.setText:Connect(function(newText, target)
        print(`text {newText} recived on {client.localPlayer.name}'s client.`)
        
        print(target)
        if target ~= "comment" then return end
        _textInput:SetPrelocalizedText(newText)
    end)

    _EventManager.requestPlayerState:Connect(function(requestedValue, requestedStateKey)
        if requestedStateKey == "currentMessage" then
            if requestedValue == "" or requestedValue == nil then
                _textInput:SetPrelocalizedText("No text yet! For leaving a secret, you need to actually type a secret!")
                Timer.After(3, function()
                    if requestedValue == "" or requestedValue == nil then
                        _textInput:SetPrelocalizedText(_textInputPlaceholder)                
                    end
                end)
            else
                _uiManager.DeactiveActiveGameObject(nil, _sendCommentConfirmation)
            end
        elseif requestedStateKey == "currentSecret" then
            _textSecret = requestedValue.text
            _paragraph:SetPrelocalizedText(_textSecret)
        end
    end)

    -- functions --
    initialize = function()
        _Container:SetPrelocalizedText(" ")
        _EventManager.requestPlayerState:FireServer("currentSecret")
        _title:SetPrelocalizedText("You're commenting the following secret:")
        _quitLabel:SetPrelocalizedText("X")
        _textInput:SetPrelocalizedText(_textInputPlaceholder)
        _sendLabel:SetPrelocalizedText("Send")
        _EventManager.setPlayerState:FireServer("secretChat", false)
        _EventManager.setPlayerState:FireServer("commentChat", true)
    end
    initialize()
end