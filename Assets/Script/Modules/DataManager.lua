--!Type(Module)

--[[                        ¡¡¡¡¡ STORAGE DATA STRUCTURE !!!!!

secrets                                 array
secret                                  dictionary
    secret.comments                     array           id's of the comments
	secret.id                           number          toNumber(`{player.id}`..`{#secrets}`)
	secret.idPlayer                     number          for moderation and avoiding taking your own secrets
	secret.hidden                       bool            will turn to true if it has been reported x times
	secret.reportNum                    number          to know how many times has a secret been reported
	secret.text                         string

comments                                array
comment                                 dictionary
	comment.id                          number          toNumber(`{player.id}`..`{#comments}`)
	comment.hidden                      bool            will turn to true if it has been reported x times
    comment.playerName                  string
	comment.reportNum                   number          to know how many times has a comment been reported
    comment.secret                      number          id of the secret being commented
	comment.text                        string

playerData                              dictionary      NOTE: managed with Storage's player functions.
    playerData[player].comments         array           list with player's comments IDs
	playerData[player].commentTokens    number
	playerData[player].readTokens       number
	playerData[player].readComments     array           list of IDs with secrets read by the player
    playerData[player].secrets          array           list with player's secrets IDs

--]]

-- Managers --
local _eventManager = require("EventManager")
local _secretsPool = require("SecretsPool")

-- tables --
playerState = {}

-- functions --

function setStoragePlayerData(player : Player, property : string, value)
    if property == "readTokens" or property == "commentTokens" then
        Storage.IncrementPlayerValue(player, property, value)
    elseif property == "secrets" or property == "comments" then
        if type(value) ~= "number" then
            error(`Expected a number to set {property} new item's id, got {type(value)}.`)
            return
        end
        Storage.UpdatePlayerValue(player, property, function(idsArray)
            idsArray[#idsArray+1] = value
            return idsArray
        end)
    end
end

function requestStoragePlayerData(player : Player, property : string)
    local _returnedProperty = Storage.GetPlayerValue(player, property, function(requiredProperty)
        print(`{requiredProperty}`)
        return requiredProperty
    end)
    print(`{_returnedProperty}`)
end

function newComment(player : Player, text, secretId)
    Storage.UpdateValue("Comments", function(commentsArray)
        local _newComment = {}
        _newComment["id"] = tonumber(`{player.id}..{#commentsArray + 1}`)
        _newComment["hidden"] = false
        _newComment["playerName"] = player.name
        _newComment["reportNum"] = 0
        _newComment["secret"] = secretId
        _newComment["text"] = text

        commentsArray[#commentsArray + 1] = _newComment
        return commentsArray
    end)
end

function newSecret(player : Player, text)
    Storage.UpdateValue("Secrets", function(secretsArray)
        local _newSecret = {}
        _newSecret["comments"] = {}
        _newSecret["id"] =  tonumber(`{player.id}..{#secretsArray + 1}`)
        _newSecret["idPlayer"] = player.id
        _newSecret["hidden"] = false
        _newSecret["reportNum"] = 0
        _newSecret["text"] = text
        secretsArray[#secretsArray + 1] = _newSecret
        return secretsArray
    end)
end

function requestSecret(i)
    local _secret
    Storage.GetValue("Secrets", function(secretsTable)
        _secret = secretsTable[i]
        return _secret
    end)
    return _secret
end

function requestStorageArratLenght(arrayName : string)
    local _lenght
    Storage.GetValue(arrayName, function(array)
        _lenght = #array
        return _lenght
    end)
    return _lenght
end


function requestPlayerState(player : Player, property)
    if property == nil then
        return playerState[player.name]
    else
        return playerState[player.name][property]
    end
end

function setPlayerState(playerName, property, value)
    playerState[playerName][property] = value
end

function self:ServerAwake()
    -- client to server events --
    _eventManager.requestPlayerState:Connect(function(player : Player, property)
        _eventManager.requestPlayerState:FireClient(player, requestPlayerState(player, property))
    end)

    _eventManager.requestSecret:Connect(function(player : Player, i : number)
        _eventManager.requestSecret:FireClient(player, requestSecret(i))
    end)

    _eventManager.requestStorageArrayLenght:Connect(function(player : Player, arrayName : string)
        _eventManager.requestStorageArrayLenght:FireClient(player, requestStorageArratLenght(arrayName))
    end)

    _eventManager.requestStoragePlayerData:Connect(function(player : Player, property : string)
        _eventManager.requestStoragePlayerData:FireClient(player, requestStoragePlayerData(player, property))
    end)

    _eventManager.newComment:Connect(function(player, text, secretId)
        newComment(player, text, secretId)
    end)

    _eventManager.newSecret:Connect(function(player, title, text)
        newSecret(player, text)
    end)

    _eventManager.setPlayerState:Connect(function(player : Player, property, value)
        setPlayerState(player.name, property, value)
    end)

    _eventManager.setStoragePlayerData:Connect(function(player : Player, property : string, value)
        setStoragePlayerData(player, property, value)
    end)

    _eventManager.setText:Connect(function(player : Player)
        _eventManager.setText:FireClient(player, playerState[player.name].currentMessage)
    end)

    -- checking if data exists and generating it if it does not --
    local _secretsTable = nil
    Storage.GetValue("Secrets", function(v)
        _secretsTable = v
        if _secretsTable == nil then
            print("Secrets' table is nil. Setting it to secrets pool.")
            Storage.SetValue("Secrets", _secretsPool.premadeSecrets)
        end
    end)

    local _commentsTable = nil
    Storage.GetValue("Comments", function(v)
        _commentsTable = v
        if _commentsTable == nil then
            print("Comments' table is nil. Setting it to an empty table.")
            Storage.SetValue("Comments", {})
        end
    end)
end