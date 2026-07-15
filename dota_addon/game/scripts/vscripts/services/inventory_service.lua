local InventoryService = {}
InventoryService.__index = InventoryService

function InventoryService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
        stashByTeam = {},
    }, InventoryService)
end

function InventoryService:InitializeTeam(team)
    if team == nil then
        return
    end

    if self.stashByTeam[team] == nil then
        self.stashByTeam[team] = {}
        self:PushTeam(team)
    end
end

function InventoryService:InitializeTeams(teams)
    for _, team in ipairs(teams or {}) do
        self:InitializeTeam(team)
    end
end

function InventoryService:GetTeamForUnit(unit)
    if unit == nil or unit.IsNull == nil or unit:IsNull() then
        return nil
    end

    return unit:GetTeamNumber()
end

function InventoryService:AddItemForTeam(team, itemName, count)
    if team == nil or itemName == nil or itemName == "" then
        return false
    end

    count = math.max(1, count or 1)
    self:InitializeTeam(team)
    local stash = self.stashByTeam[team]
    stash[itemName] = (stash[itemName] or 0) + count
    self:PushTeam(team)
    return true
end

function InventoryService:RemoveItemForTeam(team, itemName, count)
    if team == nil or itemName == nil or itemName == "" then
        return false, "invalid_item"
    end

    count = math.max(1, count or 1)
    self:InitializeTeam(team)
    local stash = self.stashByTeam[team]
    if (stash[itemName] or 0) < count then
        return false, "missing_item"
    end

    stash[itemName] = stash[itemName] - count
    if stash[itemName] <= 0 then
        stash[itemName] = nil
    end

    self:PushTeam(team)
    return true
end

function InventoryService:GetItemName(item)
    if item == nil or item.IsNull == nil or item:IsNull() then
        return nil
    end

    if item.GetAbilityName ~= nil then
        return item:GetAbilityName()
    end

    if item.GetName ~= nil then
        return item:GetName()
    end

    return nil
end

function InventoryService:DepositSlot(hero, slot)
    if hero == nil or hero:IsNull() or hero.GetItemInSlot == nil then
        return false, "missing_hero"
    end

    slot = tonumber(slot) or 0
    local item = hero:GetItemInSlot(slot)
    return self:DepositItem(hero, item)
end

function InventoryService:DepositFirstStashableItem(hero)
    if hero == nil or hero:IsNull() or hero.GetItemInSlot == nil then
        return false, "missing_hero"
    end

    for slot = 0, 8 do
        local item = hero:GetItemInSlot(slot)
        if item ~= nil and not item:IsNull() then
            local itemName = self:GetItemName(item)
            if itemName ~= "item_utility_lantern" and itemName ~= "item_tool_fishing_rod" then
                return self:DepositItem(hero, item)
            end
        end
    end

    return false, "no_stashable_item"
end

function InventoryService:DepositItem(hero, item)
    if hero == nil or hero:IsNull() then
        return false, "missing_hero"
    end

    local itemName = self:GetItemName(item)
    if itemName == nil then
        return false, "missing_item"
    end

    local team = self:GetTeamForUnit(hero)
    self:AddItemForTeam(team, itemName, 1)

    if hero.RemoveItem ~= nil then
        hero:RemoveItem(item)
    elseif UTIL_Remove ~= nil then
        UTIL_Remove(item)
    end

    return true, itemName
end

function InventoryService:WithdrawItem(hero, itemName, count)
    if hero == nil or hero:IsNull() then
        return false, "missing_hero"
    end

    count = math.max(1, tonumber(count) or 1)
    for _ = 1, count do
        local ok, err = self:RemoveItemForTeam(hero:GetTeamNumber(), itemName, 1)
        if not ok then
            return false, err
        end

        if CreateItem ~= nil then
            local item = CreateItem(itemName, hero, hero)
            if item ~= nil then
                hero:AddItem(item)
            end
        end
    end

    return true, itemName
end

function InventoryService:GetSnapshot(team)
    self:InitializeTeam(team)
    local snapshot = {}
    for itemName, count in pairs(self.stashByTeam[team]) do
        snapshot[itemName] = count
    end

    return snapshot
end

function InventoryService:PushTeam(team)
    if CustomNetTables == nil or team == nil then
        return
    end

    CustomNetTables:SetTableValue("kobold_inventory", tostring(team), self:GetSnapshot(team))
end

return InventoryService
