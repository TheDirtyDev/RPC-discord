-- ===============================
--          DISCORD RPC CONFIG
-- ===============================

local config = {
    appid = "", -- Get this from https://discord.com/developers/applications
    largeImage = "", -- Name of the large image you uploaded in Discord Rich Presence
    smallImage = "", -- Name of the small image you uploaded in Discord Rich Presence
    discordInvite = "", -- Discord invite link
    serverConnect = "", -- Connect link for your server
    updateRate = 2000 -- Update rate in milliseconds (2000ms = 2 seconds)
}

-- ===============================
--     DO NOT TOUCH BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING
-- ===============================

-- Street Name Function
local function GetStreetName()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    return GetStreetNameFromHashKey(streetHash)
end

-- Status Function 
local function GetPlayerStatus()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local speed = GetEntitySpeed(veh) * 2.23694 -- Convert m/s to MPH
        return string.format("%d MPH", speed)
    else
        return "On Foot"
    end
end

-- Get player count Function
local function GetPlayerCount()
    local count = 0
    for i = 0, 128 do
        if NetworkIsPlayerActive(i) then
            count = count + 1
        end
    end
    return count
end

-- Discord Function
local function SetupDiscord()
    SetDiscordAppId(config.appid)
    SetDiscordRichPresenceAsset(config.largeImage)
    SetDiscordRichPresenceAssetSmall(config.smallImage)
end

-- Main Thread
CreateThread(function()
    while true do
        Wait(config.updateRate)

        SetupDiscord()

        local name = GetPlayerName(PlayerId())
        local street = GetStreetName()
        local status = GetPlayerStatus()
        local players = GetPlayerCount()

        SetRichPresence(string.format(
            "%s | %s | %s | %d Players",
            name,
            street,
            status,
            players
        ))

        SetDiscordRichPresenceAction(0, "Join Discord", config.discordInvite)
        SetDiscordRichPresenceAction(1, "Connect", config.serverConnect)
    end
end)
