--!Type(UI)

-- Select Script
--!Header("Script Agreement UI")
--!SerializeField
local _UIManager : GameObject = nil;

-- Variables for gamemanager
local _uiManager = nil;
local _EventManager = require("EventManager");
local _agreement = nil;

-- Select Labels UI
--!Bind
local _PanelWelcome : UILabel = nil

-- Message
--!Bind
local _WelcomeTitle : UILabel = nil
--!Bind
local _WelcomeMessage : UILabel = nil
--!Bind
local _LeaveTitle : UILabel = nil
--!Bind
local _LeaveSecret : UILabel = nil
--!Bind
local _ReadTitle : UILabel = nil
--!Bind
local _ReadSecret : UILabel = nil
--!Bind
local _LeaveSecretBox : UILabel = nil
--!Bind
local _ReadSecretBox : UILabel = nil

-- Button
--!Bind
local _continueButton : UIButton = nil

--!Bind
local _continueLabel : UILabel = nil

-- Create Text Labels UI
local _title = "Read this carefully before you begin"

local _textWelcome = "Hello! Welcome to our wonderful world of Secrets! Leave an anonymous secret for others to read, and read secrets that others have left!";

local _textLeaveSecret =`All secrets you submit will be anonymous and will never be traced back to you. Gain 5 reading tokens for every secret you leave, and 1 comment token for every 3 secrets you leave. Reading tokens can be used to read other players' secrets while comment tokens can be used to leave comments on secrets. To begin:\n\n1. Click on "Leave A Secret"\n\n2. Type your secret in the chat - Don't worry, others will not see what you type.\n\n3.Click on "Submit" once you're done.`

local _textReadSecret = `Read Secrets and leave comments on them. Comments are not anonymous!\n\n1. Click on "Read a Secret"\n\n2. You'll see the amount of Reading Tokens and Comment Tokens you have.\n\n3. Click on "Read Secrets" to view a secret that other players have submitted.`

-- Set text Labels UI

_PanelWelcome:SetPrelocalizedText(" ")
_LeaveSecretBox:SetPrelocalizedText("")
_ReadSecretBox:SetPrelocalizedText("")
_WelcomeTitle:SetPrelocalizedText(_title)
_WelcomeMessage:SetPrelocalizedText(_textWelcome)

_LeaveTitle:SetPrelocalizedText("LEAVE A SECRET")
_LeaveSecret:SetPrelocalizedText(_textLeaveSecret)

_ReadTitle:SetPrelocalizedText("READ A SECRET")
_ReadSecret:SetPrelocalizedText(_textReadSecret)

_continueLabel:SetPrelocalizedText("GOT IT")

-- Set Class
_WelcomeTitle:AddToClassList("welcomeTitle")

_WelcomeMessage:AddToClassList("welcomeMessage")

_LeaveSecret:AddToClassList("LeaveSecret")

_ReadSecret:AddToClassList("ReadSecret")

_continueButton:Add(_continueLabel);

-- Callbak Button
_continueButton:RegisterPressCallback(function()
    _uiManager.ButtonPress(_continueButton);
    _uiManager.DeactiveActiveGameObject(self, _agreement);
end)

function self:ClientAwake()

    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent(UIManager);

    -- Access Dependent UI  
    _agreement  = _uiManager:GetComponent(Agreement);

    _EventManager.setPlayerState:FireServer("currentMessage", "")

    _EventManager.setText:FireServer("comment")
    
    _EventManager.setText:FireServer("secret")
        
end