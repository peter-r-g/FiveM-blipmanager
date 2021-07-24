fx_version "adamant"

game "gta5"

description "Gunmans Blip Manager"

client_scripts {
	"config.lua",
	"client/functions.lua",
	"client/blipsets/category.lua",
	"client/blipsets/custom.lua",
	"client/blipsets/user.lua",
	"client/commands.lua",
	"client/main.lua"
}

client_export "SetBlipCategoryEnabled"
client_export "GetBlipCategoryState"

client_export "AddUserBlip"
client_export "RemoveUserBlip"
client_export "SetUserBlipEnabled"
client_export "GetUserBlipState"

client_export "AddCustomBlip"
client_export "RemoveCustomBlip"
client_export "EditCustomBlip"
client_export "SetCustomBlipParameter"
client_export "GetCustomBlipParameter"
client_export "GetCustomBlipId"