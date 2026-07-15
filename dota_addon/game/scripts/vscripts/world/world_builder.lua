local WorldBuilder = {}
WorldBuilder.__index = WorldBuilder

function WorldBuilder.New(options)
    options = options or {}

    return setmetatable({
        logger = options.logger,
    }, WorldBuilder)
end

function WorldBuilder:LoadDefinition(moduleName)
    assert(type(moduleName) == "string" and moduleName ~= "", "moduleName is required")
    return require(moduleName)
end

function WorldBuilder:LoadDefinitionTable(definition)
    self:ValidateDefinition(definition)
    return self:BuildRuntimeData(definition)
end

function WorldBuilder:ValidateDefinition(definition)
    assert(type(definition) == "table", "world definition must be a table")
    assert(type(definition.grid) == "table", "world definition requires grid")
    assert(type(definition.regions) == "table", "world definition requires regions")
    assert(type(definition.grid.width) == "number", "world grid width is required")
    assert(type(definition.grid.height) == "number", "world grid height is required")
    assert(type(definition.grid.tileSize) == "number", "world grid tileSize is required")

    for _, region in ipairs(definition.regions) do
        assert(type(region.id) == "string", "region requires id")
        assert(type(region.bounds) == "table", "region requires bounds")
        assert(type(region.bounds.x1) == "number", "region bounds require x1")
        assert(type(region.bounds.y1) == "number", "region bounds require y1")
        assert(type(region.bounds.x2) == "number", "region bounds require x2")
        assert(type(region.bounds.y2) == "number", "region bounds require y2")
    end

    return true
end

function WorldBuilder:BuildRuntimeData(definition)
    self:ValidateDefinition(definition)

    local runtimeData = {
        id = definition.id,
        name = definition.name,
        grid = definition.grid,
        tiles = {},
        regions = definition.regions,
        tribeStarts = {},
        resourceSpawns = {},
        wildlifeSpawns = {},
        bossArenas = {},
    }

    self:GenerateTerrain(runtimeData, definition)
    self:PlaceResources(runtimeData, definition)
    self:PlaceWildlifeSpawners(runtimeData, definition)
    self:PlaceBossArenas(runtimeData, definition)
    self:PlaceTribeStarts(runtimeData, definition)

    return runtimeData
end

function WorldBuilder:GenerateTerrain(runtimeData, definition)
    local regionsByPriority = {}
    for _, region in ipairs(definition.regions) do
        regionsByPriority[#regionsByPriority + 1] = region
    end

    table.sort(regionsByPriority, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)

    for x = 0, definition.grid.width - 1 do
        for y = 0, definition.grid.height - 1 do
            local region = self:FindRegionForGrid(regionsByPriority, x, y)
            local tile = {
                x = x,
                y = y,
                regionId = region and region.id or "wilds",
                biome = region and region.biome or "wilds",
                terrain = region and region.terrain or "grass",
                elevation = region and region.elevation and region.elevation.min or 0,
                walkable = true,
                buildable = region ~= nil,
                resources = region and region.resourceRules or {},
                wildlife = region and region.wildlifeRules or {},
                spawnTags = {},
            }

            runtimeData.tiles[self:TileKey(x, y)] = tile
        end
    end
end

function WorldBuilder:PlaceResources(runtimeData, definition)
    for _, region in ipairs(definition.regions) do
        for _, rule in ipairs(region.resourceRules or {}) do
            local center = self:GetRegionCenter(region)
            runtimeData.resourceSpawns[#runtimeData.resourceSpawns + 1] = {
                regionId = region.id,
                resourceId = rule.resourceId,
                weight = rule.weight or 1,
                position = center,
                spawnTags = rule.spawnTags or {},
            }
        end
    end
end

function WorldBuilder:PlaceDecorations(runtimeData, definition)
    runtimeData.decorations = {}
    for _, region in ipairs(definition.regions) do
        for _, propId in ipairs(region.decorativeProps or {}) do
            runtimeData.decorations[#runtimeData.decorations + 1] = {
                regionId = region.id,
                propId = propId,
                position = self:GetRegionCenter(region),
            }
        end
    end
end

function WorldBuilder:PlaceWildlifeSpawners(runtimeData, definition)
    for _, region in ipairs(definition.regions) do
        for _, rule in ipairs(region.wildlifeRules or {}) do
            runtimeData.wildlifeSpawns[#runtimeData.wildlifeSpawns + 1] = {
                regionId = region.id,
                unitId = rule.unitId,
                weight = rule.weight or 1,
                position = self:GetRegionCenter(region),
                spawnTag = rule.spawnTag,
                packSize = rule.packSize or { min = 1, max = 1 },
            }
        end
    end
end

function WorldBuilder:PlaceBossArenas(runtimeData, definition)
    for _, region in ipairs(definition.regions) do
        for _, arena in ipairs(region.bossArenas or {}) do
            runtimeData.bossArenas[#runtimeData.bossArenas + 1] = arena
        end
    end
end

function WorldBuilder:PlaceTribeStarts(runtimeData, definition)
    for _, region in ipairs(definition.regions) do
        for _, tribeStart in ipairs(region.tribeStarts or {}) do
            runtimeData.tribeStarts[#runtimeData.tribeStarts + 1] = tribeStart
        end
    end
end

function WorldBuilder:FindRegionForGrid(regions, x, y)
    for _, region in ipairs(regions) do
        local bounds = region.bounds
        if x >= bounds.x1 and x <= bounds.x2 and y >= bounds.y1 and y <= bounds.y2 then
            return region
        end
    end

    return nil
end

function WorldBuilder:GetRegionCenter(region)
    return {
        x = math.floor((region.bounds.x1 + region.bounds.x2) / 2),
        y = math.floor((region.bounds.y1 + region.bounds.y2) / 2),
    }
end

function WorldBuilder:TileKey(x, y)
    return tostring(x) .. ":" .. tostring(y)
end

return WorldBuilder
