--!Type(Module)

-- Select Scripts 
--!Header("Scripts UI")
--!SerializeField
local _UIManager : GameObject = nil;


-- Variables GameObject
local _uIscripts = nil;
local _welcome = nil;
local _agreement = nil;

-- Function to Add/Remove GameObjetc
function DeactiveActiveGameObject(_gameObjectDeactive, _gameObjectActive)

    -- This conditional is for evalute GameObject = nil
    if _gameObjectDeactive ~= nil then 
        _gameObjectDeactive.enabled = false;
    end
    if _gameObjectActive ~= nil then 
        _gameObjectActive.enabled = true;
    end
    
end

-- Function for all Buttons Feedback

function ButtonPress(_Button)
    
    _Button:AddToClassList("ButtonPress")

    Timer.After(.1, function() 
        _Button:RemoveFromClassList("ButtonPress")
    end)

end

function self:ClientAwake()

    _uIscripts = _UIManager
    
end