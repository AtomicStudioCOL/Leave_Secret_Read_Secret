--!Type(UI)

-- Select Script
--!Header("Script Agreement UI")
--!SerializeField
local _UIManager : GameObject = nil;

-- Variables for gamemanager
local _uiManager = nil;
local _agreement = nil;

-- Select Labels UI
--!Bind
local _PanelWelcome : UILabel = nil

-- Message
--!Bind
local _WelcomeMessage : UILabel = nil
--!Bind
local _LeaveSecret : UILabel = nil
--!Bind
local _ReadSecret : UILabel = nil

-- Button
--!Bind
local _continueButton : UIButton = nil

--!Bind
local _continueLabel : UILabel = nil

-- Create Text Labels UI
local _textWelcome = "# Hello, welcome to our wonderful space of secrets! Here you can leave your own secrets and discover the mysteries that others have shared. Prepare for an adventure full of peace and tranquility!";

local _textLeaveSecret = "1. Enter our wonderful space of secrets. 2. Click on the ‘Leave a Secret’ button. 3. Write your message in the text box that appears. Remember, no personal data will be included, maintaining your anonymity is important to us. 4. When you’re done, click ‘Submit’. Your secret is now part of our heart!";

local _textReadSecret = "1. Enter our wonderful space of secrets. 2. To read a secret, simply click on one of the secrets that appear on the screen. 3. If you want to leave a message of support, click on the ‘Leave a Support Message’ button.";

-- Set text Labels UI

_PanelWelcome:SetPrelocalizedText(" ")

_WelcomeMessage:SetPrelocalizedText(_textWelcome)

_LeaveSecret:SetPrelocalizedText(_textLeaveSecret)

_ReadSecret:SetPrelocalizedText(_textReadSecret)

_continueLabel:SetPrelocalizedText("Continue")

-- Set Class
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
    _uiManager = _UIManager:GetComponent("UIManager");

    -- Access Dependent UI  
    _agreement  = _uiManager:GetComponent("Agreement")
        
end