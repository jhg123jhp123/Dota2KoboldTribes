local TileRegistry = {}
TileRegistry.__index = TileRegistry

function TileRegistry.New(runtimeData)
    assert(type(runtimeData) == "table", "runtimeData is required")
    return setmetatable({
        runtimeData = runtimeData,
        grid = runtimeData.grid,
        tiles = runtimeData.tiles or {},
    }, TileRegistry)
end

function TileRegistry:GetTile(gridX, gridY)
    return self.tiles[self:TileKey(gridX, gridY)]
end

function TileRegistry:GetTileAtPosition(worldPosition)
    local gridX, gridY = self:WorldToGrid(worldPosition)
    return self:GetTile(gridX, gridY)
end

function TileRegistry:GridToWorld(gridX, gridY)
    local origin = self.grid.origin or { x = 0, y = 0 }
    local tileSize = self.grid.tileSize
    local x = origin.x + (gridX + 0.5) * tileSize
    local y = origin.y + (gridY + 0.5) * tileSize

    if Vector ~= nil then
        return Vector(x, y, 0)
    end

    return { x = x, y = y, z = 0 }
end

function TileRegistry:WorldToGrid(worldPosition)
    local origin = self.grid.origin or { x = 0, y = 0 }
    local tileSize = self.grid.tileSize
    local x = worldPosition.x or worldPosition[1] or 0
    local y = worldPosition.y or worldPosition[2] or 0

    return math.floor((x - origin.x) / tileSize), math.floor((y - origin.y) / tileSize)
end

function TileRegistry:GetElevation(gridX, gridY)
    local tile = self:GetTile(gridX, gridY)
    return tile and tile.elevation or 0
end

function TileRegistry:IsWalkable(gridX, gridY)
    local tile = self:GetTile(gridX, gridY)
    return tile ~= nil and tile.walkable == true
end

function TileRegistry:IsBuildable(gridX, gridY)
    local tile = self:GetTile(gridX, gridY)
    return tile ~= nil and tile.buildable == true
end

function TileRegistry:GetBiome(gridX, gridY)
    local tile = self:GetTile(gridX, gridY)
    return tile and tile.biome or nil
end

function TileRegistry:GetResources(gridX, gridY)
    local tile = self:GetTile(gridX, gridY)
    return tile and tile.resources or {}
end

function TileRegistry:GetNearbyTiles(gridX, gridY, radius)
    radius = radius or 1
    local tiles = {}

    for x = gridX - radius, gridX + radius do
        for y = gridY - radius, gridY + radius do
            local tile = self:GetTile(x, y)
            if tile ~= nil then
                tiles[#tiles + 1] = tile
            end
        end
    end

    return tiles
end

function TileRegistry:GetSpawnPoints(filters)
    filters = filters or {}
    local points = {}
    local runtimeData = self.runtimeData

    local source = runtimeData.tribeStarts
    if filters.kind == "resources" then
        source = runtimeData.resourceSpawns
    elseif filters.kind == "wildlife" then
        source = runtimeData.wildlifeSpawns
    elseif filters.kind == "boss" then
        source = runtimeData.bossArenas
    end

    for _, point in ipairs(source or {}) do
        if filters.teamHint == nil or filters.teamHint == point.teamHint then
            points[#points + 1] = point
        end
    end

    return points
end

function TileRegistry:TileKey(x, y)
    return tostring(x) .. ":" .. tostring(y)
end

return TileRegistry
