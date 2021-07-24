CategoryBlips = {}
UserBlips = {}

local settings = LoadTableFromJson("settings" .. ((Config.UseUniqueSave and "@" .. Config.UniqueSaveName) or ""))
if not settings then
    settings = {}
    for category, categoryTbl in pairs(Config.Blips) do
        settings[category] = categoryTbl.defaultEnabled
    end
end

CategoryBlips = settings
LoadCategoryBlips()

UserBlips = LoadTableFromJson("userBlips@" .. Config.UniqueSaveName) or {}
LoadUserBlips()