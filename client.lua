-- ===================================================
--          DISCORD RPC CONFIG / Credits: the.dirtydev
-- ====================================================

local config = {
    appid = "",
    largeImage = "",
    smallImage = "",
    discordInvite = "", 
    serverConnect = "",
    updateRate = 5000 -- 5 seconds (no need for a spam)
}

-- =================== DO NOT TOUCH BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING  =======================

-- Street Name
local function GetStreetName()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    return GetStreetNameFromHashKey(streetHash)
end

-- Player Status
local function GetPlayerStatus()
    local ped = PlayerPedId()

    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        local speed = GetEntitySpeed(veh) * 2.23694
        return string.format("%d MPH", speed)
    else
        return "On Foot"
    end
end

-- Get Synced Player Count From Server (UPDATED SECTION 1.3)
local function GetPlayerCount()
    if GlobalState.rpc and GlobalState.rpc[1] then
        return GlobalState.rpc[1]
    end
    return 0
end


-- Discord Function
local function SetupDiscord()
    SetDiscordAppId(config.appid)
    SetDiscordRichPresenceAsset(config.largeImage)
    SetDiscordRichPresenceAssetSmall(config.smallImage)
end


-- Main Thread
CreateThread(function()

    SetupDiscord() 

    while true do
        Wait(config.updateRate)

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
