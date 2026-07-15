local ResourceService = {}
ResourceService.__index = ResourceService

local STARTING_RESOURCES = {
    resource_lumber = 4,
    resource_stone = 3,
    resource_gold = 0,
    resource_iron = 0,
    resource_infused_lumber = 0,
    resource_shadowstone = 0,
    resource_radiant_gemstone = 0,
    ingredient_wool = 1,
    ingredient_leather = 1,
    ingredient_raw_lamb = 1,
    ingredient_raw_wolf_meat = 0,
    ingredient_raw_pheasant = 0,
    ingredient_raw_bear_meat = 0,
    ingredient_raw_stag_meat = 0,
    ingredient_handful_berries = 2,
    ingredient_spicy_herbs = 0,
    ingredient_sageberry = 0,
    ingredient_lambent_sunflower = 0,
    ingredient_beer = 0,
    ingredient_draught_of_decay = 0,
}

function ResourceService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        resourcesByTeam = {},
    }, ResourceService)
end

function ResourceService:InitializeTeam(team)
    if self.resourcesByTeam[team] ~= nil then
        return
    end

    local resources = {}
    for resourceId, amount in pairs(STARTING_RESOURCES) do
        resources[resourceId] = amount
    end

    self.resourcesByTeam[team] = resources
    self:PushTeam(team)
end

function ResourceService:InitializeTeams(teams)
    for _, team in ipairs(teams or {}) do
        self:InitializeTeam(team)
    end
end

function ResourceService:GetTeamForUnit(unit)
    if unit == nil or unit.IsNull == nil or unit:IsNull() then
        return nil
    end

    return unit:GetTeamNumber()
end

function ResourceService:GetAmount(team, resourceId)
    self:InitializeTeam(team)
    return self.resourcesByTeam[team][resourceId] or 0
end

function ResourceService:AddResourceForTeam(team, resourceId, amount)
    if team == nil or resourceId == nil or amount == nil or amount == 0 then
        return 0
    end

    self:InitializeTeam(team)
    local resources = self.resourcesByTeam[team]
    resources[resourceId] = math.max(0, (resources[resourceId] or 0) + amount)
    self:PushTeam(team)
    return resources[resourceId]
end

function ResourceService:AddResource(unit, resourceId, amount)
    return self:AddResourceForTeam(self:GetTeamForUnit(unit), resourceId, amount)
end

function ResourceService:CanSpendForTeam(team, costs)
    self:InitializeTeam(team)
    local resources = self.resourcesByTeam[team]

    for _, cost in ipairs(costs or {}) do
        if (resources[cost.id] or 0) < cost.count then
            return false, cost.id
        end
    end

    return true
end

function ResourceService:SpendForTeam(team, costs)
    local canSpend, missing = self:CanSpendForTeam(team, costs)
    if not canSpend then
        return false, missing
    end

    local resources = self.resourcesByTeam[team]
    for _, cost in ipairs(costs or {}) do
        resources[cost.id] = (resources[cost.id] or 0) - cost.count
    end

    self:PushTeam(team)
    return true
end

function ResourceService:RefundForTeam(team, costs)
    for _, cost in ipairs(costs or {}) do
        self:AddResourceForTeam(team, cost.id, cost.count)
    end
end

function ResourceService:CanSpend(unit, resourceId, amount)
    return self:CanSpendForTeam(self:GetTeamForUnit(unit), {
        { id = resourceId, count = amount },
    })
end

function ResourceService:Spend(unit, resourceId, amount)
    return self:SpendForTeam(self:GetTeamForUnit(unit), {
        { id = resourceId, count = amount },
    })
end

function ResourceService:GetSnapshot(team)
    self:InitializeTeam(team)
    local snapshot = {}
    for resourceId, amount in pairs(self.resourcesByTeam[team]) do
        snapshot[resourceId] = amount
    end

    return snapshot
end

function ResourceService:PushTeam(team)
    if CustomNetTables == nil or team == nil then
        return
    end

    CustomNetTables:SetTableValue("kobold_resources", tostring(team), self:GetSnapshot(team))
end

return ResourceService
