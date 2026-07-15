--[[
World type notes.

This file documents future Lua data shapes. It intentionally does not enforce
types or create gameplay data in Phase 1.

WorldDefinition:
{
    schemaVersion = 1,
    id = "kobold_survival_default",
    name = "Kobold Survival Default World",
    grid = {
        tileSize = 128,
        width = 128,
        height = 128,
        origin = { x = 0, y = 0 },
    },
    regions = { RegionDefinition, ... },
}

Tile:
{
    gridX = 12,
    gridY = 18,
    worldX = 1536,
    worldY = 2304,
    biome = "forest",
    terrain = "grass",
    elevation = 2,
    walkable = true,
    buildable = true,
    regionId = "northern_forest",
    resources = { "node_ordinary_tree", "node_berry_bush" },
    spawnTags = { "wildlife" },
}

TribeRules:
{
    schemaVersion = 1,
    defaultTribeCount = 2,
    supportedTribeCounts = { 2, 3, 4 },
    tribes = { TribeDefinition, ... },
}

TribeDefinition:
{
    id = "tribe_north",
    displayName = "Northern Tribe",
    dotaTeam = "DOTA_TEAM_GOODGUYS",
    color = { r = 78, g = 176, b = 255 },
}
]]

local WorldTypes = {}

return WorldTypes
