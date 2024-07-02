--!Type(Module)

-- Inventory Manager --
requestOwnSecrets = Event.new("requestOwnSecrets")
requestSecret = Event.new("requestSecret")
requestSecretsComments = Event.new("requestSecretsComments")

-- Data Manager --
reportPots = Event.new("reportPost")
requestPlayerState = Event.new("requestPlayerState")
requestReportNum = Event.new("requestReportNum")
requestStorageArrayLenght = Event.new("requestStorageArrayLenght")
requestStoragePlayerData = Event.new("requestStoragePlayerData")
newComment = Event.new("newComment")
newSecret = Event.new("newSecret")
setChat = Event.new("setChat")
setPlayerState = Event.new("setPlayerState")
setStoragePlayerData = Event.new("setStoragePlayerData")
setText = Event.new("setText")

-- Random Secret Script --
requestReadSecrets = Event.new("requestReadSecrets")
requestLakeSecret = Event.new("requestLakeSecret")