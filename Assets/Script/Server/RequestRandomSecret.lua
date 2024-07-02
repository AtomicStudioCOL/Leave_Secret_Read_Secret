--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")

-- Full random secret for player --
function choseRandomSecret(player : Player)
    local _canContinue = true
    Storage.GetValue("Secrets", function(secretsArray)
        if secretsArray == nil then
            print(`Secrets array is nil. Returning empty and refounding used tokens. (RequestRandomSecret.lua)`)
            _DataManager.setStoragePlayerData(player, "readTokens", 1)
            return
        end

        local _lenghtTotal = #secretsArray
        Storage.GetPlayerValue(player, "readSecrets", function(playerReadSecrets)
            if playerReadSecrets == nil then
                print(`Player read secrets is nil. Returning empty and refounding used tokens. (RequestRandomSecret.lua)`)
                _DataManager.setStoragePlayerData(player, "readTokens", 1)
                return
            end

            Storage.GetPlayerValue(player, "secrets", function(ownSecretsArray)
                if ownSecretsArray == nil then
                    print(`Own secrets array is nil. Returning empty and refounding used tokens. (RequestRandomSecret.lua)`)
                    _DataManager.setStoragePlayerData(player, "readTokens", 1)
                    return
                end
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
                while _tryAgain == true and _attempts < 10000 do
                    _attempts += 1
                    if _attempts == 100 or _attempts == 1000 or _attempts == 10000 then
                        print(`Attempt num {_attempts}.`)
                    end
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
                            if `{v}` == `{_secret.id}` then
                                print(`The player has already read this secret.`)
                                _canContinue = false
                                _readSecret = true
                            end
                        end
                        if _readSecret == false then
                            _tryAgain = false
                            _canContinue = true
                            print(`Getting a secret took {_attempts} attempts. Chosen secret is {_secret.id}`)
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

-- Cropped random secret for lake --
local lastSeed

function requestLakeSecret(player)
    Storage.GetValue("Secrets", function(secretsArray)
        local _randomNum = math.random(1, #secretsArray)
        lastSeed = math.randomseed(_randomNum * math.random(1, 666))
        _EventManager.requestLakeSecret:FireClient(player, secretsArray[_randomNum])
    end)
end

function self:ServerAwake()
    _EventManager.requestSecret:Connect(function(player : Player)
        choseRandomSecret(player)
    end)
    _EventManager.requestLakeSecret:Connect(function(player : Player)
        requestLakeSecret(player)
    end)
end