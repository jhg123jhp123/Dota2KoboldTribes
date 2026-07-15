local SpawnService = {}
SpawnService.__index = SpawnService

local RESOURCE_UNIT_BY_ID = {
    node_ordinary_tree = "npc_kobold_node_ordinary_tree",
    node_elder_tree = "npc_kobold_node_elder_tree",
    node_stone_deposit = "npc_kobold_node_stone_deposit",
    node_gold_deposit = "npc_kobold_node_gold_deposit",
    node_iron_deposit = "npc_kobold_node_iron_deposit",
    node_shadowstone_source = "npc_kobold_node_shadowstone_source",
    node_radiant_gemstone_source = "npc_kobold_node_radiant_gemstone_source",
    node_berry_bush = "npc_kobold_node_berry_bush",
    node_spicy_herbs = "npc_kobold_node_spicy_herbs",
    node_sageberry = "npc_kobold_node_sageberry",
    node_lambent_sunflower = "npc_kobold_node_lambent_sunflower",
}

local WILDLIFE_UNIT_BY_ID = {
    animal_sheep = "npc_kobold_animal_sheep",
    animal_pheasant = "npc_kobold_animal_pheasant",
    animal_wolf = "npc_kobold_animal_wolf",
    animal_dire_wolf = "npc_kobold_animal_dire_wolf",
    animal_bear = "npc_kobold_animal_bear",
    animal_stag = "npc_kobold_animal_stag",
}

local RESOURCE_OFFSETS = {
    Vector(-420, -260, 0),
    Vector(-260, 360, 0),
    Vector(220, -360, 0),
    Vector(380, 240, 0),
    Vector(620, 0, 0),
}

function SpawnService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        tileRegistry = options.tileRegistry,
        spawned = false,
        spawnedUnits = {},
    }, SpawnService)
end

function SpawnService:SpawnInitialWorld()
    if self.spawned or CreateUnitByName == nil or self.tileRegistry == nil then
        return
    end

    self.spawned = true
    self:SpawnTribeStartResources()
    self:SpawnCentralResources()
    self:SpawnWildlife()
end

function SpawnService:SpawnTribeStartResources()
    local starts = self.tileRegistry:GetSpawnPoints({})
    local resourceIds = {
        "node_ordinary_tree",
        "node_stone_deposit",
        "node_berry_bush",
        "node_ordinary_tree",
        "node_spicy_herbs",
    }

    for _, start in ipairs(starts) do
        local origin = self.tileRegistry:GridToWorld(start.position.x, start.position.y)
        for index, resourceId in ipairs(resourceIds) do
            self:SpawnResource(resourceId, origin + RESOURCE_OFFSETS[index])
        end
        self:SpawnUnit("npc_kobold_building_revival_shrine", origin + Vector(0, 520, 0), DOTA_TEAM_NEUTRALS)
    end
end

function SpawnService:SpawnCentralResources()
    local resourceSpawns = self.tileRegistry:GetSpawnPoints({ kind = "resources" })
    local spawned = 0

    for _, spawn in ipairs(resourceSpawns) do
        if spawn.resourceId ~= nil and spawned < 12 then
            local point = self.tileRegistry:GridToWorld(spawn.position.x, spawn.position.y)
            local offset = Vector((spawned % 4) * 180 - 270, math.floor(spawned / 4) * 180 - 180, 0)
            self:SpawnResource(spawn.resourceId, point + offset)
            spawned = spawned + 1
        end
    end
end

function SpawnService:SpawnWildlife()
    local wildlifeSpawns = self.tileRegistry:GetSpawnPoints({ kind = "wildlife" })
    local spawned = 0

    for _, spawn in ipairs(wildlifeSpawns) do
        local unitName = WILDLIFE_UNIT_BY_ID[spawn.unitId]
        if unitName ~= nil and spawned < 8 then
            local point = self.tileRegistry:GridToWorld(spawn.position.x, spawn.position.y)
            self:SpawnUnit(unitName, point + Vector(spawned * 120 - 360, 300, 0), DOTA_TEAM_NEUTRALS)
            spawned = spawned + 1
        end
    end
end

function SpawnService:SpawnResource(resourceId, point)
    local unitName = RESOURCE_UNIT_BY_ID[resourceId]
    if unitName == nil then
        return nil
    end

    local unit = self:SpawnUnit(unitName, point, DOTA_TEAM_NEUTRALS)
    if unit ~= nil then
        unit.koboldResourceNodeId = resourceId
    end

    return unit
end

function SpawnService:SpawnUnit(unitName, point, team)
    local unit = CreateUnitByName(unitName, point, true, nil, nil, team or DOTA_TEAM_NEUTRALS)
    if unit ~= nil then
        self.spawnedUnits[#self.spawnedUnits + 1] = unit
        local ai = self.context and self.context:GetService("ai") or nil
        if ai ~= nil then
            ai:RegisterUnit(unit)
        end
    end

    return unit
end

function SpawnService:SpawnBoss(bossId, point)
    local unitNameByBossId = {
        boss_raging_arcane_beast = "npc_kobold_boss_raging_arcane_beast",
    }

    local unitName = unitNameByBossId[bossId]
    if unitName == nil then
        return nil
    end

    return self:SpawnUnit(unitName, point, DOTA_TEAM_NEUTRALS)
end

return SpawnService
