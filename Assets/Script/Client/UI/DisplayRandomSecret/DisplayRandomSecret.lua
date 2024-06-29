--!Type(UI)


-- Select Labels UI
--!Bind
local _PanelRandomSecret : UILabel = nil

-- Message
--!Bind
local _RandomSecretTitle : UILabel = nil

--!Bind
local _RandomSecretMessage : UILabel = nil

-- Button
--!Bind
local _RandomSecretButton : UIButton = nil

--!Bind
local _RandomSecretLabel : UILabel = nil

_RandomSecretTitle:SetPrelocalizedText("Secrets Tree")

_RandomSecretMessage:SetPrelocalizedText("Estamos probando ............")

_RandomSecretLabel:SetPrelocalizedText("Secrets Random")

_RandomSecretButton:Add(_RandomSecretLabel)