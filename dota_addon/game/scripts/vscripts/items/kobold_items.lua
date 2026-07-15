require("abilities/kobold_ability_helpers")
require("modifiers/kobold_modifiers")

local H = KoboldAbilityHelpers

LinkLuaModifier("modifier_food_endurance", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_food_dexterity", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_food_strength", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_food_bear_cutlet", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_food_glimmer_cheese", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_food_stag_stew_speed", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_status_stamina_exhausted", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_powdered_flask_cloud", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_powdered_flask_enemy", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_powdered_flask_ally", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleansing_draught_regeneration", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_diseased_cocktail_poison", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drunken_booze_buff", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lantern", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sleeping_bag", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_iron_banded_buckler", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_heavy_tower_shield", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mystic_tribal_shield", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_vengeful_murloc_skull", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_necromancers_necklace", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_conjurers_charm", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sharp_iron_pickaxe", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_elder_wand", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_enigmatic_staff", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_obedience_rod", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_murloc_doomhammer", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_fishing_rod", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_murlocket", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kobold_temporary_unit", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_status_resting", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_stationary_invisibility", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_jewel_danio_detection", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_highland_guppy_spell_duration", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_sunfish_warmth", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_slippery_eel_speed", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_albino_cavefish", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_toxic_frog_energy", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fish_tiger_gourami_pet_frenzy", "modifiers/kobold_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

item_food_roasted_lamb = class({})
item_food_wolf_steak = class({})
item_food_pheasant_berry_sauce = class({})
item_food_spiced_lamb_feast = class({})
item_food_grilled_wolf_entrecote = class({})
item_food_beer_braised_pheasant = class({})
item_food_burgundian_bear_cutlet = class({})
item_food_smoked_lamb_sirloin = class({})
item_food_glimmer_cheese = class({})
item_food_stag_stew = class({})

item_fish_striped_lurker = class({})
item_fish_blind_rainfish = class({})
item_fish_jewel_danio = class({})
item_fish_fire_ammonite = class({})
item_fish_forest_trout = class({})
item_fish_highland_guppy = class({})
item_fish_giant_sunfish = class({})
item_fish_slippery_eel = class({})
item_fish_albino_cavefish = class({})
item_fish_water_scorpion = class({})
item_fish_toxic_frog = class({})
item_fish_tiger_gourami = class({})
item_fishing_murloc_treat = class({})

item_active_powdered_flask = class({})
item_active_cleansing_draught = class({})
item_active_diseased_cocktail = class({})
item_active_unstable_concoction = class({})
item_active_drunken_booze = class({})
item_active_elixir_mastery = class({})
item_active_sleeping_bag = class({})
item_active_scroll_transmutation = class({})
item_active_tower_shield_brace = class({})
item_active_vengeful_murloc_skull = class({})
item_active_enigmatic_staff_restore = class({})
item_active_obedience_rod_pacify = class({})
item_active_murloc_doomhammer_slam = class({})

item_utility_lantern = class({})
item_utility_iron_banded_buckler = class({})
item_utility_heavy_tower_shield = class({})
item_utility_mystic_tribal_shield = class({})
item_utility_vengeful_murloc_skull = class({})
item_utility_necromancers_necklace = class({})
item_utility_conjurers_charm = class({})
item_utility_murlocket = class({})
item_tool_sharp_iron_pickaxe = class({})
item_tool_fishing_rod = class({})
item_weapon_elder_wand = class({})
item_weapon_enigmatic_staff = class({})
item_weapon_obedience_rod = class({})
item_weapon_murloc_doomhammer = class({})

local function consume_item(item)
    if item == nil or item:IsNull() then
        return
    end

    local caster = item:GetCaster()
    if caster ~= nil and not caster:IsNull() and caster.RemoveItem ~= nil then
        caster:RemoveItem(item)
    elseif UTIL_Remove ~= nil then
        UTIL_Remove(item)
    end
end

local function consume_food(item, modifierName)
    local caster = item:GetCaster()
    H:HealTarget(caster, item, item:GetSpecialValueFor("health_restore"))
    H:RestoreMana(caster, item:GetSpecialValueFor("mana_restore"))
    H:RestoreSurvival(caster, {
        hunger = item:GetSpecialValueFor("hunger_restore"),
        warmth = item:GetSpecialValueFor("warmth_restore"),
        stamina = item:GetSpecialValueFor("stamina_restore"),
    })

    local maxHealthRestorePct = item:GetSpecialValueFor("max_health_restore_pct")
    if maxHealthRestorePct ~= nil and maxHealthRestorePct > 0 then
        H:HealTarget(caster, item, math.floor(caster:GetMaxHealth() * maxHealthRestorePct / 100))
    end

    local maxManaRestorePct = item:GetSpecialValueFor("max_mana_restore_pct")
    if maxManaRestorePct ~= nil and maxManaRestorePct > 0 then
        H:RestoreMana(caster, math.floor(caster:GetMaxMana() * maxManaRestorePct / 100))
    end

    local duration = item:GetSpecialValueFor("buff_duration")
    if modifierName and duration > 0 then
        caster:AddNewModifier(caster, item, modifierName, { duration = duration })
    end

    consume_item(item)
end

function item_food_roasted_lamb:OnSpellStart()
    consume_food(self)
end

function item_food_wolf_steak:OnSpellStart()
    consume_food(self)
end

function item_food_pheasant_berry_sauce:OnSpellStart()
    consume_food(self)
end

function item_food_spiced_lamb_feast:OnSpellStart()
    consume_food(self, "modifier_food_endurance")
end

function item_food_grilled_wolf_entrecote:OnSpellStart()
    consume_food(self, "modifier_food_dexterity")
end

function item_food_beer_braised_pheasant:OnSpellStart()
    consume_food(self, "modifier_food_strength")
end

function item_food_burgundian_bear_cutlet:OnSpellStart()
    consume_food(self, "modifier_food_bear_cutlet")
end

function item_food_smoked_lamb_sirloin:OnSpellStart()
    consume_food(self)
end

function item_food_glimmer_cheese:OnSpellStart()
    consume_food(self, "modifier_food_glimmer_cheese")
end

function item_food_stag_stew:OnSpellStart()
    consume_food(self, "modifier_food_stag_stew_speed")
end

function item_fish_striped_lurker:OnSpellStart()
    consume_food(self, "modifier_fish_stationary_invisibility")
end

function item_fish_blind_rainfish:OnSpellStart()
    local caster = self:GetCaster()
    consume_food(self)
    H:StartWeather("rain", RandomInt(30, 60))
    H:Debug(caster, "Blind Rainfish calls rain")
end

function item_fish_jewel_danio:OnSpellStart()
    consume_food(self, "modifier_fish_jewel_danio_detection")
end

function item_fish_fire_ammonite:OnSpellStart()
    consume_food(self)
end

function item_fish_forest_trout:OnSpellStart()
    consume_food(self)
end

function item_fish_highland_guppy:OnSpellStart()
    consume_food(self, "modifier_fish_highland_guppy_spell_duration")
end

function item_fish_giant_sunfish:OnSpellStart()
    consume_food(self, "modifier_fish_sunfish_warmth")
end

function item_fish_slippery_eel:OnSpellStart()
    consume_food(self, "modifier_fish_slippery_eel_speed")
end

function item_fish_albino_cavefish:OnSpellStart()
    consume_food(self, "modifier_fish_albino_cavefish")
end

function item_fish_water_scorpion:OnSpellStart()
    consume_food(self)
end

function item_fish_toxic_frog:OnSpellStart()
    local caster = self:GetCaster()
    if H:IsAliveUnit(caster) and ApplyDamage ~= nil then
        ApplyDamage({
            victim = caster,
            attacker = caster,
            damage = math.floor(caster:GetHealth() * 0.35),
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL or 0,
            ability = self,
        })
    end

    caster:AddNewModifier(caster, self, "modifier_fish_toxic_frog_energy", { duration = self:GetSpecialValueFor("buff_duration") })
    consume_item(self)
end

function item_fish_tiger_gourami:OnSpellStart()
    local caster = self:GetCaster()
    consume_food(self, "modifier_fish_tiger_gourami_pet_frenzy")
    H:Debug(caster, "Tiger Gourami pet death-prevention aura prototype active")
end

function item_fishing_murloc_treat:OnSpellStart()
    local caster = self:GetCaster()
    local buildings = H:GetService("buildings")
    if buildings ~= nil then
        buildings:SpawnMurlocSlave(caster, caster:GetAbsOrigin() + RandomVector(180), 300)
    end

    consume_item(self)
end

function item_active_powdered_flask:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")

    if FindUnitsInRadius ~= nil then
        local units = FindUnitsInRadius(
            caster:GetTeamNumber(),
            point,
            nil,
            radius > 0 and radius or 275,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )

        for _, unit in ipairs(units) do
            if unit:GetTeamNumber() == caster:GetTeamNumber() then
                unit:AddNewModifier(caster, self, "modifier_powdered_flask_ally", { duration = duration > 0 and duration or 8 })
            else
                unit:AddNewModifier(caster, self, "modifier_powdered_flask_enemy", { duration = duration > 0 and duration or 8 })
            end
        end
    end

    H:Debug(caster, "powdered flask cloud at " .. tostring(point))
    consume_item(self)
end

function item_active_cleansing_draught:OnSpellStart()
    local caster = self:GetCaster()
    caster:Purge(false, true, false, true, true)
    caster:AddNewModifier(caster, self, "modifier_cleansing_draught_regeneration", { duration = self:GetSpecialValueFor("duration") })
    consume_item(self)
end

function item_active_diseased_cocktail:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    if FindUnitsInRadius ~= nil then
        local units = FindUnitsInRadius(
            caster:GetTeamNumber(),
            point,
            nil,
            275,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )

        for _, unit in ipairs(units) do
            unit:AddNewModifier(caster, self, "modifier_diseased_cocktail_poison", { duration = 8 })
        end
    end

    consume_item(self)
end

function item_active_unstable_concoction:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    if FindUnitsInRadius ~= nil then
        local units = FindUnitsInRadius(
            caster:GetTeamNumber(),
            point,
            nil,
            240,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )

        for _, unit in ipairs(units) do
            ApplyDamage({
                victim = unit,
                attacker = caster,
                damage = 95,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            })
            unit:AddNewModifier(caster, self, "modifier_status_stamina_exhausted", { duration = 1.0 })
        end
    end

    consume_item(self)
end

function item_active_drunken_booze:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_drunken_booze_buff", { duration = 10 })
    H:RestoreSurvival(caster, { warmth = 20, stamina = 20 })
    consume_item(self)
end

function item_active_elixir_mastery:OnSpellStart()
    local caster = self:GetCaster()
    H:AwardXp(caster, 250, "elixir_of_mastery")
    consume_item(self)
end

function item_active_sleeping_bag:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_status_resting", { duration = self:GetSpecialValueFor("duration") })
end

function item_active_scroll_transmutation:OnSpellStart()
    local target = self:GetCursorTarget()
    if not H:IsAliveUnit(target) then
        return
    end

    H:Debug(self:GetCaster(), "transmute tree target into elder tree; node replacement service pending")
end

function item_active_tower_shield_brace:OnSpellStart()
    H:Debug(self:GetCaster(), "tower shield brace active placeholder")
end

function item_active_vengeful_murloc_skull:OnSpellStart()
    H:Debug(self:GetCaster(), "vengeful murloc skull curse placeholder")
end

function item_active_enigmatic_staff_restore:OnSpellStart()
    H:Debug(self:GetCaster(), "enigmatic staff mana restoration placeholder")
end

function item_active_obedience_rod_pacify:OnSpellStart()
    H:Debug(self:GetCaster(), "obedience rod animal pacify placeholder")
end

function item_active_murloc_doomhammer_slam:OnSpellStart()
    H:Debug(self:GetCaster(), "murloc doomhammer slam placeholder")
end

function item_tool_fishing_rod:OnSpellStart()
    self.fishingPoint = self:GetCursorPosition()
end

function item_tool_fishing_rod:OnChannelFinish(interrupted)
    if interrupted then
        self.fishingPoint = nil
        return
    end

    local caster = self:GetCaster()
    local item, result = H:CatchFish(caster, self.fishingPoint or caster:GetAbsOrigin(), self)
    if type(result) == "string" and string.sub(result, 1, 5) == "item_" then
        H:Debug(caster, "caught " .. result)
    else
        H:Debug(caster, "failed to catch fish: " .. tostring(result))
    end

    self.fishingPoint = nil
end

function item_utility_lantern:GetIntrinsicModifierName()
    return "modifier_item_lantern"
end

function item_utility_iron_banded_buckler:GetIntrinsicModifierName()
    return "modifier_item_iron_banded_buckler"
end

function item_utility_heavy_tower_shield:GetIntrinsicModifierName()
    return "modifier_item_heavy_tower_shield"
end

function item_utility_mystic_tribal_shield:GetIntrinsicModifierName()
    return "modifier_item_mystic_tribal_shield"
end

function item_utility_vengeful_murloc_skull:GetIntrinsicModifierName()
    return "modifier_item_vengeful_murloc_skull"
end

function item_utility_necromancers_necklace:GetIntrinsicModifierName()
    return "modifier_item_necromancers_necklace"
end

function item_utility_conjurers_charm:GetIntrinsicModifierName()
    return "modifier_item_conjurers_charm"
end

function item_utility_murlocket:GetIntrinsicModifierName()
    return "modifier_item_murlocket"
end

function item_tool_sharp_iron_pickaxe:GetIntrinsicModifierName()
    return "modifier_item_sharp_iron_pickaxe"
end

function item_tool_fishing_rod:GetIntrinsicModifierName()
    return "modifier_item_fishing_rod"
end

function item_weapon_elder_wand:GetIntrinsicModifierName()
    return "modifier_item_elder_wand"
end

function item_weapon_enigmatic_staff:GetIntrinsicModifierName()
    return "modifier_item_enigmatic_staff"
end

function item_weapon_obedience_rod:GetIntrinsicModifierName()
    return "modifier_item_obedience_rod"
end

function item_weapon_murloc_doomhammer:GetIntrinsicModifierName()
    return "modifier_item_murloc_doomhammer"
end
