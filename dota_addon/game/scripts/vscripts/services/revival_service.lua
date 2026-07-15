local RevivalService = {}
RevivalService.__index = RevivalService

local REVIVAL_TIERS = {
    {
        maxLevel = 4,
        costs = {
            { id = "resource_stone", count = 1 },
            { id = "ingredient_wool", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
    },
    {
        maxLevel = 7,
        costs = {
            { id = "resource_iron", count = 1 },
            { id = "resource_radiant_gemstone", count = 1 },
            { id = "ingredient_sageberry", count = 1 },
        },
    },
    {
        maxLevel = 30,
        costs = {
            { id = "resource_radiant_gemstone", count = 1 },
            { id = "resource_shadowstone", count = 1 },
            { id = "ingredient_lambent_sunflower", count = 1 },
        },
    },
}

function RevivalService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        deadByTeam = {},
        deathsByHero = {},
    }, RevivalService)
end

function RevivalService:OnEntityKilled(killed, attacker)
    if killed == nil or killed:IsNull() or not killed:IsRealHero() then
        return
    end

    local team = killed:GetTeamNumber()
    self.deadByTeam[team] = self.deadByTeam[team] or {}
    self.deadByTeam[team][killed:GetEntityIndex()] = killed
    self.deathsByHero[killed:GetEntityIndex()] = (self.deathsByHero[killed:GetEntityIndex()] or 0) + 1
    self:PushTeam(team)
end

function RevivalService:OnHeroRegistered(hero)
    if hero == nil or hero:IsNull() then
        return
    end

    local team = hero:GetTeamNumber()
    self.deadByTeam[team] = self.deadByTeam[team] or {}
    if hero:IsAlive() then
        self.deadByTeam[team][hero:GetEntityIndex()] = nil
    end

    self:PushTeam(team)
end

function RevivalService:GetHeroLevel(hero)
    local progression = self.context and self.context:GetService("progression") or nil
    if progression ~= nil and progression.GetLevel ~= nil then
        return progression:GetLevel(hero)
    end

    if hero ~= nil and hero.GetLevel ~= nil then
        return hero:GetLevel()
    end

    return 1
end

function RevivalService:GetCostsForHero(hero)
    local level = self:GetHeroLevel(hero)
    for _, tier in ipairs(REVIVAL_TIERS) do
        if level <= tier.maxLevel then
            return tier.costs, level
        end
    end

    return REVIVAL_TIERS[#REVIVAL_TIERS].costs, level
end

function RevivalService:GetNearestDeadAlly(caster)
    if caster == nil or caster:IsNull() then
        return nil
    end

    local team = caster:GetTeamNumber()
    local dead = self.deadByTeam[team] or {}
    local bestHero = nil
    local bestDistance = nil
    local origin = caster:GetAbsOrigin()

    for index, hero in pairs(dead) do
        if hero == nil or hero:IsNull() then
            dead[index] = nil
        elseif not hero:IsAlive() then
            local distance = (hero:GetAbsOrigin() - origin):Length2D()
            if bestDistance == nil or distance < bestDistance then
                bestDistance = distance
                bestHero = hero
            end
        else
            dead[index] = nil
        end
    end

    return bestHero
end

function RevivalService:IsValidShrine(target)
    return target ~= nil
        and not target:IsNull()
        and target.GetUnitName ~= nil
        and target:GetUnitName() == "npc_kobold_building_revival_shrine"
end

function RevivalService:ReviveNearestDeadAlly(caster, shrine)
    if caster == nil or caster:IsNull() then
        return false, "missing_caster"
    end

    if not self:IsValidShrine(shrine) then
        return false, "target_not_shrine"
    end

    local hero = self:GetNearestDeadAlly(caster)
    if hero == nil then
        return false, "no_dead_ally"
    end

    local costs, level = self:GetCostsForHero(hero)
    local resources = self.context and self.context:GetService("resources") or nil
    if resources ~= nil then
        local ok, missing = resources:SpendForTeam(caster:GetTeamNumber(), costs)
        if not ok then
            return false, missing
        end
    end

    if hero.RespawnHero ~= nil then
        hero:RespawnHero(false, false)
    end

    local point = shrine:GetAbsOrigin() + RandomVector(180)
    if FindClearSpaceForUnit ~= nil then
        FindClearSpaceForUnit(hero, point, true)
    end

    if hero.SetHealth ~= nil then
        hero:SetHealth(math.max(1, math.floor(hero:GetMaxHealth() * 0.5)))
    end

    if hero.SetMana ~= nil and hero.GetMaxMana ~= nil then
        hero:SetMana(math.floor(hero:GetMaxMana() * 0.35))
    end

    self.deadByTeam[caster:GetTeamNumber()][hero:GetEntityIndex()] = nil
    self:PushTeam(caster:GetTeamNumber())

    local survival = self.context and self.context:GetService("survival") or nil
    if survival ~= nil then
        survival:RegisterHero(hero)
        survival:Restore(hero, { hunger = 25, warmth = 25, stamina = 50 })
    end

    local progression = self.context and self.context:GetService("progression") or nil
    if progression ~= nil then
        progression:AwardXp(caster, 50 + level * 5, "revival")
    end

    return true, hero:GetUnitName()
end

function RevivalService:GetSnapshot(team)
    local snapshot = {}
    local dead = self.deadByTeam[team] or {}

    for index, hero in pairs(dead) do
        if hero ~= nil and not hero:IsNull() and not hero:IsAlive() then
            snapshot[tostring(index)] = {
                unitName = hero:GetUnitName(),
                level = self:GetHeroLevel(hero),
                deaths = self.deathsByHero[index] or 1,
            }
        end
    end

    return snapshot
end

function RevivalService:PushTeam(team)
    if CustomNetTables == nil or team == nil then
        return
    end

    CustomNetTables:SetTableValue("kobold_deaths", tostring(team), self:GetSnapshot(team))
end

return RevivalService
