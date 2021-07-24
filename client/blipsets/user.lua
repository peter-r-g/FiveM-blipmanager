--- The table containing user made blip IDs.
local userBlipIds = {}
--- Localized config function.
local GetUserBlipConfig = Config.GetUserBlipConfig

--- Helper function to save user blips.
local function SaveUserBlips()
    SaveTableToJson("userBlips@" .. Config.UniqueSaveName, UserBlips)
end

--- Creates a user blip if they're enabled.
---@param blipText string The label to attach to the blip.
---@param blipPos table The Vector3 position to place the blip at.
local function CreateUserBlip(blipText, blipPos)
    if not Config.AllowUserBlips then return end

    userBlipIds[blipText] = CreateBlip(GetUserBlipConfig(blipPos, blipText))
end

--- Unloads all user blips.
function UnloadUserBlips()
    for blipText, blipId in pairs(userBlipIds) do
        RemoveBlip(blipId)
        userBlipIds[blipText] = nil
    end
end

--- Lodas all user blips.
function LoadUserBlips()
    if not Config.AllowUserBlips then return end

    for blipText, blipPos in pairs(UserBlips) do
        CreateUserBlip(blipText, blipPos)
    end
end

--- Adds a new user blip.
---@param blipText string The label to attach to the blip.
---@param blipPos table The Vector3 position to place the blip at.
---@return boolean Whether or not the blip was added.
function AddUserBlip(blipText, blipPos)
    if UserBlips[blipText] then return false end

    userBlipIds[blipText] = CreateUserBlip(blipText, blipPos)
    UserBlips[blipText] = blipPos
    SaveUserBlips()

    return true
end

--- Remvoes an existing user blip.
---@param blipText string The label that was attached to the blip.
---@return boolean Whether or not the blip was removed.
function RemoveUserBlip(blipText)
    if not UserBlips[blipText] then return false end

    RemoveBlip(userBlipIds[blipText])
    userBlipIds[blipText] = nil
    UserBlips[blipText] = nil
    SaveUserBlips()

    return true
end

--- Sets whether or not a user blip should be enabled and handles the change.
---@param blipText string The label that was attached to the blip.
---@param enabled boolean Whether or not to enable the blip.
---@return boolean Whether or not changing its state succeeded.
function SetUserBlipEnabled(blipText, enabled)
    if GetUserBlipState(blipText) == enabled then return false end

    if enabled then
        userBlipIds[blipText] = CreateBlip(GetUserBlipConfig(UserBlips[blipText], blipText))
    else
        RemoveBlip(userBlipIds[blipText])
        userBlipIds[blipText] = nil
    end

    return true
end

--- Returns the current enable state of a user blip.
---@param blipText string The label that was attached to the blip.
---@return boolean Whether or not the user blip is enabled.
function GetUserBlipState(blipText)
    return not not userBlipIds[blipText]
end