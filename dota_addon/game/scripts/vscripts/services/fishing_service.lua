local FishingService = {}
FishingService.__index = FishingService

local WATER_TERRAINS = {
    deep_water = true,
    shallow_water = true,
    water = true,
    river = true,
    lake = true,
    shore = true,
    beach = true,
    swamp = true,
    marsh = true,
}

local CATCH_TABLE = {
    { itemName = "item_fish_striped_lurker", weight = 16 },
    { itemName = "item_fish_blind_rainfish", weight = 10 },
    { itemName = "item_fish_jewel_danio", weight = 12 },
    { itemName = "item_fish_fire_ammonite", weight = 12 },
    { itemName = "item_fish_forest_trout", weight = 16 },
    { itemName = "item_fish_highland_guppy", weight = 8 },
    { itemName = "item_fish_giant_sunfish", weight = 8, dayOnly = true },
    { itemName = "item_fish_slippery_eel", weight = 8 },
    { itemName = "item_fish_albino_cavefish", weight = 5 },
    { itemName = "item_fish_water_scorpion", weight = 3 },
    { itemName = "item_fish_toxic_frog", weight = 5 },
    { itemName = "item_fish_tiger_gourami", weight = 4 },
    { itemName = "item_fishing_murloc_treat", weight = 2 },
    { itemName = "item_utility_murlocket", weight = 1 },
}

function FishingService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        tileRegistry = options.tileRegistry,
        catchesByTeam = {},
        waterTilesExist = nil,
    }, FishingService)
end

function FishingService:Catch(caster, point, ability)
    if caster == nil or caster:IsNull() then
        return nil, "missing_caster"
    end

    if not self:IsFishingPoint(point) then
        return nil, "not_water"
    end

    local catch = self:RollCatch()
    if catch == nil then
        return nil, "empty_catch"
    end

    local item = self:CreateCatchItem(caster, catch.itemName)
    self:RecordCatch(caster, catch.itemName)

    local progression = self.context and self.context:GetService("progression") or nil
    if progression ~= nil then
        progression:AwardXp(caster, 12, "fishing")
    end

    return item, catch.itemName
end

function FishingService:IsFishingPoint(point)
    if point == nil or self.tileRegistry == nil then
        return true
    end

    local gridX, gridY = self.tileRegistry:WorldToGrid(point)
    for _, tile in ipairs(self.tileRegistry:GetNearbyTiles(gridX, gridY, 2)) do
        if WATER_TERRAINS[tile.terrain] or WATER_TERRAINS[tile.biome] then
            return true
        end
    end

    -- The starter placeholder world has no water terrain yet. Allow fishing
    -- during editor smoke tests until Hammer-authored terrain data exists.
    return not self:HasAnyWaterTiles()
end

function FishingService:HasAnyWaterTiles()
    if self.waterTilesExist ~= nil then
        return self.waterTilesExist
    end

    self.waterTilesExist = false
    if self.tileRegistry ~= nil then
        for _, tile in pairs(self.tileRegistry.tiles or {}) do
            if WATER_TERRAINS[tile.terrain] or WATER_TERRAINS[tile.biome] then
                self.waterTilesExist = true
                break
            end
        end
    end

    return self.waterTilesExist
end

function FishingService:RollCatch()
    local candidates = {}
    local totalWeight = 0
    local day = self:IsDay()

    for _, entry in ipairs(CATCH_TABLE) do
        if not entry.dayOnly or day then
            candidates[#candidates + 1] = entry
            totalWeight = totalWeight + entry.weight
        end
    end

    if totalWeight <= 0 then
        return nil
    end

    local roll = RandomInt(1, totalWeight)
    local running = 0
    for _, entry in ipairs(candidates) do
        running = running + entry.weight
        if roll <= running then
            return entry
        end
    end

    return candidates[#candidates]
end

function FishingService:CreateCatchItem(caster, itemName)
    if CreateItem == nil then
        print("[Kobold Survival][FishingService] caught " .. itemName)
        return nil
    end

    local item = CreateItem(itemName, caster, caster)
    if item == nil then
        return nil
    end

    caster:AddItem(item)

    return item
end

function FishingService:RecordCatch(caster, itemName)
    local team = caster:GetTeamNumber()
    self.catchesByTeam[team] = self.catchesByTeam[team] or {}
    self.catchesByTeam[team][itemName] = (self.catchesByTeam[team][itemName] or 0) + 1

    if CustomNetTables ~= nil then
        CustomNetTables:SetTableValue("kobold_world", "fishing_" .. tostring(team), self.catchesByTeam[team])
    end
end

function FishingService:IsDay()
    if GameRules == nil or GameRules.GetTimeOfDay == nil then
        return true
    end

    local time = GameRules:GetTimeOfDay()
    return time >= 0.25 and time <= 0.75
end

return FishingService
