--!Type(UI)

-- UIManager
local _UIManager = require("UIManager")

-- Variables for gamemanager
local _uiManager = nil;
local _lobby = nil;

-- Select Labels UI
--!Bind
local _PanelAgreement : UILabel = nil

--!Bind
local _AgreementText : UILabel = nil

--!Bind
local _acceptButton : UILabel = nil

--!Bind
local _acceptLabel : UILabel = nil


-- Create Text Labels UI
local _textAgreement = "Terms and Conditions of Anonymity: Anonymity: All messages submitted on our platform are anonymous. We do not collect, store, or share any personally identifiable information from the messages. ata Security: We use industry-standard encryption methods to ensure the security of your messages. However, no method of transmission over the internet or electronic storage is 100% secure, so we cannot guarantee its absolute security. Responsibility: You are responsible for the content of your messages. Do not share sensitive personal information in your messages. We are not responsible for any consequences that may result from the disclosure of your information in your messages. Content Moderation: We reserve the right to review and remove any messages that violate our community guidelines, including but not limited to messages that contain hate speech, harassment, or threats. Changes to These Terms: We may update these terms and conditions at any time. We will notify you of any changes by posting the new terms and conditions on this page. By using our platform, you agree to these terms and conditions of anonymity. Please review these terms regularly to stay informed about our practices.";

-- Set text Labels UI

_PanelAgreement:SetPrelocalizedText(" ", true)

_AgreementText:SetPrelocalizedText(_textAgreement, true)

_acceptLabel:SetPrelocalizedText("Accept", true)

-- Set Class

_PanelAgreement:AddToClassList("Panel");

_AgreementText:AddToClassList("AgreementText");

-- Add text to Button
_acceptButton:Add(_acceptLabel);

_acceptButton:RegisterPressCallback(function() 
    _uiManager.ButtonPress(_acceptButton);
    _uiManager.DeactiveActiveGameObject(self, _lobby);
end)

function self:ClientAwake()

    -- Access Modular Funtion 
    _uiManager = _UIManager:GetComponent("UIManager");

    -- Access Dependent UI  
    _lobby  = _uiManager:GetComponent("Lobby")
        
end