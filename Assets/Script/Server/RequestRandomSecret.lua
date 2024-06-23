--!Type(Server)

-- Managers --
local _EventManager = require("EventManager")
local _DataManager = require("DataManager")

-- Functions --

function choseRandomSecret(player : Player)
    local _canContinue = true
    Storage.GetValue("Secrets", function(secretsArray)
        local lenghtTotal = #secretsArray
        _EventManager.requestStoragePlayerData:FireServer("readSecrets")
        Storage.GetPlayerValue(player, "readSecrets", function(playerReadSecrets)
            _EventManager.requestStorageArrayLenght:FireServer("secrets")
            Storage.GetValue("secrets", function(ownSecretsArray)
                local lenghtOwn = #ownSecretsArray
                local lenghtRead = #playerReadSecrets
                if lenghtTotal - lenghtOwn == lenghtRead then
                    print("player has read all the secrets")
                    _canContinue = false
                    return
                end
                if _canContinue == false then return end
                print(`total is {lenghtTotal}, own is {lenghtOwn} and read is {lenghtRead}`)
                local _randomNum = math.random(1, lenghtTotal - lenghtOwn - lenghtRead)
                local secret = secretsArray[_randomNum]
                print(`Secret's text is: {secret.text}`)
                if secret.idPlayer == player.id then
                    print("chosen secret is player's secret")
                    choseRandomSecret(player)
                    _canContinue = false
                end
                print("read secret will be added to player's read secrets list")
                _DataManager.setPlayerState(player, "readSecrets", secret.id)
                if _canContinue == false then return end
                if playerReadSecrets ~= type("table") then return end
                for i, v in ipairs(playerReadSecrets) do
                    print(secret.id)
                    if v == secret.id then
                        print(`The player has already read this secret.`)
                        choseRandomSecret(player)
                        _canContinue = false
                        return
                    end
                end
                if _canContinue == false then return end
            end)
        end)
    end)
end