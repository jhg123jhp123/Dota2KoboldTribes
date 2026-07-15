local SurvivalService = {}
SurvivalService.__index = SurvivalService

local DEFAULTS = {
    maxHunger = 100,
    maxWarmth = 100,
    maxStamina = 100,
    hungerDrainPerSecond = 0.055,
    dayWarmthDrainPerSecond = 0.02,
    nightWarmthDrainPerSecond = 0.09,
    staminaRegenPerSecond = 3.0,
    runningStaminaDrainPerSecond = 2.0,
    starveDamagePerSecond = 1.0,
    frostbiteDamagePerSecond = 0.8,
}

function SurvivalService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        stateByHero = {},
        heroes = {},
        settings = options.settings or DEFAULTS,
    }, SurvivalService)
end

function SurvivalService:RegisterHero(hero)
    if hero == nil or hero:IsNull() then
        return
    end

    local id = hero:GetEntityIndex()
    self.heroes[id] = hero

    if self.stateByHero[id] == nil then
        self.stateByHero[id] = {
            hunger = self.settings.maxHunger,
            warmth = self.settings.maxWarmth,
            stamina = self.settings.maxStamina,
            maxHunger = self.settings.maxHunger,
            maxWarmth = self.settings.maxWarmth,
            maxStamina = self.settings.maxStamina,
        }
    end

    self:PushHero(hero)
end

function SurvivalService:Think(deltaTime)
    deltaTime = deltaTime or 1

    for id, hero in pairs(self.heroes) do
        if hero == nil or hero:IsNull() then
            self.heroes[id] = nil
        elseif hero:IsAlive() then
            self:TickHero(hero, deltaTime)
        end
    end
end

function SurvivalService:TickHero(hero, deltaTime)
    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]
    local night = self:IsNight()

    local hungerDrain = self.settings.hungerDrainPerSecond
    if hero:HasModifier("modifier_item_fishing_rod") then
        hungerDrain = hungerDrain * 0.5
    end

    state.hunger = self:Clamp(state.hunger - hungerDrain * deltaTime, 0, state.maxHunger)
    state.warmth = self:Clamp(state.warmth - self:GetWarmthDrain(hero, night) * deltaTime, 0, state.maxWarmth)

    if hero:HasModifier("modifier_kobold_running") then
        state.stamina = self:Clamp(state.stamina - self.settings.runningStaminaDrainPerSecond * deltaTime, 0, state.maxStamina)
        if state.stamina <= 0 then
            hero:RemoveModifierByName("modifier_kobold_running")
            hero:AddNewModifier(hero, nil, "modifier_status_stamina_exhausted", { duration = 2.0 })
        end
    else
        state.stamina = self:Clamp(state.stamina + self.settings.staminaRegenPerSecond * deltaTime, 0, state.maxStamina)
    end

    if state.hunger <= 0 then
        self:ApplySurvivalDamage(hero, self.settings.starveDamagePerSecond * deltaTime, "starvation")
    end

    if state.warmth <= 0 then
        self:ApplySurvivalDamage(hero, self.settings.frostbiteDamagePerSecond * deltaTime, "frostbite")
        if not hero:HasModifier("modifier_status_frostbite") then
            hero:AddNewModifier(hero, nil, "modifier_status_frostbite", { duration = 1.5 })
        end
    end

    self:PushHero(hero)
end

function SurvivalService:GetWarmthDrain(hero, night)
    local drain = night and self.settings.nightWarmthDrainPerSecond or self.settings.dayWarmthDrainPerSecond

    if hero:HasModifier("modifier_campfire_warmth") or hero:HasModifier("modifier_tent_rest_recovery") then
        drain = -0.5
    end

    if hero:HasModifier("modifier_fish_sunfish_warmth") and drain > 0 then
        drain = drain * 0.5
    end

    local weather = self.context and self.context:GetService("weather") or nil
    if weather ~= nil and weather.AdjustWarmthDrain ~= nil then
        drain = weather:AdjustWarmthDrain(drain)
    end

    return drain
end

function SurvivalService:IsNight()
    if GameRules == nil or GameRules.GetTimeOfDay == nil then
        return false
    end

    local time = GameRules:GetTimeOfDay()
    return time < 0.25 or time > 0.75
end

function SurvivalService:Restore(hero, values)
    if hero == nil or hero:IsNull() then
        return
    end

    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]

    if values.hunger then
        state.hunger = self:Clamp(state.hunger + values.hunger, 0, state.maxHunger)
    end

    if values.warmth then
        state.warmth = self:Clamp(state.warmth + values.warmth, 0, state.maxWarmth)
    end

    if values.stamina then
        state.stamina = self:Clamp(state.stamina + values.stamina, 0, state.maxStamina)
    end

    self:PushHero(hero)
end

function SurvivalService:SpendStamina(hero, amount)
    if hero == nil or hero:IsNull() then
        return false
    end

    self:RegisterHero(hero)
    local state = self.stateByHero[hero:GetEntityIndex()]
    if state.stamina < amount then
        return false
    end

    state.stamina = state.stamina - amount
    self:PushHero(hero)
    return true
end

function SurvivalService:ApplySurvivalDamage(hero, damage, reason)
    if damage <= 0 or ApplyDamage == nil then
        return
    end

    ApplyDamage({
        victim = hero,
        attacker = hero,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL or 0,
    })
end

function SurvivalService:Clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

function SurvivalService:PushHero(hero)
    if CustomNetTables == nil or hero == nil or hero:IsNull() then
        return
    end

    local id = hero:GetEntityIndex()
    CustomNetTables:SetTableValue("kobold_survival", tostring(id), self.stateByHero[id])
end

return SurvivalService
