Config = {}

-- Whether or not users can create their own blips with /blipadd and remove them with /blipremove.
Config.AllowUserBlips = true

-- Set this to true to have a "/pos" and "/waypos" command to get the position of where your player is currently standing and where your current waypoint is.
-- Useful for setting up positions in blips.
Config.Debug = true

-- The table containing all of the blips you want on the map.
Config.Blips = {
    --[[
    -- The name of the category these blips are under.
    ["Example"] = {
        -- Whether or not these blips should be visible by default.
        defaultEnabled = true,
        -- Any options in this table will overwrite Config.DefaultBlip for this category.
        blip = {
            color = 4
        },
        -- After this point any table will be a blip. Options in this table will overwrite Config.DefaultBlip and the category blip options.
        {
            pos = vector3(1, 1, 1)
            sprite = 101,
            text = "Some Blip"
        },
        {
            pos = vector3(2, 2, 2),
            sprite = 123,
            text = "Another Blip"
        }
    }
    ]]--

    ["Structures"] = {
        defaultEnabled = true,
        {
            color = 2,
            pos = vector3(-545, -203.5, -38.2),
            sprite = 176,
            text = "City Hall"
        }
    },
    ["Gas Stations"] = {
        defaultEnabled = false,
        blip = {
            sprite = 415,
            text = "Gas Station"
        },
        { pos = vector3(259.4, -1263.8, 29.1) },
        { pos = vector3(-724.7, -935.6, 19.1) }
    }
}

-- Whether or not a users settings should be saved with a unique name.
Config.UseUniqueSave = false
-- The unique name to attach to the saved settings.
Config.UniqueSaveName = "SomeRPServer"

--[[ Blip Settings. ]]--

-- The settings for all blips. This can be overriden on a blip-by-blip basis.
Config.DefaultBlip = {
    -- The index of the hex color to use for the blip. See http://www.kronzky.info/fivemwiki/index.php/SetBlipColour
    color = 0,
    -- Whether or not the blip should show up on the right side of the GPS legend.
    hiddenOnLegend = false,
    -- Whether or not a higher detail version of the sprite should be used.
    highDetail =true,
    -- The position in the world to place the blip.
    pos = vector3(0, 0, 0),
    -- The scale at which to display the sprite.
    scale = 1.0,
    -- Whether or not the sprite should show up outside of the minimap view.
    shortRange = true,
    -- The sprite to use. See https://docs.fivem.net/docs/game-references/blips/
    sprite = 0,
    -- The text to show in the legend entry for the blip.
    text = "Blip"
}

-- The settings for all user blips. This overrides DefaultBlip options.
-- NOTE: pos and text options will be ignored.
Config.UserBlip = {
    sprite = 1
}

-- Don't edit past this point. --
Config.GetBlipConfig = function(category, index)
    local finishedBlipConfig = {}
    local defaultBlipConfig = Config.DefaultBlip
    local categoryBlipConfig = Config.Blips[category].blip or {}
    local blipConfig = Config.Blips[category][index] or {}

    finishedBlipConfig.color = blipConfig.color or categoryBlipConfig.color or defaultBlipConfig.color
    finishedBlipConfig.hiddenOnLegend = blipConfig.hiddenOnLegend or categoryBlipConfig.hiddenOnLegend or defaultBlipConfig.hiddenOnLegend
    finishedBlipConfig.highDetail = blipConfig.highDetail or categoryBlipConfig.highDetail or defaultBlipConfig.highDetail
    finishedBlipConfig.pos = blipConfig.pos or categoryBlipConfig.pos or defaultBlipConfig.pos
    finishedBlipConfig.scale = blipConfig.scale or categoryBlipConfig.scale or defaultBlipConfig.scale
    finishedBlipConfig.shortRange = blipConfig.shortRange or categoryBlipConfig.shortRange or defaultBlipConfig.shortRange
    finishedBlipConfig.sprite = blipConfig.sprite or categoryBlipConfig.sprite or defaultBlipConfig.sprite
    finishedBlipConfig.text = blipConfig.text or categoryBlipConfig.text or defaultBlipConfig.text

    return finishedBlipConfig
end

Config.GetUserBlipConfig = function(pos, text)
    local finishedBlipConfig = {}
    local defaultBlipConfig = Config.DefaultBlip
    local userBlipConfig = Config.UserBlip or {}

    finishedBlipConfig.color = userBlipConfig.color or defaultBlipConfig.color
    finishedBlipConfig.hiddenOnLegend = userBlipConfig.hiddenOnLegend or defaultBlipConfig.hiddenOnLegend
    finishedBlipConfig.highDetail = userBlipConfig.highDetail or defaultBlipConfig.highDetail
    finishedBlipConfig.scale = userBlipConfig.scale or defaultBlipConfig.scale
    finishedBlipConfig.shortRange = userBlipConfig.shortRange or defaultBlipConfig.shortRange
    finishedBlipConfig.sprite = userBlipConfig.sprite or defaultBlipConfig.sprite

    finishedBlipConfig.pos = pos
    finishedBlipConfig.text = text

    return finishedBlipConfig
end

if Config.Debug then

    print("Blips: Debug mode is enabled, is this intended?")

end