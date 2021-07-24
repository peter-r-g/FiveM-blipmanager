--- Table defining error chat messages.
local errorMessage = {
    color = { 255, 0, 0 },
    multiline = true,
    args = { "Error" }
}
--- Table defining regular chat messages.
local message = {
    color = { 255, 255, 255 },
    multiline = true,
    args = {}
}

--- Outputs an error message to the chatbox.
---@param msg string The message to send in the chatbox.
local function ErrorMessage(msg)
    errorMessage.args[2] = msg
    TriggerEvent("chat:addMessage", errorMessage)
end

--- Outputs a regular message to the chatbox.
---@param msg string The message to send in the chatbox.
local function Message(msg)
    message.args[1] = msg
    TriggerEvent("chat:addMessage", message)
end

--- Shows the enabled state of all category and user blips to the user.
local function ShowBlipStates()
    -- Build categories text.
    local msg = "Categories: "
    for category, enabled in pairs(CategoryBlips) do
        msg = msg .. ("^3%s^7 are %s^7, "):format(category, enabled and "^2enabled" or "^1disabled")
    end
    msg = msg:sub(0, #msg-2)

    -- Build user blip text.
    msg = msg .. "\nUser Blips: "
    local userBlipAdded = false
    for blipText, blipPos in pairs(UserBlips) do
        msg = msg .. ("^3%s^7 is %s^7, "):format(blipText, GetUserBlipState(blipText) and "^2enabled" or "^1disabled")
        userBlipAdded = true
    end

    -- Trim message and remove "User Blips: " if there are no user blips to show.
    if userBlipAdded then
        msg = msg:sub(0, #msg-2)
    else
        msg = msg:sub(0, #msg-13)
    end

    Message(msg)
end

--- Table defining all the valid state changing operations.
local stateOperations = {
    ["enable"] = function(currentState)
        return true
    end,
    ["disable"] = function(currentState)
        return false
    end,
    ["toggle"] = function(currentState)
        return not currentState
    end
}

--- Blips chat command
---@param source number The players server ID.
---@param args table The arguments for the command split by " "
RegisterCommand("blips", function(source, args)
    -- Show blip states if no arguments are passed.
    if #args == 0 or args[1] == "" then
        ShowBlipStates()
        return
    end

    local operation = string.lower(args[1])
    -- Reset settings.
    if operation == "reset" then
        ResetSettings()
        Message("Your blip settings have been set to default")
    -- Check if sub-command is a state operation.
    elseif stateOperations[operation] then
        -- Get the identifier/label provided.
        local blipIdentifier = table.concat(args, " ", 2)

        -- Check if valid category group.
        if CategoryBlips[blipIdentifier] ~= nil then
            local desiredState = stateOperations[operation](GetBlipCategoryState(blipIdentifier))
            if SetBlipCategoryEnabled(blipIdentifier, desiredState) then
                Message(("Set ^3%s^7 blips to %s"):format(blipIdentifier, desiredState and "^2enabled" or "^1disabled"))
            else
                ErrorMessage(("^3%s^7 blips are already %s"):format(blipIdentifier, desiredState and "^2enabled" or "^1disabled"))
            end
        -- Check if valid user created blip.
        elseif UserBlips[blipIdentifier] then
            local desiredState = stateOperations[operation](GetUserBlipState(blipIdentifier))
            if SetUserBlipEnabled(blipIdentifier, desiredState) then
                Message(("Set ^3%s^7 to %s"):format(blipIdentifier, desiredState and "^2enabled" or "^1disabled"))
            else
                ErrorMessage(("^3%s^7 is already %s"):format(blipIdentifier, desiredState and "^2enabled" or "^1disabled"))
            end
        else
            ErrorMessage(("No category or user created blip with the label \"%s\" exists"):format(blipIdentifier))
        end
    -- Unknown sub-command given.
    else
        ErrorMessage(("Got unrecognized option ^3%s"):format(operation))
    end
end, false)

--- Blipadd chat command
---@param source number The players server ID.
---@param args table The arguments for the command split by " "
RegisterCommand("blipadd", function(source, args)
    -- Ignore command if user blips are disabled.
    if not Config.AllowUserBlips then
        ErrorMessage("User created blips have been disabled")
        return
    end

    if not args or args[1] == "" then
        ErrorMessage("Expected a label for the new blip")
        return
    end

    local label = table.concat(args, " ", 1)
    if AddUserBlip(label, GetEntityCoords(GetPlayerPed(-1))) then
        Message(("A blip with the label ^3%s^7 has been ^2created^7 at your position"):format(label))
    else
        ErrorMessage(("A blip with the label ^3%s^7 already exists"):format(label))
    end
end, false)

--- Blipdel chat command
---@param source number The players server ID.
---@param args table The arguments for the command split by " "
RegisterCommand("blipdel", function(source, args)
    -- Ignore command if user blips are disabled.
    if not Config.AllowUserBlips then
        ErrorMessage("User created blips have been disabled")
        return
    end

    if not args or args[1] == "" then
        ErrorMessage("Expected a label of a blip to delete")
        return
    end

    local label = table.concat(args, " ", 1)
    if RemoveUserBlip(label) then
        Message(("A blip with the label ^3%s^7 has been ^1deleted"):format(label))
    else
        ErrorMessage(("No blip with the label ^3%s^7 exists"):format(label))
    end
end, false)

-- Only enable these commands on debug mode.
if Config.Debug then

    --- Pos chat command
    ---@param source number The players server ID.
    RegisterCommand("pos", function(source)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local posText  = ("x=^3%f^7, y=^3%f^7, z=^3%f"):format(pos.x, pos.y, pos.z)

        print(posText)
        Message(posText)
    end, false)
    
    --- Waypos chat command
    ---@param source number The players server ID.
    RegisterCommand("waypos", function(source)
        local blipId = GetFirstBlipInfoId(8)
        if blipId == 0 then
            ErrorMessage("There is no waypoint set to get a position from")
            return
        end

        local pos = GetBlipCoords(blipId)
        local posText  = ("x=^3%f^7, y=^3%f^7, z=^3%f"):format(pos.x, pos.y, pos.z)

        print(posText)
        Message(posText)
    end, false)

end