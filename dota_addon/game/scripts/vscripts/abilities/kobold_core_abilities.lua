require("abilities/kobold_ability_helpers")
require("modifiers/kobold_modifiers")

local H = KoboldAbilityHelpers

LinkLuaModifier("modifier_kobold_running", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_status_stamina_exhausted", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_status_starved", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_status_frostbite", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_survival_hunger", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_survival_warmth", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_survival_stamina", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_campfire_warmth_aura_provider", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_campfire_warmth", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_campfire_animal_fear_aura_provider", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_animal_afraid_of_fire", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tent_rest_aura_provider", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tent_rest_recovery", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kobold_harvesting_tree", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kobold_mining", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kobold_building", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kobold_cooking", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_affliction", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stealth", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spell_shield", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tribal_shield", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_ritual_channel", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kobold_temporary_unit", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

ability_kobold_run = class({})
ability_kobold_walk = class({})
ability_kobold_stop = class({})
ability_kobold_basic_attack = class({})
ability_kobold_interact = class({})
ability_kobold_gather_contextual = class({})
ability_kobold_pickup_item = class({})
ability_kobold_drop_item = class({})
ability_kobold_consume_food = class({})
ability_kobold_open_build_menu = class({})
ability_kobold_open_inventory = class({})
ability_kobold_open_cooking_menu = class({})
ability_kobold_open_crafting_menu = class({})
ability_kobold_allocate_skill_points = class({})
ability_kobold_inspect_survival = class({})
ability_kobold_equip_item = class({})
ability_kobold_unequip_item = class({})
ability_kobold_plant_tree = class({})
ability_kobold_build_campfire = class({})
ability_kobold_build_tent = class({})
ability_kobold_build_farm = class({})
ability_kobold_build_workbench = class({})
ability_kobold_build_smithy = class({})
ability_kobold_build_storage = class({})
ability_kobold_build_hunters_lodge = class({})
ability_kobold_build_tavern = class({})
ability_kobold_build_spike_trap = class({})
ability_kobold_bait_farm = class({})
ability_kobold_domesticate_farm_sheep = class({})
ability_kobold_hire_murloc_slave = class({})
ability_kobold_deposit_first_item = class({})
ability_kobold_withdraw_roasted_lamb = class({})
ability_kobold_revive_ally = class({})
ability_kobold_fell_tree = class({})
ability_kobold_fell_elder_tree = class({})
ability_kobold_mine_stone = class({})
ability_kobold_mine_gold = class({})
ability_kobold_mine_iron = class({})
ability_kobold_mine_shadowstone = class({})
ability_kobold_mine_radiant_gemstone = class({})
ability_kobold_pick_berries = class({})
ability_kobold_harvest_spicy_herbs = class({})
ability_kobold_harvest_sageberry = class({})
ability_kobold_harvest_lambent_sunflower = class({})
ability_kobold_cook_recipe = class({})
ability_kobold_refuel_campfire = class({})
ability_spell_affliction = class({})
ability_spell_stealth = class({})
ability_spell_siphon_life = class({})
ability_spell_shield = class({})
ability_spell_tribal_shield = class({})
ability_ritual_summon_raging_arcane_beast = class({})

action_skill_spend_forestry = class({})
action_skill_spend_cooking = class({})
action_skill_spend_mining = class({})
action_skill_spend_foraging = class({})
action_skill_spend_artisanship = class({})

passive_survival_hunger_drain = class({})
passive_survival_warmth_drain = class({})
passive_survival_running_drain = class({})
passive_survival_stamina_collapse = class({})
passive_survival_starved = class({})
passive_survival_frostbite = class({})
passive_campfire_warmth_aura = class({})
passive_campfire_animal_fear = class({})
passive_tent_stamina_recovery = class({})
passive_campfire_fuel_timer = class({})
passive_campfire_light = class({})
passive_farm_sheep_production = class({})
passive_farm_pheasant_bait = class({})
passive_spike_trap_trigger = class({})
passive_wolf_neutral_temperament = class({})
passive_wolf_fear_fire = class({})
passive_wolf_loot = class({})
passive_dire_wolf_night_aggression = class({})
passive_dire_wolf_fear_fire = class({})
passive_dire_wolf_loot = class({})
passive_animal_sheep_loot = class({})
passive_animal_pheasant_loot = class({})
passive_bear_territorial_behavior = class({})
passive_bear_heavy_attack = class({})
passive_bear_loot = class({})

quest_murloc_chieftain = class({})
quest_treasure_goblin = class({})
quest_wounded_wizard = class({})
quest_darkness_shrine_sequence = class({})
ability_quest_aid_wounded_wizard = class({})
ability_shrine_guardian_fire_projectile = class({})
passive_shrine_sequence_controller = class({})
passive_shrine_circle_trigger = class({})

boss_passive_arcane_scaling = class({})
boss_ability_arcane_burst = class({})
boss_ability_arcane_projectile = class({})
boss_ability_arcane_field = class({})
boss_passive_phase_controller = class({})
boss_passive_loot_controller = class({})

function ability_kobold_run:OnToggle()
    local caster = self:GetCaster()
    if not H:IsAliveUnit(caster) then
        return
    end

    if self:GetToggleState() then
        caster:AddNewModifier(caster, self, "modifier_kobold_running", {})
    else
        caster:RemoveModifierByName("modifier_kobold_running")
    end
end

function ability_kobold_walk:OnSpellStart()
    local caster = self:GetCaster()
    caster:RemoveModifierByName("modifier_kobold_running")
    H:Debug(caster, "walk mode")
end

function ability_kobold_stop:OnSpellStart()
    self:GetCaster():Stop()
end

function ability_kobold_basic_attack:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if H:IsAliveUnit(target) then
        caster:MoveToTargetToAttack(target)
    end
end

function ability_kobold_interact:OnSpellStart()
    H:Debug(self:GetCaster(), "interact dispatched; interactable service pending")
end

function ability_kobold_gather_contextual:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if not H:IsAliveUnit(target) or target.koboldResourceNodeId == nil then
        H:Debug(caster, "no harvestable target")
        return
    end

    local rewards = {
        node_ordinary_tree = { id = "resource_lumber", amount = 1, xp = 22 },
        node_elder_tree = { id = "resource_infused_lumber", amount = 1, xp = 100 },
        node_stone_deposit = { id = "resource_stone", amount = 1, xp = 20 },
        node_gold_deposit = { id = "resource_gold", amount = 1, xp = 5 },
        node_iron_deposit = { id = "resource_iron", amount = 1, xp = 35 },
        node_shadowstone_source = { id = "resource_shadowstone", amount = 1, xp = 70 },
        node_radiant_gemstone_source = { id = "resource_radiant_gemstone", amount = 1, xp = 70 },
        node_berry_bush = { id = "ingredient_handful_berries", amount = 1, xp = 10 },
        node_spicy_herbs = { id = "ingredient_spicy_herbs", amount = 1, xp = 10 },
        node_sageberry = { id = "ingredient_sageberry", amount = 1, xp = 35 },
        node_lambent_sunflower = { id = "ingredient_lambent_sunflower", amount = 1, xp = 35 },
    }

    local reward = rewards[target.koboldResourceNodeId]
    if reward == nil then
        H:Debug(caster, "unknown resource node " .. tostring(target.koboldResourceNodeId))
        return
    end

    H:GrantResource(caster, reward.id, reward.amount)
    H:AwardXp(caster, reward.xp, "gather_contextual")
    target:ForceKill(false)
end

function ability_kobold_pickup_item:OnSpellStart()
    H:Debug(self:GetCaster(), "pickup item; inventory service pending")
end

function ability_kobold_drop_item:OnSpellStart()
    H:Debug(self:GetCaster(), "drop item; inventory service pending")
end

function ability_kobold_consume_food:OnSpellStart()
    H:Debug(self:GetCaster(), "consume selected food; inventory service pending")
end

function ability_kobold_open_build_menu:OnSpellStart()
    H:Debug(self:GetCaster(), "open build menu; Panorama pending")
end

function ability_kobold_open_inventory:OnSpellStart()
    H:Debug(self:GetCaster(), "open inventory; Panorama pending")
end

function ability_kobold_open_cooking_menu:OnSpellStart()
    H:Debug(self:GetCaster(), "open cooking menu; Panorama pending")
end

function ability_kobold_open_crafting_menu:OnSpellStart()
    H:Debug(self:GetCaster(), "open crafting menu; Panorama pending")
end

function ability_kobold_allocate_skill_points:OnSpellStart()
    H:Debug(self:GetCaster(), "open skill allocation; Panorama pending")
end

function ability_kobold_inspect_survival:OnSpellStart()
    H:Debug(self:GetCaster(), "inspect survival; Panorama pending")
end

function ability_kobold_equip_item:OnSpellStart()
    H:Debug(self:GetCaster(), "equip item; inventory service pending")
end

function ability_kobold_unequip_item:OnSpellStart()
    H:Debug(self:GetCaster(), "unequip item; inventory service pending")
end

function ability_kobold_plant_tree:OnSpellStart()
    self.plantPoint = self:GetCursorPosition()
end

function ability_kobold_plant_tree:OnChannelFinish(interrupted)
    if interrupted then
        return
    end

    local spawns = H:GetService("spawns")
    if spawns ~= nil then
        spawns:SpawnResource("node_ordinary_tree", self.plantPoint)
    else
        H:Debug(self:GetCaster(), "plant tree at " .. tostring(self.plantPoint))
    end

    H:AwardXp(self:GetCaster(), self:GetSpecialValueFor("xp"), "plant_tree")
end

local function start_point_channel(ability)
    ability.targetPoint = ability:GetCursorPosition()
end

local function start_build(ability, buildingId)
    start_point_channel(ability)
    ability.buildingId = buildingId
    ability.buildReservationId = H:BeginBuild(ability:GetCaster(), ability, buildingId, ability.targetPoint)

    if ability.buildReservationId == nil then
        ability:GetCaster():Interrupt()
    end
end

local function finish_build(ability, interrupted, buildingId, xp)
    local unit = H:FinishBuild(ability.buildReservationId, interrupted)
    ability.buildReservationId = nil

    if interrupted or unit == nil then
        return
    end

    local caster = ability:GetCaster()
    H:Debug(caster, "built " .. buildingId .. " at " .. tostring(ability.targetPoint))
    H:AwardXp(caster, xp or ability:GetSpecialValueFor("xp"), "build_" .. buildingId)
end

function ability_kobold_build_campfire:OnSpellStart()
    start_build(self, "building_campfire")
end

function ability_kobold_build_campfire:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_campfire", 50)
end

function ability_kobold_build_tent:OnSpellStart()
    start_build(self, "building_tent")
end

function ability_kobold_build_tent:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_tent", 50)
end

function ability_kobold_build_farm:OnSpellStart()
    start_build(self, "building_farm")
end

function ability_kobold_build_farm:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_farm", 50)
end

function ability_kobold_build_workbench:OnSpellStart()
    start_build(self, "building_workbench")
end

function ability_kobold_build_workbench:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_workbench", 50)
end

function ability_kobold_build_smithy:OnSpellStart()
    start_build(self, "building_smithy")
end

function ability_kobold_build_smithy:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_smithy", 78)
end

function ability_kobold_build_storage:OnSpellStart()
    start_build(self, "building_storage")
end

function ability_kobold_build_storage:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_storage", 120)
end

function ability_kobold_build_hunters_lodge:OnSpellStart()
    start_build(self, "building_hunters_lodge")
end

function ability_kobold_build_hunters_lodge:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_hunters_lodge", 120)
end

function ability_kobold_build_tavern:OnSpellStart()
    start_build(self, "building_tavern")
end

function ability_kobold_build_tavern:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_tavern", 120)
end

function ability_kobold_build_spike_trap:OnSpellStart()
    start_build(self, "building_spike_trap")
end

function ability_kobold_build_spike_trap:OnChannelFinish(interrupted)
    finish_build(self, interrupted, "building_spike_trap", 40)
end

function ability_kobold_bait_farm:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local ok, err = H:BaitFarm(caster, target)
    if not ok then
        H:Debug(caster, "cannot bait farm: " .. tostring(err))
    end
end

function ability_kobold_domesticate_farm_sheep:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local ok, err = H:DomesticateFarmSheep(caster, target)
    if not ok then
        H:Debug(caster, "cannot domesticate farm sheep: " .. tostring(err))
    end
end

function ability_kobold_hire_murloc_slave:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local ok, err = H:HireMurlocSlave(caster, target)
    if not ok then
        H:Debug(caster, "cannot hire murloc slave: " .. tostring(err))
    end
end

function ability_kobold_deposit_first_item:OnSpellStart()
    local caster = self:GetCaster()
    local ok, result = H:DepositFirstItem(caster)
    if ok then
        H:Debug(caster, "stashed " .. tostring(result))
    else
        H:Debug(caster, "cannot stash item: " .. tostring(result))
    end
end

function ability_kobold_withdraw_roasted_lamb:OnSpellStart()
    local caster = self:GetCaster()
    local ok, result = H:WithdrawItem(caster, "item_food_roasted_lamb", 1)
    if ok then
        H:Debug(caster, "withdrew " .. tostring(result))
    else
        H:Debug(caster, "cannot withdraw roasted lamb: " .. tostring(result))
    end
end

function ability_kobold_revive_ally:OnSpellStart()
    self.revivalTarget = self:GetCursorTarget()
end

function ability_kobold_revive_ally:OnChannelFinish(interrupted)
    if interrupted then
        self.revivalTarget = nil
        return
    end

    local caster = self:GetCaster()
    local ok, result = H:ReviveNearestDeadAlly(caster, self.revivalTarget)
    if ok then
        H:Debug(caster, "revived ally through shrine")
    else
        H:Debug(caster, "cannot revive ally: " .. tostring(result))
    end

    self.revivalTarget = nil
end

local function start_target_channel(ability)
    ability.channelTarget = ability:GetCursorTarget()
end

local function finish_harvest(ability, interrupted, resourceId, amount, xp, reason)
    if interrupted then
        ability.channelTarget = nil
        return
    end

    local caster = ability:GetCaster()
    H:GrantResource(caster, resourceId, amount)
    H:AwardXp(caster, xp, reason)

    if H:IsAliveUnit(ability.channelTarget) and ability.channelTarget.ForceKill ~= nil then
        ability.channelTarget:ForceKill(false)
    end

    ability.channelTarget = nil
end

function ability_kobold_fell_tree:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_fell_tree:OnChannelFinish(interrupted)
    finish_harvest(self, interrupted, "resource_lumber", 1, 22, "fell_tree")
end

function ability_kobold_fell_elder_tree:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_fell_elder_tree:OnChannelFinish(interrupted)
    if interrupted then
        return
    end

    local caster = self:GetCaster()
    H:GrantResource(caster, "resource_lumber", 3)
    H:GrantResource(caster, "resource_infused_lumber", 1)
    H:AwardXp(caster, 100, "fell_elder_tree")

    if H:IsAliveUnit(self.channelTarget) and self.channelTarget.ForceKill ~= nil then
        self.channelTarget:ForceKill(false)
    end

    self.channelTarget = nil
end

function ability_kobold_mine_stone:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_mine_stone:OnChannelFinish(interrupted)
    finish_harvest(self, interrupted, "resource_stone", 1, 20, "mine_stone")
end

function ability_kobold_mine_gold:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_mine_gold:OnChannelFinish(interrupted)
    finish_harvest(self, interrupted, "resource_gold", 1, 5, "mine_gold")
end

function ability_kobold_mine_iron:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_mine_iron:OnChannelFinish(interrupted)
    finish_harvest(self, interrupted, "resource_iron", 1, self:GetSpecialValueFor("xp"), "mine_iron")
end

function ability_kobold_mine_shadowstone:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_mine_shadowstone:OnChannelFinish(interrupted)
    finish_harvest(self, interrupted, "resource_shadowstone", 1, self:GetSpecialValueFor("xp"), "mine_shadowstone")
end

function ability_kobold_mine_radiant_gemstone:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_mine_radiant_gemstone:OnChannelFinish(interrupted)
    finish_harvest(self, interrupted, "resource_radiant_gemstone", 1, self:GetSpecialValueFor("xp"), "mine_radiant_gemstone")
end

local function finish_forage(ability, interrupted, itemId, xp, reason)
    if interrupted then
        return
    end

    H:GrantResource(ability:GetCaster(), itemId, 1)
    H:AwardXp(ability:GetCaster(), xp, reason)

    if H:IsAliveUnit(ability.channelTarget) and ability.channelTarget.ForceKill ~= nil then
        ability.channelTarget:ForceKill(false)
    end

    ability.channelTarget = nil
end

function ability_kobold_pick_berries:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_pick_berries:OnChannelFinish(interrupted)
    finish_forage(self, interrupted, "ingredient_handful_berries", 10, "pick_berries")
end

function ability_kobold_harvest_spicy_herbs:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_harvest_spicy_herbs:OnChannelFinish(interrupted)
    finish_forage(self, interrupted, "ingredient_spicy_herbs", 10, "harvest_spicy_herbs")
end

function ability_kobold_harvest_sageberry:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_harvest_sageberry:OnChannelFinish(interrupted)
    finish_forage(self, interrupted, "ingredient_sageberry", self:GetSpecialValueFor("xp"), "harvest_sageberry")
end

function ability_kobold_harvest_lambent_sunflower:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_harvest_lambent_sunflower:OnChannelFinish(interrupted)
    finish_forage(self, interrupted, "ingredient_lambent_sunflower", self:GetSpecialValueFor("xp"), "harvest_lambent_sunflower")
end

function ability_kobold_cook_recipe:OnSpellStart()
    self.recipeId = self.recipeId or "recipe_roasted_lamb"
end

function ability_kobold_cook_recipe:OnChannelFinish(interrupted)
    if interrupted then
        return
    end

    local caster = self:GetCaster()
    if not H:CompleteRecipe(caster, self.recipeId) then
        H:Debug(caster, "complete cooking " .. self.recipeId)
        H:AwardXp(caster, self:GetSpecialValueFor("xp"), self.recipeId)
    end
end

function ability_kobold_refuel_campfire:OnSpellStart()
    start_target_channel(self)
end

function ability_kobold_refuel_campfire:OnChannelFinish(interrupted)
    if interrupted then
        return
    end

    if H:RefuelCampfire(self:GetCaster(), self.channelTarget) then
        H:AwardXp(self:GetCaster(), 20, "refuel_campfire")
    else
        H:Debug(self:GetCaster(), "refuel failed; target is not a campfire or tribe lacks lumber")
    end

    self.channelTarget = nil
end

function ability_spell_affliction:OnSpellStart()
    local target = self:GetCursorTarget()
    if not H:IsAliveUnit(target) then
        return
    end

    target:AddNewModifier(self:GetCaster(), self, "modifier_affliction", { duration = self:GetSpecialValueFor("duration") })
end

function ability_spell_stealth:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_stealth", { duration = self:GetSpecialValueFor("duration") })
end

function ability_spell_siphon_life:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if not H:IsAliveUnit(target) then
        return
    end

    local damage = self:GetSpecialValueFor("damage")
    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
    })

    H:HealTarget(caster, self, math.floor(damage * self:GetSpecialValueFor("heal_pct") / 100))
end

function ability_spell_shield:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget() or caster
    if not H:IsFriendlyTarget(caster, target) then
        return
    end

    target:AddNewModifier(caster, self, "modifier_spell_shield", { duration = self:GetSpecialValueFor("duration") })
end

function ability_spell_tribal_shield:OnSpellStart()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("radius")
    local allies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, ally in pairs(allies) do
        ally:AddNewModifier(caster, self, "modifier_tribal_shield", { duration = self:GetSpecialValueFor("duration") })
    end
end

function ability_ritual_summon_raging_arcane_beast:OnSpellStart()
    self.ritualPoint = self:GetCursorPosition()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_ritual_channel", { duration = self:GetChannelTime() })
end

function ability_ritual_summon_raging_arcane_beast:OnChannelFinish(interrupted)
    self:GetCaster():RemoveModifierByName("modifier_boss_ritual_channel")
    if interrupted then
        return
    end

    local spawns = H:GetService("spawns")
    if spawns ~= nil then
        spawns:SpawnBoss("boss_raging_arcane_beast", self.ritualPoint)
    end

    H:Debug(self:GetCaster(), "summon boss_raging_arcane_beast at " .. tostring(self.ritualPoint))
end

local function spend_skill_point(ability, skillId)
    local progression = H:GetService("progression")
    if progression ~= nil and progression:SpendSkillPoint(ability:GetCaster(), skillId) then
        H:Debug(ability:GetCaster(), "spent skill point: " .. skillId)
        return
    end

    H:Debug(ability:GetCaster(), "could not spend skill point: " .. skillId)
end

function action_skill_spend_forestry:OnSpellStart()
    spend_skill_point(self, "skill_forestry")
end

function action_skill_spend_cooking:OnSpellStart()
    spend_skill_point(self, "skill_cooking")
end

function action_skill_spend_mining:OnSpellStart()
    spend_skill_point(self, "skill_mining")
end

function action_skill_spend_foraging:OnSpellStart()
    spend_skill_point(self, "skill_foraging")
end

function action_skill_spend_artisanship:OnSpellStart()
    spend_skill_point(self, "skill_artisanship")
end

function passive_survival_hunger_drain:GetIntrinsicModifierName()
    return "modifier_survival_hunger"
end

function passive_survival_warmth_drain:GetIntrinsicModifierName()
    return "modifier_survival_warmth"
end

function passive_survival_running_drain:GetIntrinsicModifierName()
    return "modifier_survival_stamina"
end

function passive_survival_stamina_collapse:GetIntrinsicModifierName()
    return "modifier_survival_stamina"
end

function passive_survival_starved:GetIntrinsicModifierName()
    return "modifier_status_starved"
end

function passive_survival_frostbite:GetIntrinsicModifierName()
    return "modifier_status_frostbite"
end

function passive_campfire_warmth_aura:GetIntrinsicModifierName()
    return "modifier_campfire_warmth_aura_provider"
end

function passive_campfire_animal_fear:GetIntrinsicModifierName()
    return "modifier_campfire_animal_fear_aura_provider"
end

function passive_tent_stamina_recovery:GetIntrinsicModifierName()
    return "modifier_tent_rest_aura_provider"
end

function passive_campfire_fuel_timer:GetIntrinsicModifierName()
    return "modifier_campfire_warmth_aura_provider"
end

function passive_campfire_light:GetIntrinsicModifierName()
    return "modifier_campfire_warmth_aura_provider"
end

function passive_farm_sheep_production:OnOwnerSpawned()
    H:Debug(self:GetCaster(), "farm sheep production passive active; farm service pending")
end

function passive_spike_trap_trigger:OnOwnerSpawned()
    H:Debug(self:GetCaster(), "spike trap trigger passive active; trap service pending")
end

function passive_wolf_fear_fire:GetIntrinsicModifierName()
    return "modifier_animal_afraid_of_fire"
end

function passive_dire_wolf_fear_fire:GetIntrinsicModifierName()
    return "modifier_animal_afraid_of_fire"
end

function passive_animal_sheep_loot:OnOwnerDied()
    H:Debug(self:GetCaster(), "sheep loot passive died; entity_killed service pending")
end

function quest_murloc_chieftain:OnOwnerSpawned()
    H:Debug(self:GetCaster(), "Murloc Chieftain quest controller placeholder")
end

function quest_treasure_goblin:OnOwnerSpawned()
    H:Debug(self:GetCaster(), "Treasure Goblin quest controller placeholder")
end

function quest_wounded_wizard:OnOwnerSpawned()
    H:Debug(self:GetCaster(), "Wounded Wizard quest controller placeholder")
end

function quest_darkness_shrine_sequence:OnOwnerSpawned()
    H:Debug(self:GetCaster(), "Darkness Shrine sequence controller placeholder")
end

function ability_quest_aid_wounded_wizard:OnSpellStart()
    start_target_channel(self)
end

function ability_quest_aid_wounded_wizard:OnChannelFinish(interrupted)
    if interrupted then
        return
    end

    H:Debug(self:GetCaster(), "aid wounded wizard complete; quest service pending")
end

function ability_shrine_guardian_fire_projectile:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = H:GetSpecialValue(self, "radius", 180)
    local damage = H:GetSpecialValue(self, "damage", 80)
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        point,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in ipairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        })
    end
end

function boss_ability_arcane_burst:OnSpellStart()
    local caster = self:GetCaster()
    local radius = H:GetSpecialValue(self, "radius", 360)
    local damage = H:GetSpecialValue(self, "damage", 90)
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in ipairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        })
    end
end

function boss_ability_arcane_projectile:OnSpellStart()
    local target = self:GetCursorTarget()
    if not H:IsAliveUnit(target) then
        return
    end

    ApplyDamage({
        victim = target,
        attacker = self:GetCaster(),
        damage = H:GetSpecialValue(self, "damage", 120),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
    })
end

function boss_ability_arcane_field:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = H:GetSpecialValue(self, "radius", 300)
    local damage = H:GetSpecialValue(self, "damage", 70)
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        point,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in ipairs(enemies) do
        ApplyDamage({
            victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        })
        enemy:AddNewModifier(caster, self, "modifier_status_frostbite", { duration = 1.0 })
    end
end
