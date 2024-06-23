--!Type(Client)

-- Managers --
local _EventManager = require("EventManager")

-- Functions --

function choseRandomSecret()
    local _secretsTotal
    _EventManager.requestStorageArrayLenght:FireServer("Secrets")
    _EventManager.requestStorageArrayLenght:Connect(function(lenght)
        local _randomNum = math.random(1, lenght)
        _EventManager.requestSecret:FireServer(_randomNum)
        _EventManager.requestSecret:Connect(function(secret)
            print(`Secret's text is: {secret.text}`)
        end)
    end)
end