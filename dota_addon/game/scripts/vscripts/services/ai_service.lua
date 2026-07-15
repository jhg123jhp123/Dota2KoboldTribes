local AIService = {}
AIService.__index = AIService

local PROFILES = {
    npc_kobold_animal_sheep = {
        archetype = "prey",
        tickSeconds = 0.75,
        fleeRadius = 430,
        wanderRadius = 520,
        wanderStep = 260,
        loot = {
            xp = 30,
            resources = {
                { id = "ingredient_raw_lamb", count = 1, chance = 100 },
                { id = "ingredient_wool", count = 1, chance = 50 },
            },
        },
    },
    npc_kobold_animal_pheasant = {
        archetype = "prey",
        tickSeconds = 0.55,
        fleeRadius = 460,
        wanderRadius = 620,
        wanderStep = 300,
        loot = {
            xp = 28,
            resources = {
                { id = "ingredient_raw_pheasant", count = 1, chance = 100 },
            },
        },
    },
    npc_kobold_animal_stag = {
        archetype = "prey",
        tickSeconds = 0.65,
        fleeRadius = 520,
        wanderRadius = 720,
        wanderStep = 340,
        loot = {
            xp = 80,
            resources = {
                { id = "ingredient_raw_stag_meat", count = 1, chance = 100 },
            },
        },
    },
    npc_kobold_animal_wolf = {
        archetype = "predator",
        tickSeconds = 0.55,
        dayAggroRadius = 280,
        nightAggroRadius = 680,
        leashRadius = 980,
        wanderRadius = 720,
        wanderStep = 320,
        loot = {
            xp = 40,
            resources = {
                { id = "ingredient_raw_wolf_meat", count = 1, chance = 100 },
                { id = "ingredient_leather", count = 1, chance = 20 },
            },
        },
    },
    npc_kobold_animal_dire_wolf = {
        archetype = "predator",
        tickSeconds = 0.45,
        dayAggroRadius = 420,
        nightAggroRadius = 900,
        leashRadius = 1200,
        wanderRadius = 900,
        wanderStep = 380,
        loot = {
            xp = 50,
            resources = {
                { id = "ingredient_raw_wolf_meat", count = 2, chance = 100 },
                { id = "ingredient_leather", count = 1, chance = 30 },
            },
        },
    },
    npc_kobold_animal_bear = {
        archetype = "territorial",
        tickSeconds = 0.65,
        aggroRadius = 560,
        leashRadius = 1050,
        wanderRadius = 520,
        wanderStep = 260,
        heavyAttackCooldown = 8,
        loot = {
            xp = 96,
            resources = {
                { id = "ingredient_raw_bear_meat", count = 1, chance = 100 },
                { id = "ingredient_leather", count = 2, chance = 60 },
            },
        },
    },
    npc_kobold_boss_raging_arcane_beast = {
        archetype = "boss",
        tickSeconds = 0.35,
        aggroRadius = 1200,
        leashRadius = 1800,
        abilities = {
            { name = "boss_ability_arcane_projectile", kind = "target", range = 900 },
            { name = "boss_ability_arcane_burst", kind = "no_target", range = 360 },
            { name = "boss_ability_arcane_field", kind = "point", range = 900 },
        },
        loot = {
            xp = 500,
            resources = {
                { id = "resource_shadowstone", count = 2, chance = 100 },
                { id = "resource_radiant_gemstone", count = 2, chance = 100 },
                { id = "resource_gold", count = 6, chance = 100 },
            },
        },
    },
}

function AIService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        entries = {},
    }, AIService)
end

function AIService:RegisterUnit(unit)
    if not self:IsAliveUnit(unit) or unit:IsRealHero() then
        return
    end

    local profile = PROFILES[unit:GetUnitName()]
    if profile == nil then
        return
    end

    local index = unit:GetEntityIndex()
    if self.entries[index] ~= nil then
        return
    end

    profile = self:ApplyUnitOverrides(unit, profile)
    self.entries[index] = {
        unit = unit,
        profile = profile,
        home = unit.koboldHomeOverride or unit:GetAbsOrigin(),
        state = "idle",
        target = nil,
        nextThinkTime = 0,
        nextWanderTime = 0,
        nextHeavyAttackTime = 0,
    }
end

function AIService:ApplyUnitOverrides(unit, profile)
    if unit.koboldWanderRadius == nil and unit.koboldFleeRadius == nil then
        return profile
    end

    local copy = {}
    for key, value in pairs(profile) do
        copy[key] = value
    end

    copy.wanderRadius = unit.koboldWanderRadius or copy.wanderRadius
    copy.fleeRadius = unit.koboldFleeRadius or copy.fleeRadius
    return copy
end

function AIService:UnregisterUnit(unit)
    if unit ~= nil and not unit:IsNull() then
        self.entries[unit:GetEntityIndex()] = nil
    end
end

function AIService:Think(deltaTime)
    local now = self:GetGameTime()

    for index, entry in pairs(self.entries) do
        if not self:IsAliveUnit(entry.unit) then
            self.entries[index] = nil
        elseif now >= entry.nextThinkTime then
            self:ThinkEntry(entry, now, deltaTime or 1)
            entry.nextThinkTime = now + (entry.profile.tickSeconds or 0.5)
        end
    end
end

function AIService:ThinkEntry(entry, now, deltaTime)
    local archetype = entry.profile.archetype

    if entry.unit:HasModifier("modifier_animal_afraid_of_fire") then
        self:FleeFromNearestFire(entry)
        return
    end

    if archetype == "prey" then
        self:ThinkPrey(entry, now)
    elseif archetype == "predator" then
        self:ThinkPredator(entry, now)
    elseif archetype == "territorial" then
        self:ThinkTerritorial(entry, now)
    elseif archetype == "boss" then
        self:ThinkBoss(entry, now)
    end
end

function AIService:ThinkPrey(entry, now)
    local threat = self:FindNearestThreat(entry.unit, entry.profile.fleeRadius or 400)
    if threat ~= nil then
        entry.state = "flee"
        self:FleeFromUnit(entry.unit, threat, entry.profile.wanderStep or 260)
        return
    end

    self:Wander(entry, now)
end

function AIService:ThinkPredator(entry, now)
    if self:IsNight() then
        self:AcquireAndAttack(entry, entry.profile.nightAggroRadius or 650)
        return
    end

    self:AcquireAndAttack(entry, entry.profile.dayAggroRadius or 300)
end

function AIService:ThinkTerritorial(entry, now)
    local target = self:GetValidTarget(entry)
    if target ~= nil and self:Distance(entry.unit:GetAbsOrigin(), entry.home) <= (entry.profile.leashRadius or 900) then
        self:AttackTarget(entry, target)
        self:TryBearHeavyAttack(entry, target, now)
        return
    end

    target = self:FindNearestHero(entry.unit, entry.profile.aggroRadius or 520)
    if target ~= nil then
        entry.target = target
        self:AttackTarget(entry, target)
        self:TryBearHeavyAttack(entry, target, now)
        return
    end

    self:ReturnOrWander(entry, now)
end

function AIService:ThinkBoss(entry, now)
    local target = self:GetValidTarget(entry) or self:FindNearestHero(entry.unit, entry.profile.aggroRadius or 1100)
    if target == nil then
        self:ReturnOrWander(entry, now)
        return
    end

    entry.target = target
    self:TryBossAbility(entry, target)
    self:AttackTarget(entry, target)
end

function AIService:AcquireAndAttack(entry, radius)
    local target = self:GetValidTarget(entry)
    if target ~= nil and self:Distance(entry.unit:GetAbsOrigin(), entry.home) <= (entry.profile.leashRadius or 900) then
        self:AttackTarget(entry, target)
        return
    end

    target = self:FindNearestHero(entry.unit, radius)
    if target ~= nil then
        entry.target = target
        self:AttackTarget(entry, target)
        return
    end

    self:ReturnOrWander(entry, self:GetGameTime())
end

function AIService:AttackTarget(entry, target)
    entry.state = "attack"
    if entry.unit.MoveToTargetToAttack ~= nil then
        entry.unit:MoveToTargetToAttack(target)
    end
end

function AIService:TryBearHeavyAttack(entry, target, now)
    if now < (entry.nextHeavyAttackTime or 0) or self:Distance(entry.unit:GetAbsOrigin(), target:GetAbsOrigin()) > 180 then
        return
    end

    ApplyDamage({
        victim = target,
        attacker = entry.unit,
        damage = 35,
        damage_type = DAMAGE_TYPE_PHYSICAL,
    })

    entry.nextHeavyAttackTime = now + (entry.profile.heavyAttackCooldown or 8)
end

function AIService:TryBossAbility(entry, target)
    for _, abilitySpec in ipairs(entry.profile.abilities or {}) do
        local ability = entry.unit:FindAbilityByName(abilitySpec.name)
        if ability ~= nil and ability:IsFullyCastable() then
            local distance = self:Distance(entry.unit:GetAbsOrigin(), target:GetAbsOrigin())
            if distance <= (abilitySpec.range or 900) then
                self:CastBossAbility(entry.unit, ability, abilitySpec, target)
                return
            end
        end
    end
end

function AIService:CastBossAbility(unit, ability, abilitySpec, target)
    if abilitySpec.kind == "target" then
        ExecuteOrderFromTable({
            UnitIndex = unit:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            AbilityIndex = ability:GetEntityIndex(),
            TargetIndex = target:GetEntityIndex(),
            Queue = false,
        })
    elseif abilitySpec.kind == "point" then
        ExecuteOrderFromTable({
            UnitIndex = unit:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
            AbilityIndex = ability:GetEntityIndex(),
            Position = target:GetAbsOrigin(),
            Queue = false,
        })
    else
        ExecuteOrderFromTable({
            UnitIndex = unit:GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            AbilityIndex = ability:GetEntityIndex(),
            Queue = false,
        })
    end
end

function AIService:ReturnOrWander(entry, now)
    local distanceFromHome = self:Distance(entry.unit:GetAbsOrigin(), entry.home)
    if distanceFromHome > (entry.profile.wanderRadius or 600) then
        entry.state = "return"
        entry.unit:MoveToPosition(entry.home)
        return
    end

    self:Wander(entry, now)
end

function AIService:Wander(entry, now)
    if now < (entry.nextWanderTime or 0) then
        return
    end

    entry.state = "wander"
    local step = entry.profile.wanderStep or 260
    local point = entry.home + RandomVector(RandomInt(math.floor(step * 0.35), step))
    entry.unit:MoveToPosition(point)
    entry.nextWanderTime = now + RandomFloat(2.5, 5.5)
end

function AIService:FleeFromNearestFire(entry)
    local fire = self:FindNearestUnitByName(entry.unit, "npc_kobold_building_campfire", 650)
    if fire ~= nil then
        self:FleeFromUnit(entry.unit, fire, 520)
        return
    end

    entry.unit:MoveToPosition(entry.home)
end

function AIService:FleeFromUnit(unit, threat, distance)
    local origin = unit:GetAbsOrigin()
    local threatOrigin = threat:GetAbsOrigin()
    local direction = self:DirectionAwayFrom(origin, threatOrigin)
    unit:MoveToPosition(origin + direction * (distance or 400))
end

function AIService:FindNearestThreat(unit, radius)
    local candidates = FindUnitsInRadius(
        unit:GetTeamNumber(),
        unit:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )

    for _, candidate in ipairs(candidates) do
        if candidate ~= unit and self:IsAliveUnit(candidate) then
            if candidate:IsRealHero() or self:IsPredator(candidate) then
                return candidate
            end
        end
    end

    return nil
end

function AIService:FindNearestHero(unit, radius)
    local candidates = FindUnitsInRadius(
        unit:GetTeamNumber(),
        unit:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )

    for _, candidate in ipairs(candidates) do
        if self:IsAliveUnit(candidate) and candidate:IsRealHero() and candidate:GetTeamNumber() ~= unit:GetTeamNumber() then
            return candidate
        end
    end

    return nil
end

function AIService:FindNearestUnitByName(unit, unitName, radius)
    local candidates = FindUnitsInRadius(
        unit:GetTeamNumber(),
        unit:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )

    for _, candidate in ipairs(candidates) do
        if self:IsAliveUnit(candidate) and candidate:GetUnitName() == unitName then
            return candidate
        end
    end

    return nil
end

function AIService:GetValidTarget(entry)
    local target = entry.target
    if self:IsAliveUnit(target) and target:IsRealHero() then
        return target
    end

    entry.target = nil
    return nil
end

function AIService:IsPredator(unit)
    local profile = PROFILES[unit:GetUnitName()]
    return profile ~= nil and (profile.archetype == "predator" or profile.archetype == "territorial" or profile.archetype == "boss")
end

function AIService:OnEntityKilled(killed, attacker)
    if killed == nil or killed:IsNull() then
        return
    end

    local profile = PROFILES[killed:GetUnitName()]
    if profile == nil then
        return
    end

    self:UnregisterUnit(killed)
    self:GrantLoot(profile.loot, attacker)
end

function AIService:GrantLoot(loot, attacker)
    if loot == nil or attacker == nil or attacker:IsNull() then
        return
    end

    local team = attacker:GetTeamNumber()
    if team == DOTA_TEAM_NEUTRALS then
        return
    end

    local resources = self.context and self.context:GetService("resources") or nil
    if resources ~= nil then
        for _, reward in ipairs(loot.resources or {}) do
            if RandomInt(1, 100) <= (reward.chance or 100) then
                resources:AddResourceForTeam(team, reward.id, reward.count or 1)
            end
        end
    end

    local progression = self.context and self.context:GetService("progression") or nil
    if progression ~= nil and attacker:IsRealHero() then
        progression:AwardXp(attacker, loot.xp or 0, "wildlife_kill")
    end
end

function AIService:IsNight()
    if GameRules == nil or GameRules.GetTimeOfDay == nil then
        return false
    end

    local time = GameRules:GetTimeOfDay()
    return time < 0.25 or time > 0.75
end

function AIService:GetGameTime()
    if GameRules ~= nil and GameRules.GetGameTime ~= nil then
        return GameRules:GetGameTime()
    end

    return 0
end

function AIService:DirectionAwayFrom(origin, threatOrigin)
    local dx = origin.x - threatOrigin.x
    local dy = origin.y - threatOrigin.y
    local length = math.sqrt(dx * dx + dy * dy)

    if length < 1 then
        return RandomVector(1)
    end

    return Vector(dx / length, dy / length, 0)
end

function AIService:Distance(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    return math.sqrt(dx * dx + dy * dy)
end

function AIService:IsAliveUnit(unit)
    return unit ~= nil and not unit:IsNull() and unit:IsAlive()
end

return AIService
