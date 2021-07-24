--- The table containing all custom blips and their IDs.
local customBlips = {}
--- The list of settings that a custom blip can have.
local validSettings = {
    alpha = function(blipId, value)
        SetBlipAlpha(blipId, value)
    end,
    color = function(blipId, value)
        SetBlipColour(blipId, value)
    end,
    fade = function(blipId, value)
        SetBlipFade(blipId, value.opacity, value.duration)
    end,
    hiddenOnLegend = function(blipId, value)
        SetBlipHiddenOnLegend(blipId, value)
    end,
    highDetail = function(blipId, value)
        SetBlipHighDetail(blipId, value)
    end,
    pos = function(blipId, value)
        SetBlipCoords(blipId, value.x, value.y, value.z)
    end,
    rotation = function(blipId, value)
        SetBlipRotation(blipId, value)
    end,
    route = function(blipId, value)
        SetBlipRoute(blipId, value)
    end,
    routeColor = function(blipId, value)
        SetBlipRouteColour(blipId, value)
    end,
    scale = function(blipId, value)
        SetBlipScale(blipId, value)
    end,
    shortRange = function(blipId, value)
        SetBlipAsShortRange(blipId, value)
    end,
    sprite = function(blipId, value)
        SetBlipSprite(blipId, value)
    end,
    text = function(blipId, value)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(value)
        EndTextCommandSetBlipName(blipId)
    end
}

--- Creates and sets up a custom blip based on the blip provided.
---@param blipIdentifier string The custom blip identifier.
local function CreateCustomBlip(blipIdentifier)
    -- Check if the blip actually exists.
    if not customBlips[blipIdentifier] then return end

    -- Get blip information and create it.
    local blipSettings = customBlips[blipIdentifier].settings
    local blipId = AddBlipForCoord(blipSettings.pos.x, blipSettings.pos.y, blipSettings.pos.z)

    -- Setup all blip settings.
    for setting, value in pairs(blipSettings) do
        if validSettings[setting] then
            validSettings[setting](blipId, value)
        end
    end

    -- Save blip ID.
    customBlips[blipIdentifier].blipId = blipId
end

--- Adds a new custom blip.
---@param blipIdentifier string The unique identifier to give the blip.
---@param blipTbl table A table defining the blips information.
---@return boolean Whether or not adding the blip succeeded.
function AddCustomBlip(blipIdentifier, blipTbl)
    -- If the blip already exists then delete it so it can be re-created.
    if customBlips[blipIdentifier] then
        RemoveCustomBlip(blipIdentifier)
    end

    customBlips[blipIdentifier] = {}
    customBlips[blipIdentifier].settings = blipTbl
    CreateCustomBlip(blipIdentifier)

    return true
end

--- Removes an existing custom blip.
---@param blipIdentifier string The unique identifier of the blip to remove.
---@return boolean Whether or not the blip was removed.
function RemoveCustomBlip(blipIdentifier)
if not customBlips[blipIdentifier] then return nil end

RemoveBlip(customBlips[blipIdentifier].blipId)
customBlips[blipIdentifier] = nil

return true
end

--- Returns whether or not a custom blip exists.
---@param blipIdentifier string The unique identifier of a blip.
---@return boolean Whether or not a custom blip with the identifier provided exists.
function CustomBlipExists(blipIdentifier)
    return not not customBlips[blipIdentifier]
end

--- Edits an already existing custom blip.
---@param blipIdentifier string The unique identifier of the blip.
---@param newBlipTbl table The new table to assign the blip.
---@return boolean Whether or not editing the blip succeeded.
function EditCustomBlip(blipIdentifier, newBlipTbl)
    return AddCustomBlip(blipIdentifier, newBlipTbl)
end

--- Sets a specified parameter on an existing custom blip.
---@param blipIdentifier string The unique identifier of a blip.
---@param key string The parameter to edit.
---@param value any The value to set in the parameter.
---@return boolean Whether or not setting the parameter succeeded.
function SetCustomBlipParameter(blipIdentifier, key, value)
    if not customBlips[blipIdentifier] then return false end

    customBlips[blipIdentifier].settings[key] = value
    if validSettings[key] then
        validSettings[key](customBlips[blipIdentifier].blipId, value)
    end

    return true
end

--- Returns the value of the specified parameter.
---@param blipIdentifier string The unique identifier of a blip.
---@param key string The parameter to get.
---@return any The value currently set on the parameter.
function GetCustomBlipParameter(blipIdentifier, key)
    if not customBlips[blipIdentifier] then return nil end

    return customBlips[blipIdentifier].settings[key]
end

--- Returns the blip ID of the custom blip.
---@param blipIdentifier string The unique identifier of a blip.
---@return number The blip ID.
function GetCustomBlipId(blipIdentifier)
    if not customBlips[blipIdentifier] then return nil end

    return customBlips[blipIdentifier].blipId
end