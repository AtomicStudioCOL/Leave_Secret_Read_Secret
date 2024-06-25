--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")

-- functions --
function requestOwnSecrets(player : Player)
    Storage.GetValue("Secrets", function(secretsArray)
        local _ownSecrets = {}
        for i, secret in ipairs(secretsArray) do
            if secret.idPlayer == player.id then
                _ownSecrets[#_ownSecrets+1] = secret
            end
        end
        print(`Player has {#_ownSecrets} secrets`)
        _EventManager.requestOwnSecrets:FireClient(player, _ownSecrets)
    end)
end

-- event receiver --
function self:ServerAwake()
    _EventManager.requestOwnSecrets:Connect(function(player : Player)
        requestOwnSecrets(player)
    end)
end