modifier_kobold_running = class({})
modifier_status_stamina_exhausted = class({})
modifier_status_starved = class({})
modifier_status_frostbite = class({})
modifier_status_resting = class({})
modifier_survival_hunger = class({})
modifier_survival_warmth = class({})
modifier_survival_stamina = class({})
modifier_campfire_warmth_aura_provider = class({})
modifier_campfire_warmth = class({})
modifier_campfire_animal_fear_aura_provider = class({})
modifier_animal_afraid_of_fire = class({})
modifier_tent_rest_aura_provider = class({})
modifier_tent_rest_recovery = class({})
modifier_kobold_harvesting_tree = class({})
modifier_kobold_mining = class({})
modifier_kobold_foraging = class({})
modifier_kobold_building = class({})
modifier_kobold_cooking = class({})
modifier_kobold_crafting = class({})
modifier_food_endurance = class({})
modifier_food_dexterity = class({})
modifier_food_strength = class({})
modifier_food_bear_cutlet = class({})
modifier_food_glimmer_cheese = class({})
modifier_food_stag_stew_speed = class({})
modifier_affliction = class({})
modifier_stealth = class({})
modifier_spell_shield = class({})
modifier_tribal_shield = class({})
modifier_powdered_flask_cloud = class({})
modifier_powdered_flask_enemy = class({})
modifier_powdered_flask_ally = class({})
modifier_cleansing_draught_regeneration = class({})
modifier_diseased_cocktail_poison = class({})
modifier_drunken_booze_buff = class({})
modifier_item_lantern = class({})
modifier_item_sleeping_bag = class({})
modifier_item_iron_banded_buckler = class({})
modifier_item_heavy_tower_shield = class({})
modifier_item_mystic_tribal_shield = class({})
modifier_item_vengeful_murloc_skull = class({})
modifier_item_necromancers_necklace = class({})
modifier_item_conjurers_charm = class({})
modifier_item_fishing_rod = class({})
modifier_item_murlocket = class({})
modifier_item_sharp_iron_pickaxe = class({})
modifier_item_elder_wand = class({})
modifier_item_enigmatic_staff = class({})
modifier_item_obedience_rod = class({})
modifier_item_murloc_doomhammer = class({})
modifier_boss_ritual_channel = class({})
modifier_kobold_temporary_unit = class({})
modifier_fish_stationary_invisibility = class({})
modifier_fish_jewel_danio_detection = class({})
modifier_fish_highland_guppy_spell_duration = class({})
modifier_fish_sunfish_warmth = class({})
modifier_fish_slippery_eel_speed = class({})
modifier_fish_albino_cavefish = class({})
modifier_fish_toxic_frog_energy = class({})
modifier_fish_tiger_gourami_pet_frenzy = class({})
modifier_fish_tiger_gourami_pet_buff = class({})
modifier_murloc_berserk = class({})

local hiddenModifierNames = {
    "modifier_survival_hunger",
    "modifier_survival_warmth",
    "modifier_survival_stamina",
    "modifier_campfire_warmth_aura_provider",
    "modifier_campfire_animal_fear_aura_provider",
    "modifier_tent_rest_aura_provider",
    "modifier_kobold_harvesting_tree",
    "modifier_kobold_mining",
    "modifier_kobold_foraging",
    "modifier_kobold_building",
    "modifier_kobold_cooking",
    "modifier_kobold_crafting",
    "modifier_kobold_temporary_unit",
}

for _, modifierName in pairs(hiddenModifierNames) do
    _G[modifierName].IsHidden = function()
        return true
    end
end

local unpurgableModifierNames = {
    "modifier_status_starved",
    "modifier_status_frostbite",
    "modifier_status_stamina_exhausted",
}

for _, modifierName in pairs(unpurgableModifierNames) do
    _G[modifierName].IsPurgable = function()
        return false
    end
end

function modifier_kobold_running:IsPurgable()
    return false
end

function modifier_kobold_running:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_kobold_running:GetModifierMoveSpeedBonus_Percentage()
    local ability = self:GetAbility()
    if ability then
        return ability:GetSpecialValueFor("move_speed_pct")
    end

    return 25
end

function modifier_status_stamina_exhausted:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_status_frostbite:CheckState()
    return {
        [MODIFIER_STATE_ROOTED] = true,
    }
end

function modifier_status_resting:CheckState()
    return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end

function modifier_status_resting:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_status_resting:GetModifierConstantHealthRegen()
    return 8
end

function modifier_status_resting:GetModifierConstantManaRegen()
    return 3
end

function modifier_campfire_warmth_aura_provider:IsAura()
    local parent = self:GetParent()
    return parent == nil or parent.koboldFuelSeconds == nil or parent.koboldFuelSeconds > 0
end

function modifier_campfire_warmth_aura_provider:GetModifierAura()
    return "modifier_campfire_warmth"
end

function modifier_campfire_warmth_aura_provider:GetAuraRadius()
    return 650
end

function modifier_campfire_warmth_aura_provider:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_campfire_warmth_aura_provider:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_campfire_warmth:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_campfire_warmth:GetModifierConstantHealthRegen()
    return 1.5
end

function modifier_campfire_animal_fear_aura_provider:IsAura()
    local parent = self:GetParent()
    return parent == nil or parent.koboldFuelSeconds == nil or parent.koboldFuelSeconds > 0
end

function modifier_campfire_animal_fear_aura_provider:GetModifierAura()
    return "modifier_animal_afraid_of_fire"
end

function modifier_campfire_animal_fear_aura_provider:GetAuraRadius()
    return 500
end

function modifier_campfire_animal_fear_aura_provider:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_campfire_animal_fear_aura_provider:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_animal_afraid_of_fire:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_animal_afraid_of_fire:GetModifierMoveSpeedBonus_Percentage()
    return -20
end

function modifier_animal_afraid_of_fire:GetModifierDamageOutgoing_Percentage()
    return -30
end

function modifier_tent_rest_aura_provider:IsAura()
    return true
end

function modifier_tent_rest_aura_provider:GetModifierAura()
    return "modifier_tent_rest_recovery"
end

function modifier_tent_rest_aura_provider:GetAuraRadius()
    return 450
end

function modifier_tent_rest_aura_provider:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tent_rest_aura_provider:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_tent_rest_recovery:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_tent_rest_recovery:GetModifierConstantHealthRegen()
    return 2
end

function modifier_tent_rest_recovery:GetModifierConstantManaRegen()
    return 1
end

function modifier_stealth:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end

function modifier_stealth:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    }
end

function modifier_stealth:GetModifierMoveSpeedBonus_Percentage()
    local ability = self:GetAbility()
    if ability then
        return ability:GetSpecialValueFor("move_speed_pct")
    end

    return 15
end

function modifier_stealth:GetModifierInvisibilityLevel()
    return 1
end

function modifier_affliction:IsDebuff()
    return true
end

local function declare_attribute_bonus()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_food_endurance:DeclareFunctions()
    return declare_attribute_bonus()
end

function modifier_food_endurance:GetModifierBonusStats_Strength()
    return self:GetAbility() and self:GetAbility():GetSpecialValueFor("attribute_bonus") or 5
end

function modifier_food_dexterity:DeclareFunctions()
    return declare_attribute_bonus()
end

function modifier_food_dexterity:GetModifierBonusStats_Agility()
    return self:GetAbility() and self:GetAbility():GetSpecialValueFor("attribute_bonus") or 5
end

function modifier_food_strength:DeclareFunctions()
    return declare_attribute_bonus()
end

function modifier_food_strength:GetModifierBonusStats_Intellect()
    return self:GetAbility() and self:GetAbility():GetSpecialValueFor("attribute_bonus") or 5
end

function modifier_food_bear_cutlet:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_food_bear_cutlet:GetModifierMagicalResistanceBonus()
    return self:GetAbility() and self:GetAbility():GetSpecialValueFor("cold_resistance_pct") or 15
end

function modifier_food_glimmer_cheese:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_food_glimmer_cheese:GetModifierIncomingDamage_Percentage()
    return -25
end

function modifier_food_stag_stew_speed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_food_stag_stew_speed:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility() and self:GetAbility():GetSpecialValueFor("move_speed_pct") or 7
end

function modifier_affliction:OnCreated()
    if not IsServer() then
        return
    end

    self:StartIntervalThink(1)
end

function modifier_affliction:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local parent = self:GetParent()

    if not ability or not caster or caster:IsNull() or not parent or parent:IsNull() then
        return
    end

    ApplyDamage({
        victim = parent,
        attacker = caster,
        damage = ability:GetSpecialValueFor("damage_per_second"),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability,
    })
end

function modifier_spell_shield:OnCreated()
    local ability = self:GetAbility()
    self.remainingBarrier = 150
    if ability then
        self.remainingBarrier = ability:GetSpecialValueFor("barrier_amount")
    end
end

function modifier_spell_shield:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    }
end

function modifier_spell_shield:GetModifierIncomingDamageConstant(event)
    if not IsServer() then
        return self.remainingBarrier or 0
    end

    if not self.remainingBarrier or self.remainingBarrier <= 0 then
        self:Destroy()
        return 0
    end

    local block = math.min(event.damage, self.remainingBarrier)
    self.remainingBarrier = self.remainingBarrier - block

    if self.remainingBarrier <= 0 then
        self:Destroy()
    end

    return -block
end

modifier_tribal_shield.OnCreated = modifier_spell_shield.OnCreated
modifier_tribal_shield.DeclareFunctions = modifier_spell_shield.DeclareFunctions
modifier_tribal_shield.GetModifierIncomingDamageConstant = modifier_spell_shield.GetModifierIncomingDamageConstant

function modifier_powdered_flask_enemy:IsDebuff()
    return true
end

function modifier_powdered_flask_enemy:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
    }
end

function modifier_powdered_flask_enemy:GetModifierMoveSpeedBonus_Percentage()
    return -20
end

function modifier_powdered_flask_enemy:GetBonusNightVision()
    return -250
end

function modifier_powdered_flask_enemy:GetBonusDayVision()
    return -200
end

function modifier_powdered_flask_ally:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end

function modifier_powdered_flask_ally:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_powdered_flask_ally:GetModifierInvisibilityLevel()
    return 1
end

function modifier_powdered_flask_ally:GetModifierMoveSpeedBonus_Percentage()
    return 15
end

function modifier_cleansing_draught_regeneration:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_cleansing_draught_regeneration:GetModifierConstantManaRegen()
    local ability = self:GetAbility()
    if ability then
        return ability:GetSpecialValueFor("mana_regen")
    end

    return 4
end

function modifier_diseased_cocktail_poison:IsDebuff()
    return true
end

function modifier_diseased_cocktail_poison:OnCreated()
    if not IsServer() then
        return
    end

    self:StartIntervalThink(1.0)
end

function modifier_diseased_cocktail_poison:OnIntervalThink()
    local parent = self:GetParent()
    local caster = self:GetCaster()
    if parent == nil or parent:IsNull() or caster == nil or caster:IsNull() then
        return
    end

    ApplyDamage({
        victim = parent,
        attacker = caster,
        damage = 12,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
    })
end

function modifier_diseased_cocktail_poison:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_diseased_cocktail_poison:GetModifierHealAmplify_PercentageTarget()
    return -40
end

function modifier_diseased_cocktail_poison:GetModifierConstantManaRegen()
    return -5
end

function modifier_drunken_booze_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_drunken_booze_buff:GetModifierMoveSpeedBonus_Percentage()
    return 10
end

function modifier_drunken_booze_buff:GetModifierAttackSpeedBonus_Constant()
    return 25
end

function modifier_drunken_booze_buff:GetModifierIncomingDamage_Percentage()
    return 8
end

function modifier_item_lantern:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
end

function modifier_item_lantern:GetBonusDayVision()
    return 250
end

function modifier_item_lantern:GetBonusNightVision()
    return 350
end

function modifier_item_iron_banded_buckler:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_iron_banded_buckler:GetModifierPhysicalArmorBonus()
    return 3
end

function modifier_item_heavy_tower_shield:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_heavy_tower_shield:GetModifierPhysicalArmorBonus()
    return 7
end

function modifier_item_heavy_tower_shield:GetModifierMoveSpeedBonus_Percentage()
    return -8
end

function modifier_item_mystic_tribal_shield:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_item_mystic_tribal_shield:GetModifierPhysicalArmorBonus()
    return 4
end

function modifier_item_mystic_tribal_shield:GetModifierMagicalResistanceBonus()
    return 12
end

function modifier_item_conjurers_charm:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_item_conjurers_charm:GetModifierManaBonus()
    return 80
end

function modifier_item_conjurers_charm:GetModifierConstantManaRegen()
    return 1.5
end

function modifier_item_fishing_rod:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_item_fishing_rod:GetModifierBonusStats_Strength()
    return 5
end

function modifier_item_murlocket:IsAura()
    return true
end

function modifier_item_murlocket:GetModifierAura()
    return "modifier_murloc_berserk"
end

function modifier_item_murlocket:GetAuraRadius()
    return 900
end

function modifier_item_murlocket:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_murlocket:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_item_murlocket:GetAuraEntityReject(unit)
    return unit == nil or unit:GetUnitName() ~= "npc_kobold_murloc_slave"
end

function modifier_murloc_berserk:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_murloc_berserk:GetModifierAttackSpeedBonus_Constant()
    return 35
end

function modifier_murloc_berserk:GetModifierMoveSpeedBonus_Percentage()
    return 20
end

function modifier_murloc_berserk:GetModifierPreAttack_BonusDamage()
    return 12
end

function modifier_item_sharp_iron_pickaxe:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_sharp_iron_pickaxe:GetModifierPreAttack_BonusDamage()
    return 8
end

function modifier_item_elder_wand:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_elder_wand:GetModifierSpellAmplify_Percentage()
    return 8
end

function modifier_item_enigmatic_staff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_enigmatic_staff:GetModifierManaBonus()
    return 120
end

function modifier_item_enigmatic_staff:GetModifierSpellAmplify_Percentage()
    return 10
end

function modifier_item_murloc_doomhammer:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_murloc_doomhammer:GetModifierPreAttack_BonusDamage()
    return 24
end

function modifier_item_murloc_doomhammer:GetModifierPhysicalArmorBonus()
    return 4
end

function modifier_kobold_temporary_unit:OnDestroy()
    if not IsServer() then
        return
    end

    local parent = self:GetParent()
    if parent ~= nil and not parent:IsNull() and parent:IsAlive() then
        parent:ForceKill(false)
    end
end

function modifier_fish_stationary_invisibility:OnCreated()
    if not IsServer() then
        return
    end

    self.lastPosition = self:GetParent():GetAbsOrigin()
    self.stationary = true
    self:StartIntervalThink(0.25)
end

function modifier_fish_stationary_invisibility:OnIntervalThink()
    local parent = self:GetParent()
    local position = parent:GetAbsOrigin()
    local dx = position.x - self.lastPosition.x
    local dy = position.y - self.lastPosition.y
    self.stationary = (dx * dx + dy * dy) < 64
    self.lastPosition = position
end

function modifier_fish_stationary_invisibility:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = self.stationary == true,
    }
end

function modifier_fish_stationary_invisibility:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    }
end

function modifier_fish_stationary_invisibility:GetModifierInvisibilityLevel()
    return self.stationary == true and 1 or 0
end

function modifier_fish_jewel_danio_detection:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
end

function modifier_fish_jewel_danio_detection:GetBonusDayVision()
    return 260
end

function modifier_fish_jewel_danio_detection:GetBonusNightVision()
    return 260
end

function modifier_fish_highland_guppy_spell_duration:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_fish_highland_guppy_spell_duration:GetModifierSpellAmplify_Percentage()
    return 6
end

function modifier_fish_sunfish_warmth:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_fish_sunfish_warmth:GetModifierMagicalResistanceBonus()
    return 10
end

function modifier_fish_slippery_eel_speed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_fish_slippery_eel_speed:GetModifierAttackSpeedBonus_Constant()
    return 25
end

function modifier_fish_albino_cavefish:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
end

function modifier_fish_albino_cavefish:GetModifierPhysicalArmorBonus()
    return 8
end

function modifier_fish_albino_cavefish:GetBonusDayVision()
    return -150
end

function modifier_fish_albino_cavefish:GetBonusNightVision()
    return -150
end

function modifier_fish_toxic_frog_energy:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_fish_toxic_frog_energy:GetModifierConstantManaRegen()
    return 10
end

function modifier_fish_tiger_gourami_pet_frenzy:IsAura()
    return true
end

function modifier_fish_tiger_gourami_pet_frenzy:GetModifierAura()
    return "modifier_fish_tiger_gourami_pet_buff"
end

function modifier_fish_tiger_gourami_pet_frenzy:GetAuraRadius()
    return 900
end

function modifier_fish_tiger_gourami_pet_frenzy:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fish_tiger_gourami_pet_frenzy:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_fish_tiger_gourami_pet_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_fish_tiger_gourami_pet_buff:GetModifierAttackSpeedBonus_Constant()
    return 30
end

function modifier_fish_tiger_gourami_pet_buff:GetModifierMoveSpeedBonus_Percentage()
    return 25
end
