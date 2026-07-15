--[[
Tribe configuration contract.

This file is data only. It documents how the project should represent 2, 3,
and 4 tribe configurations once team setup is implemented.
]]

return {
    schemaVersion = 1,
    defaultTribeCount = 2,
    supportedTribeCounts = { 2, 3, 4 },
    firstPlayableBuildTeamCount = 2,
    minPlayersPerTribe = 1,
    maxPlayersPerTribe = "TODO_DESIGN_CONFIRMATION_5_OR_6",

    tribes = {
        {
            id = "tribe_north",
            displayName = "Northern Tribe",
            dotaTeam = "DOTA_TEAM_GOODGUYS",
            initialSupport = true,
            color = {
                r = 78,
                g = 176,
                b = 255,
            },
        },
        {
            id = "tribe_south",
            displayName = "Southern Tribe",
            dotaTeam = "DOTA_TEAM_BADGUYS",
            initialSupport = true,
            color = {
                r = 255,
                g = 96,
                b = 78,
            },
        },
        {
            id = "tribe_east",
            displayName = "Eastern Tribe",
            dotaTeam = "DOTA_TEAM_CUSTOM_1",
            initialSupport = false,
            color = {
                r = 255,
                g = 198,
                b = 72,
            },
        },
        {
            id = "tribe_west",
            displayName = "Western Tribe",
            dotaTeam = "DOTA_TEAM_CUSTOM_2",
            initialSupport = false,
            color = {
                r = 112,
                g = 214,
                b = 112,
            },
        },
    },
}
