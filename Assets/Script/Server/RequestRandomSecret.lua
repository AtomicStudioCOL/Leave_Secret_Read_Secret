--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")

-- Functions --

function choseRandomSecret(player : Player)
    local _canContinue = true
    Storage.GetValue("Secrets", function(secretsArray)
        local _lenghtTotal = #secretsArray
        Storage.GetPlayerValue(player, "readSecrets", function(playerReadSecrets)
            Storage.GetPlayerValue(player, "secrets", function(ownSecretsArray)
                local _reportedSecrets = {}
                for i, secret in ipairs(secretsArray) do
                    if secret.reportNum > 2 then
                        _reportedSecrets[#_reportedSecrets+1] = i
                    end
                end
                local _lenghtReported = #_reportedSecrets
                local _lenghtOwn = #ownSecretsArray
                local _lenghtRead = #playerReadSecrets
                print(`{player.name} has read {_lenghtRead} secrets out of {_lenghtTotal - _lenghtOwn - _lenghtReported} available secrets`)
                if _lenghtTotal - _lenghtOwn - _lenghtReported == _lenghtRead then
                    _canContinue = false
                    _EventManager.setText:FireClient(player, "You have read all the secrets! Please come back some another time to get some new ones!")
                    _DataManager.setStoragePlayerData(player, "readTokens", 1)
                    return
                end
                if _canContinue == false then return end
                local _randomNum
                local _secret
                local _attempts = 0
                local _tryAgain = true
                while _tryAgain == true and _attempts < 100 do
                    _attempts += 1
                    _randomNum = math.random(1, _lenghtTotal)
                    math.randomseed(_randomNum + _attempts)
                    _secret = secretsArray[_randomNum]
                    if _secret.idPlayer == player.user.id then
                        print("chosen secret is player's secret")
                        _canContinue = false
                    elseif _secret.reportNum > 2 then
                        print(`chosen secret ({_secret.id}) has been reported at least three times.`)
                        _canContinue = false
                    else
                        local _readSecret = false
                        for i, v in ipairs(playerReadSecrets) do
                            if v == _secret.id then
                                print(`The player has already read this secret.`)
                                _canContinue = false
                                _readSecret = true
                            end
                        end
                        if _readSecret == false then
                            _tryAgain = false
                            _canContinue = true
                        end
                    end
                end
                if _canContinue == false then return end
                _DataManager.setStoragePlayerData(player, "readSecrets", `{_secret.id}`)
                _EventManager.requestSecret:FireClient(player, _secret)
            end)
        end)
    end)
end

function self:ServerAwake()
    _EventManager.requestSecret:Connect(function(player : Player)
        choseRandomSecret(player)
    end)
end