if KoboldAbilityHelpers == nil then
    KoboldAbilityHelpers = {}
end

function KoboldAbilityHelpers:GetRuntime()
    return _G.KoboldRuntime
end

function KoboldAbilityHelpers:GetService(serviceName)
    local runtime = self:GetRuntime()
    if runtime == nil or runtime.GetService == nil then
        return nil
    end

    return runtime:GetService(serviceName)
end

function KoboldAbilityHelpers:GetSpecialValue(ability, key, fallback)
    if ability and ability.GetSpecialValueFor then
        local value = ability:GetSpecialValueFor(key)
        if value ~= nil and value ~= 0 then
            return value
        end
    end

    return fallback
end

function KoboldAbilityHelpers:IsAliveUnit(unit)
    return unit ~= nil and not unit:IsNull() and unit:IsAlive()
end

function KoboldAbilityHelpers:IsFriendlyTarget(caster, target)
    return self:IsAliveUnit(caster)
        and self:IsAliveUnit(target)
        and caster:GetTeamNumber() == target:GetTeamNumber()
end

function KoboldAbilityHelpers:Debug(caster, message)
    if caster and not caster:IsNull() then
        print("[Kobold Survival][" .. caster:GetUnitName() .. "] " .. message)
    else
        print("[Kobold Survival] " .. message)
    end
end

function KoboldAbilityHelpers:AwardXp(caster, amount, reason)
    if amount == nil or amount <= 0 then
        return
    end

    local progression = self:GetService("progression")
    if progression ~= nil then
        progression:AwardXp(caster, amount, reason)
        return
    end

    self:Debug(caster, "XP +" .. amount .. " (" .. (reason or "unknown") .. ")")
end

function KoboldAbilityHelpers:GrantResource(caster, resourceId, amount)
    if amount == nil or amount <= 0 then
        return
    end

    local resources = self:GetService("resources")
    if resources ~= nil then
        resources:AddResource(caster, resourceId, amount)
        return
    end

    self:Debug(caster, "grant " .. amount .. " " .. resourceId)
end

function KoboldAbilityHelpers:CanPayResource(caster, resourceId, amount)
    local resources = self:GetService("resources")
    if resources ~= nil then
        return resources:CanSpend(caster, resourceId, amount)
    end

    return true
end

function KoboldAbilityHelpers:SpendResource(caster, resourceId, amount)
    local resources = self:GetService("resources")
    if resources ~= nil then
        local ok, missing = resources:Spend(caster, resourceId, amount)
        if not ok then
            self:Debug(caster, "missing " .. tostring(missing or resourceId))
        end

        return ok
    end

    self:Debug(caster, "spend " .. amount .. " " .. resourceId)
    return true
end

function KoboldAbilityHelpers:HealTarget(target, ability, amount)
    if not self:IsAliveUnit(target) or amount == nil or amount <= 0 then
        return
    end

    target:Heal(amount, ability)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, amount, nil)
end

function KoboldAbilityHelpers:RestoreMana(target, amount)
    if not self:IsAliveUnit(target) or amount == nil or amount <= 0 then
        return
    end

    target:GiveMana(amount)
end

function KoboldAbilityHelpers:RestoreSurvival(target, values)
    local survival = self:GetService("survival")
    if survival ~= nil then
        survival:Restore(target, values)
    end
end

function KoboldAbilityHelpers:SpendStamina(target, amount)
    local survival = self:GetService("survival")
    if survival ~= nil then
        return survival:SpendStamina(target, amount)
    end

    return true
end

function KoboldAbilityHelpers:BeginBuild(caster, ability, buildingId, point)
    local buildings = self:GetService("buildings")
    if buildings == nil then
        return nil
    end

    local reservationId, err = buildings:BeginBuild(caster, buildingId, point)
    if reservationId == nil then
        self:Debug(caster, "cannot build " .. buildingId .. ": " .. tostring(err))
        if ability ~= nil and ability.EndCooldown ~= nil then
            ability:EndCooldown()
        end

        return nil
    end

    return reservationId
end

function KoboldAbilityHelpers:FinishBuild(reservationId, interrupted)
    local buildings = self:GetService("buildings")
    if buildings == nil or reservationId == nil then
        return nil
    end

    if interrupted then
        buildings:CancelBuild(reservationId)
        return nil
    end

    return buildings:CompleteBuild(reservationId)
end

function KoboldAbilityHelpers:CompleteRecipe(caster, recipeId)
    local recipes = self:GetService("recipes")
    if recipes ~= nil then
        return recipes:CompleteRecipe(caster, recipeId)
    end

    return false
end

function KoboldAbilityHelpers:RefuelCampfire(caster, target)
    local buildings = self:GetService("buildings")
    if buildings ~= nil then
        return buildings:Refuel(caster, target)
    end

    return false
end

function KoboldAbilityHelpers:BaitFarm(caster, target)
    local buildings = self:GetService("buildings")
    if buildings ~= nil then
        return buildings:BaitFarm(caster, target)
    end

    return false
end

function KoboldAbilityHelpers:DomesticateFarmSheep(caster, target)
    local buildings = self:GetService("buildings")
    if buildings ~= nil then
        return buildings:DomesticateFarmSheep(caster, target)
    end

    return false
end

function KoboldAbilityHelpers:HireMurlocSlave(caster, target)
    local buildings = self:GetService("buildings")
    if buildings ~= nil then
        return buildings:HireMurlocSlave(caster, target)
    end

    return false
end

function KoboldAbilityHelpers:CatchFish(caster, point, ability)
    local fishing = self:GetService("fishing")
    if fishing ~= nil then
        return fishing:Catch(caster, point, ability)
    end

    return nil, "missing_fishing_service"
end

function KoboldAbilityHelpers:DepositFirstItem(caster)
    local inventory = self:GetService("inventory")
    if inventory ~= nil then
        return inventory:DepositFirstStashableItem(caster)
    end

    return false, "missing_inventory_service"
end

function KoboldAbilityHelpers:WithdrawItem(caster, itemName, count)
    local inventory = self:GetService("inventory")
    if inventory ~= nil then
        return inventory:WithdrawItem(caster, itemName, count)
    end

    return false, "missing_inventory_service"
end

function KoboldAbilityHelpers:ReviveNearestDeadAlly(caster, shrine)
    local revival = self:GetService("revival")
    if revival ~= nil then
        return revival:ReviveNearestDeadAlly(caster, shrine)
    end

    return false, "missing_revival_service"
end

function KoboldAbilityHelpers:StartWeather(weatherId, duration)
    local weather = self:GetService("weather")
    if weather ~= nil then
        return weather:StartWeather(weatherId, duration)
    end

    return false
end

function KoboldAbilityHelpers:ApplyPlaceholderModifier(target, ability, modifierName, duration)
    if not self:IsAliveUnit(target) then
        return
    end

    target:AddNewModifier(target, ability, modifierName, { duration = duration })
end
