--- Creates a map blip with the provided information and returns the ID of the created blip.
---@param blipTbl table A table describing the blip and its parameters.
---@return number The ID of the created blip.
function CreateBlip(blipTbl)
    local blipId = AddBlipForCoord(blipTbl.pos.x, blipTbl.pos.y, blipTbl.pos.z)
    SetBlipHighDetail(blipId, blipTbl.highDetail)
    SetBlipSprite(blipId, blipTbl.sprite)
    SetBlipScale(blipId, blipTbl.scale)
    SetBlipColour(blipId, blipTbl.color)
    SetBlipAsShortRange(blipId, blipTbl.shortRange)
    SetBlipHiddenOnLegend(blipId, blipTbl.hiddenOnLegend)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipTbl.text)
    EndTextCommandSetBlipName(blipId)

    return blipId
end

--- Saves a table to the clients PC in JSON format.
---@param identifier string The identifier to save the table in.
---@param tbl table The table to encode in JSON and save.
function SaveTableToJson(identifier, tbl)
    SetResourceKvp("blips:" .. identifier, json.encode(tbl))
end

--- Loads a table from the clients PC in JSON format.
---@param identifier string The identifier of the saved table.
---@return table The decoded table.
function LoadTableFromJson(identifier)
    local tblJson = GetResourceKvpString("blips:" .. identifier)
    if tblJson then
        return json.decode(tblJson)
    end
end

--- Resets a users settings back to default.
function ResetSettings()
    -- Cleanup all blips.
    UnloadCategoryBlips()
    UnloadUserBlips()

    -- Recreate category blips config.
    for category, categoryTbl in pairs(Config.Blips) do
        CategoryBlips[category] = categoryTbl.defaultEnabled
    end

    -- Wipe user blips config.
    UserBlips = nil
    UserBlips = {}

    -- Overwrite old user settings.
    SaveTableToJson("settings" .. ((Config.UseUniqueSave and "@" .. Config.UniqueSaveName) or ""), CategoryBlips)
    SaveTableToJson("userBlips@" .. Config.UniqueSaveName, UserBlips)

    -- Load blips.
    LoadCategoryBlips()
    LoadUserBlips()
end