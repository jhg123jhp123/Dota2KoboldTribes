local BuildingService = {}
BuildingService.__index = BuildingService

local BUILDINGS = {
    building_campfire = {
        unitName = "npc_kobold_building_campfire",
        costs = {
            { id = "resource_lumber", count = 1 },
            { id = "resource_stone", count = 1 },
        },
        fuelSeconds = 180,
    },
    building_tent = {
        unitName = "npc_kobold_building_tent",
        costs = {
            { id = "resource_lumber", count = 1 },
            { id = "ingredient_wool", count = 1 },
        },
    },
    building_farm = {
        unitName = "npc_kobold_building_farm",
        costs = {
            { id = "resource_lumber", count = 1 },
            { id = "resource_stone", count = 1 },
        },
        sheepProductionIntervalSeconds = 22,
        maxLivingCreatedSheep = 4,
        pheasantBaitDurationSeconds = 120,
        pheasantSpawnIntervalSeconds = 24,
        maxLivingBaitedPheasants = 3,
    },
    building_workbench = {
        unitName = "npc_kobold_building_workbench",
        costs = {
            { id = "resource_lumber", count = 2 },
            { id = "resource_stone", count = 1 },
        },
    },
    building_smithy = {
        unitName = "npc_kobold_building_smithy",
        costs = {
            { id = "resource_lumber", count = 1 },
            { id = "resource_stone", count = 1 },
            { id = "ingredient_leather", count = 1 },
        },
    },
    building_storage = {
        unitName = "npc_kobold_building_storage",
        costs = {
            { id = "resource_lumber", count = 2 },
        },
    },
    building_hunters_lodge = {
        unitName = "npc_kobold_building_hunters_lodge",
        costs = {
            { id = "resource_lumber", count = 3 },
            { id = "ingredient_leather", count = 1 },
        },
    },
    building_tavern = {
        unitName = "npc_kobold_building_tavern",
        costs = {
            { id = "resource_lumber", count = 2 },
            { id = "resource_stone", count = 2 },
        },
    },
    building_spike_trap = {
        unitName = "npc_kobold_building_spike_trap",
        costs = {
            { id = "resource_lumber", count = 1 },
            { id = "resource_iron", count = 1 },
        },
    },
}

function BuildingService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        reservations = {},
        buildings = {},
        nextReservationId = 1,
    }, BuildingService)
end

function BuildingService:GetResourceService()
    return self.context and self.context:GetService("resources") or nil
end

function BuildingService:GetGameTime()
    if GameRules ~= nil and GameRules.GetGameTime ~= nil then
        return GameRules:GetGameTime()
    end

    return 0
end

function BuildingService:BeginBuild(caster, buildingId, point)
    local definition = BUILDINGS[buildingId]
    if definition == nil or caster == nil or caster:IsNull() then
        return nil, "unknown_building"
    end

    local resources = self:GetResourceService()
    local team = caster:GetTeamNumber()
    if resources ~= nil then
        local ok, missing = resources:SpendForTeam(team, definition.costs)
        if not ok then
            return nil, missing
        end
    end

    local reservationId = self.nextReservationId
    self.nextReservationId = self.nextReservationId + 1

    self.reservations[reservationId] = {
        id = reservationId,
        caster = caster,
        team = team,
        playerId = caster:GetPlayerOwnerID(),
        point = point,
        buildingId = buildingId,
        definition = definition,
    }

    return reservationId
end

function BuildingService:CancelBuild(reservationId)
    local reservation = self.reservations[reservationId]
    if reservation == nil then
        return
    end

    local resources = self:GetResourceService()
    if resources ~= nil then
        resources:RefundForTeam(reservation.team, reservation.definition.costs)
    end

    self.reservations[reservationId] = nil
end

function BuildingService:CompleteBuild(reservationId)
    local reservation = self.reservations[reservationId]
    if reservation == nil then
        return nil
    end

    local unit = nil
    if CreateUnitByName ~= nil then
        unit = CreateUnitByName(
            reservation.definition.unitName,
            reservation.point,
            true,
            reservation.caster,
            reservation.caster,
            reservation.team
        )

        if unit ~= nil then
            unit.koboldBuildingId = reservation.buildingId
            unit.koboldOwnerTeam = reservation.team

            if reservation.playerId ~= nil and reservation.playerId >= 0 and unit.SetControllableByPlayer then
                unit:SetControllableByPlayer(reservation.playerId, false)
            end

            if reservation.definition.fuelSeconds then
                unit.koboldFuelSeconds = reservation.definition.fuelSeconds
            end

            if reservation.buildingId == "building_farm" then
                unit.koboldNextSheepTime = self:GetGameTime() + reservation.definition.sheepProductionIntervalSeconds
                unit.koboldNextPheasantTime = 0
                unit.koboldFarmSheep = {}
                unit.koboldFarmPheasants = {}
                unit.koboldFarmDomesticatedSheep = false
                unit.koboldPheasantBaitUntil = 0
            end

            self.buildings[unit:GetEntityIndex()] = unit
        end
    else
        print("[Kobold Survival][BuildingService] CreateUnitByName unavailable for " .. reservation.definition.unitName)
    end

    self.reservations[reservationId] = nil
    self:PushNetTables()
    return unit
end

function BuildingService:Refuel(caster, target)
    if target == nil or target:IsNull() or target.koboldBuildingId ~= "building_campfire" then
        return false
    end

    local resources = self:GetResourceService()
    if resources ~= nil then
        local ok = resources:Spend(caster, "resource_lumber", 1)
        if not ok then
            return false
        end
    end

    target.koboldFuelSeconds = math.min((target.koboldFuelSeconds or 0) + 120, 300)
    self:PushNetTables()
    return true
end

function BuildingService:BaitFarm(caster, target)
    if caster == nil or caster:IsNull() or target == nil or target:IsNull() or target.koboldBuildingId ~= "building_farm" then
        return false, "target_not_farm"
    end

    local resources = self:GetResourceService()
    if resources ~= nil then
        local ok = resources:Spend(caster, "ingredient_handful_berries", 1)
        if not ok then
            return false, "missing_berries"
        end
    end

    local definition = BUILDINGS.building_farm
    local now = self:GetGameTime()
    target.koboldPheasantBaitUntil = math.max(target.koboldPheasantBaitUntil or 0, now) + definition.pheasantBaitDurationSeconds
    target.koboldNextPheasantTime = math.min(target.koboldNextPheasantTime or now, now + 4)
    self:PushNetTables()
    return true
end

function BuildingService:DomesticateFarmSheep(caster, target)
    if caster == nil or caster:IsNull() or target == nil or target:IsNull() or target.koboldBuildingId ~= "building_farm" then
        return false, "target_not_farm"
    end

    local resources = self:GetResourceService()
    if resources ~= nil then
        local ok = resources:Spend(caster, "resource_gold", 5)
        if not ok then
            return false, "missing_gold"
        end
    end

    target.koboldFarmDomesticatedSheep = true
    self:PushNetTables()
    return true
end

function BuildingService:HireMurlocSlave(caster, target)
    if caster == nil or caster:IsNull() or target == nil or target:IsNull() or target.koboldBuildingId ~= "building_tavern" then
        return false, "target_not_tavern"
    end

    local resources = self:GetResourceService()
    if resources ~= nil then
        local ok = resources:Spend(caster, "resource_gold", 45)
        if not ok then
            return false, "missing_gold"
        end
    end

    return self:SpawnMurlocSlave(caster, target:GetAbsOrigin() + RandomVector(180), 300) ~= nil
end

function BuildingService:Think(deltaTime)
    deltaTime = deltaTime or 1

    for index, building in pairs(self.buildings) do
        if building == nil or building:IsNull() or not building:IsAlive() then
            self.buildings[index] = nil
        elseif building.koboldBuildingId == "building_campfire" then
            local weather = self.context and self.context:GetService("weather") or nil
            local fuelMultiplier = weather ~= nil and weather:GetCampfireFuelMultiplier() or 1.0
            building.koboldFuelSeconds = math.max(0, (building.koboldFuelSeconds or 0) - deltaTime * fuelMultiplier)
            if building.koboldFuelSeconds <= 0 and building:HasModifier("modifier_campfire_warmth_aura_provider") then
                building:RemoveModifierByName("modifier_campfire_warmth_aura_provider")
            end
        elseif building.koboldBuildingId == "building_farm" then
            self:ThinkFarm(building)
        end
    end
end

function BuildingService:ThinkFarm(farm)
    local now = self:GetGameTime()
    local definition = BUILDINGS.building_farm

    farm.koboldFarmSheep = farm.koboldFarmSheep or {}
    farm.koboldFarmPheasants = farm.koboldFarmPheasants or {}
    farm.koboldNextSheepTime = farm.koboldNextSheepTime or (now + definition.sheepProductionIntervalSeconds)
    farm.koboldNextPheasantTime = farm.koboldNextPheasantTime or 0
    farm.koboldPheasantBaitUntil = farm.koboldPheasantBaitUntil or 0

    self:CleanupUnitList(farm.koboldFarmSheep)
    self:CleanupUnitList(farm.koboldFarmPheasants)

    if now >= (farm.koboldNextSheepTime or 0) then
        farm.koboldNextSheepTime = now + definition.sheepProductionIntervalSeconds
        if #farm.koboldFarmSheep < definition.maxLivingCreatedSheep then
            local sheep = self:SpawnFarmAnimal(
                farm,
                "npc_kobold_animal_sheep",
                farm.koboldFarmDomesticatedSheep and 260 or 520
            )
            if sheep ~= nil then
                farm.koboldFarmSheep[#farm.koboldFarmSheep + 1] = sheep
            end
        end
    end

    if (farm.koboldPheasantBaitUntil or 0) > now and now >= (farm.koboldNextPheasantTime or 0) then
        farm.koboldNextPheasantTime = now + definition.pheasantSpawnIntervalSeconds
        if #farm.koboldFarmPheasants < definition.maxLivingBaitedPheasants then
            local pheasant = self:SpawnFarmAnimal(farm, "npc_kobold_animal_pheasant", 420)
            if pheasant ~= nil then
                farm.koboldFarmPheasants[#farm.koboldFarmPheasants + 1] = pheasant
            end
        end
    end
end

function BuildingService:CleanupUnitList(units)
    if units == nil then
        return
    end

    local alive = {}
    for _, unit in ipairs(units) do
        if unit ~= nil and not unit:IsNull() and unit:IsAlive() then
            alive[#alive + 1] = unit
        end
    end

    for index = #units, 1, -1 do
        units[index] = nil
    end

    for _, unit in ipairs(alive) do
        units[#units + 1] = unit
    end
end

function BuildingService:SpawnFarmAnimal(farm, unitName, wanderRadius)
    if CreateUnitByName == nil then
        return nil
    end

    local unit = CreateUnitByName(unitName, farm:GetAbsOrigin() + RandomVector(240), true, nil, nil, DOTA_TEAM_NEUTRALS)
    if unit == nil then
        return nil
    end

    unit.koboldHomeOverride = farm:GetAbsOrigin()
    unit.koboldWanderRadius = wanderRadius
    unit.koboldFarmOwner = farm

    local ai = self.context and self.context:GetService("ai") or nil
    if ai ~= nil then
        ai:UnregisterUnit(unit)
        ai:RegisterUnit(unit)
    end

    return unit
end

function BuildingService:SpawnMurlocSlave(owner, point, duration)
    if CreateUnitByName == nil or owner == nil or owner:IsNull() then
        return nil
    end

    local unit = CreateUnitByName("npc_kobold_murloc_slave", point, true, owner, owner, owner:GetTeamNumber())
    if unit == nil then
        return nil
    end

    unit.koboldOwnerPlayerId = owner:GetPlayerOwnerID()
    if unit.SetControllableByPlayer ~= nil and unit.koboldOwnerPlayerId ~= nil and unit.koboldOwnerPlayerId >= 0 then
        unit:SetControllableByPlayer(unit.koboldOwnerPlayerId, true)
    end

    if unit.AddNewModifier ~= nil then
        unit:AddNewModifier(owner, nil, "modifier_kobold_temporary_unit", { duration = duration or 300 })
    end

    return unit
end

function BuildingService:GetDefinition(buildingId)
    return BUILDINGS[buildingId]
end

function BuildingService:PushNetTables()
    if CustomNetTables == nil then
        return
    end

    local snapshot = {}
    for index, building in pairs(self.buildings) do
        if building ~= nil and not building:IsNull() then
            snapshot[tostring(index)] = {
                buildingId = building.koboldBuildingId,
                team = building.koboldOwnerTeam,
                fuelSeconds = building.koboldFuelSeconds or 0,
                pheasantBaitRemaining = math.max(0, (building.koboldPheasantBaitUntil or 0) - self:GetGameTime()),
                farmDomesticatedSheep = building.koboldFarmDomesticatedSheep == true,
            }
        end
    end

    CustomNetTables:SetTableValue("kobold_world", "buildings", snapshot)
end

return BuildingService
