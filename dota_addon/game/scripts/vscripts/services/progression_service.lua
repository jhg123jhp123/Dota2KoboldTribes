local ProgressionService = {}
ProgressionService.__index = ProgressionService

local SKILLS = {
    skill_forestry = true,
    skill_cooking = true,
    skill_mining = true,
    skill_foraging = true,
    skill_artisanship = true,
}

function ProgressionService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        stateByHero = {},
    }, ProgressionService)
end

function ProgressionService:RegisterHero(hero)
    if hero == nil or hero:IsNull() then
        return
    end

    local id = hero:GetEntityIndex()
    if self.stateByHero[id] == nil then
        self.stateByHero[id] = {
            xp = 0,
            level = 1,
            skillPoints = 0,
            skills = {},
        }
    end

    self:PushHero(hero)
end

function ProgressionService:AwardXp(hero, amount, reason)
    if hero == nil or hero:IsNull() or amount == nil or amount <= 0 then
        return
    end

    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]
    state.xp = state.xp + amount

    while state.xp >= self:GetXpForNextLevel(state.level) do
        state.level = state.level + 1
        state.skillPoints = state.skillPoints + 1
        if hero.SetAbilityPoints then
            hero:SetAbilityPoints((hero:GetAbilityPoints() or 0) + 1)
        end
    end

    self:PushHero(hero)
    print("[Kobold Survival][Progression] " .. hero:GetUnitName() .. " XP +" .. amount .. " (" .. tostring(reason) .. ")")
end

function ProgressionService:SpendSkillPoint(hero, skillId)
    if not SKILLS[skillId] or hero == nil or hero:IsNull() then
        return false
    end

    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]
    if state.skillPoints <= 0 then
        return false
    end

    state.skillPoints = state.skillPoints - 1
    state.skills[skillId] = (state.skills[skillId] or 0) + 1
    self:PushHero(hero)
    return true
end

function ProgressionService:GetXpForNextLevel(level)
    return 100 + (level - 1) * 75
end

function ProgressionService:GetLevel(hero)
    if hero == nil or hero:IsNull() then
        return 1
    end

    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]
    return state and state.level or 1
end

function ProgressionService:GetSkillRank(hero, skillId)
    if hero == nil or hero:IsNull() then
        return 0
    end

    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]
    return state and state.skills[skillId] or 0
end

function ProgressionService:PushHero(hero)
    if CustomNetTables == nil or hero == nil or hero:IsNull() then
        return
    end

    local id = hero:GetEntityIndex()
    CustomNetTables:SetTableValue("kobold_progression", tostring(id), self.stateByHero[id])
end

return ProgressionService
