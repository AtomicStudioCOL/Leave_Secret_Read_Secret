--!Type(Module)

--[[                        ¡¡¡¡¡ STORAGE DATA STRUCTURE !!!!!

secrets                                 array
secret                                  dictionary
    secret.comments                     array           id's of the comments
	secret.id                           string          toNumber(`{player.user.id}`..`{#secrets}`)
	secret.idPlayer                     string          for moderation and avoiding taking your own secrets
	secret.hidden                       bool            will turn to true if it has been reported x times
	secret.reportNum                    number          to know how many times has a secret been reported
	secret.text                         string

comments                                array
comment                                 dictionary
	comment.id                          string          toNumber(`{player.user.id}`..`{#comments}`)
	comment.hidden                      bool            will turn to true if it has been reported x times
    comment.playerName                  string
	comment.reportNum                   number          to know how many times has a comment been reported
    comment.secret                      string          id of the secret being commented
	comment.text                        string

playerData                              dictionary      NOTE: managed with Storage's player functions.
    playerData[player].comments         array           list with player's comments IDs
	playerData[player].commentTokens    number
	playerData[player].readTokens       number
	playerData[player].readComments     array           list of IDs with secrets read by the player
    playerData[player].secrets          array           list with player's secrets IDs
    playerData[player].readSecrets      array           list with player's read secrets IDs

--]]

-- Managers --
local _eventManager = require("EventManager")
local _secretsPool = require("SecretsPool")

-- tables --
playerState = {}

-- functions --

function reportPost(typeKey : string, id)
    print(`post of class {typeKey} with {id} id entered report function`)
    Storage.UpdateValue(typeKey, function(postArray)
        for i, post in ipairs(postArray) do
            if post.id == id then
                post.reportNum += 1
                print(`{typeKey} {post.id} has {post.reportNum} report(s) now`)
                if post.reportNum > 2 then
                    post.hidden = true
                    print(`{typeKey} {post.id} is hidden now`)
                end
            end
        end
        return postArray
    end)
end

function setStoragePlayerData(player : Player, property : string, value)
    if property == "readTokens" or property == "commentTokens" then
        Storage.IncrementPlayerValue(player, property, value)
    elseif property == "secrets" or property == "readSecrets" or property == "comments" or property == "readComments"  then
        if type(value) ~= "string" then
            error(`Expected a string to set {property} new item's id, got {type(value)}.`)
            return
        end
        Storage.UpdatePlayerValue(player, property, function(idsArray)
            idsArray[#idsArray+1] = value
            return idsArray
        end)
    else
        error(`Expected "secrets" || "readSecrets" || comments || readComments || readTokens || commentTokens, got {property}`)
    end
end

function setCommentToSecret(secretId, commentId)
    Storage.UpdateValue("Secrets", function(secretsArray)
        for i, secret in ipairs(secretsArray) do
            if secret.id == secretId then
                secret.comments[#secret.comments + 1] = commentId
            end
        end
        return secretsArray
    end)
end

function newComment(player : Player, text, secretId)
    Storage.UpdateValue("Comments", function(commentsArray)
        local _newComment = {}
        _newComment["id"] = `{player.user.id}{#commentsArray + 1}`
        _newComment["hidden"] = false
        _newComment["playerName"] = player.name
        _newComment["reportNum"] = 0
        _newComment["secret"] = secretId
        _newComment["text"] = `{player.name}: {text}`
        commentsArray[#commentsArray + 1] = _newComment
        setCommentToSecret(secretId, _newComment.id)
        setStoragePlayerData(player, "comments", _newComment.id)
        return commentsArray
    end)
end

function newSecret(player : Player, _text : string)
    Storage.UpdateValue("Secrets", function(secretsArray)
        local _newSecret = {}
        _newSecret["comments"] = {}
        _newSecret["id"] =  `{player.user.id}{#secretsArray + 1}`
        _newSecret["idPlayer"] = player.user.id
        _newSecret["hidden"] = false
        _newSecret["reportNum"] = 0
        _newSecret["text"] = `{_text}`
        secretsArray[#secretsArray + 1] = _newSecret
        setStoragePlayerData(player, "secrets", _newSecret.id)
        return secretsArray
    end)
end

function requestPlayerState(player : Player, property)

    if property == nil then
        return playerState[player.name]
    else
        return playerState[player.name][property]
    end
end

function setPlayerState(playerName, property, value)
    playerState[playerName][property] = nil
    playerState[playerName][property] = value
end

function self:ServerStart()
    -- client to server events --
    _eventManager.reportPots:Connect(function(player : Player, typeKey : string, id)
        reportPost(typeKey, id)
    end)

    _eventManager.requestPlayerState:Connect(function(player : Player, property)
        _eventManager.requestPlayerState:FireClient(player, requestPlayerState(player, property), property)
    end)

    _eventManager.requestStorageArrayLenght:Connect(function(player : Player, arrayName : string)
        if arrayName == "Secrets" or arrayName == "Comments" then
            Storage.GetValue(arrayName, function(array)
                local _lenght = #array
                _eventManager.requestStorageArrayLenght:FireClient(player, _lenght, arrayName)
            end)
        elseif arrayName == "secrets" or arrayName == "readSecrets" or arrayName == "comments" or arrayName == "readComments" then
            Storage.GetPlayerValue(player, arrayName, function(array)
                local _lenght = #array
                _eventManager.requestStorageArrayLenght:FireClient(player, _lenght, arrayName)
            end)
        end
    end)

    _eventManager.requestStoragePlayerData:Connect(function(player : Player, propertyName : string)
        Storage.GetPlayerValue(player, propertyName, function(requiredProperty)
            _eventManager.requestStoragePlayerData:FireClient(player, propertyName, requiredProperty)
        end)
    end)

    _eventManager.newComment:Connect(function(player, text, secretId)
        newComment(player, text, secretId)
    end)

    _eventManager.newSecret:Connect(function(player, text)
        newSecret(player, text)
    end)

    _eventManager.setPlayerState:Connect(function(player : Player, property, value)
        setPlayerState(player.name, property, value)
    end)

    _eventManager.setStoragePlayerData:Connect(function(player : Player, property : string, value)
        setStoragePlayerData(player, property, value)
    end)

    -- Cambios 

    _eventManager.setText:Connect(function(player : Player, target : string)
        print(`Set text recieved. Player's current message is: {playerState[player.name].currentMessage}. Firing to {player.name}'s client.`)
        _eventManager.setText:FireClient(player, playerState[player.name].currentMessage, target)
    end)

    -- checking if data exists and generating it if it does not --
    local _secretsTable = nil
    Storage.GetValue("Secrets", function(v)
        _secretsTable = v
        if _secretsTable == nil then

            Storage.SetValue("Secrets", _secretsPool.premadeSecrets)
            
        end
    end)

    local _commentsTable = nil
    Storage.GetValue("Comments", function(v)
        _commentsTable = v
        if _commentsTable == nil then
            Storage.SetValue("Comments", {})
        end
    end)
end