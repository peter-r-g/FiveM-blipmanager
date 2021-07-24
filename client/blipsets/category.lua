--- The table containing the categories and their blip IDs.
local blipIds = {}
--- Localized config function.
local GetBlipConfig = Config.GetBlipConfig

--- Unloads a categories blips.
---@param blipCategory string The category to unload.
function UnloadBlipCategory(blipCategory)
    local blipTbl = blipIds[blipCategory]
    if not blipTbl then return end

    for i=1, #blipTbl do
        RemoveBlip(blipTbl[i])
    end

    blipIds[blipCategory] = nil
end

--- Unloads all category blips.
function UnloadCategoryBlips()
    for blipCategory, _ in pairs(blipIds) do
        UnloadBlipCategory(blipCategory)
    end
end

--- Loads a categories blips.
---@param blipCategory string The category to load.
function LoadBlipCategory(blipCategory)
    UnloadBlipCategory(blipCategory)

    blipIds[blipCategory] = {}
    local categoryTbl = Config.Blips[blipCategory]
    if not categoryTbl then return end

    for i=1, #categoryTbl do
        local blipId = CreateBlip(GetBlipConfig(blipCategory, i))
        table.insert(blipIds[blipCategory], blipId)
    end
end

--- Loads all category blips.
function LoadCategoryBlips()
    for blipCategory, enabled in pairs(CategoryBlips) do
        if enabled then
            LoadBlipCategory(blipCategory)
        else
            UnloadBlipCategory(blipCategory)
        end
    end
end

--- Sets a categories enable state and handles the change.
---@param category string The category to edit.
---@param enabled boolean The enable state to set.
function SetBlipCategoryEnabled(category, enabled)
    if GetBlipCategoryState(category) == enabled then return false end

    -- Update setting and save.
    CategoryBlips[category] = enabled
    SaveTableToJson("settings" .. ((Config.UseUniqueSave and "@" .. Config.UniqueSaveName) or ""), CategoryBlips)

    -- Load/Unload based on the new state.
    if enabled then
        LoadBlipCategory(category)
    else
        UnloadBlipCategory(category)
    end

    return true
end

--- Gets a categories enable state.
---@param category string The category to get the state of.
---@return boolean Whether or not it is enabled.
function GetBlipCategoryState(category)
    return CategoryBlips[category]
end