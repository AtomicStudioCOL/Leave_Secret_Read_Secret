--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")

-- functions --
function requestOwnSecrets(player : Player)
    Storage.GetValue("Secrets", function(secretsArray)
        local _ownSecrets = {}
        for i, secret in ipairs(secretsArray) do
            if secret.idPlayer == player.user.id and secret.hidden == false then
                _ownSecrets[#_ownSecrets+1] = secret
            end
        end
        print(`Player has {#_ownSecrets} secrets`)
        _EventManager.requestOwnSecrets:FireClient(player, _ownSecrets)
    end)
end

function requestReadSecrets(player : Player)
    local _readSecrets = {}
    Storage.GetPlayerValue(player, "readSecrets", function(readSecrets)
        Storage.GetValue("Secrets", function(secretsArray)
            for i, readId in ipairs(readSecrets) do
                local _found = false
                for ii, secret in ipairs(secretsArray) do
                    if `{secret.id}` == readId and secret.hidden == false then
                        _readSecrets[i] = secret
                        _found = true
                    end
                end
            end
            print(`Player has {#_readSecrets} secrets`)
            _EventManager.requestReadSecrets:FireClient(player, _readSecrets)
        end)
    end)
end

function requestSecretsComments(player : Player, secretId)
    Storage.GetValue("Comments", function(commentsArray)
        local _secretComments = {}
        for i, comment in ipairs(commentsArray) do
            if comment.secret == secretId and comment.hidden == false then
                _secretComments[#_secretComments+1] = comment
            end
        end
        print(`Secret has {#_secretComments} comment(s).`)
        _EventManager.requestSecretsComments:FireClient(player, _secretComments)
    end)
end

-- event receiver --
function self:ServerAwake()
    _EventManager.requestOwnSecrets:Connect(function(player : Player)
        requestOwnSecrets(player)
    end)

    _EventManager.requestReadSecrets:Connect(function(player : Player)
        requestReadSecrets(player)
    end)

    _EventManager.requestSecretsComments:Connect(function(player : Player, secretId)
        requestSecretsComments(player, secretId)
    end)
end