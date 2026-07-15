-- Attribute definitions. These are independent game attributes, not direct
-- aliases for Dota Strength, Agility, and Intelligence.

return {
    schemaVersion = 1,
    attributes = {
        {
            id = "attribute_strength",
            displayName = "Strength",
            affects = {
                "physical_attack_damage",
                "carrying_capacity",
                "selected_melee_abilities",
            },
            formulas = {
                physicalAttackDamagePerPoint = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "attribute_dexterity",
            displayName = "Dexterity",
            affects = {
                "attack_speed",
                "movement_speed",
                "stamina_recovery",
                "ranged_handling",
            },
            formulas = {
                attackSpeedPerPoint = "TODO_DESIGN_CONFIRMATION",
                movementSpeedPerPoint = "TODO_DESIGN_CONFIRMATION",
                staminaRecoveryPerPoint = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "attribute_endurance",
            displayName = "Endurance",
            affects = {
                "maximum_health",
                "stamina_efficiency",
                "maximum_stamina",
                "exhaustion_resistance",
            },
            formulas = {
                healthPerPoint = "TODO_DESIGN_CONFIRMATION",
                staminaEfficiencyPerPoint = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "attribute_intelligence",
            displayName = "Intelligence",
            affects = {
                "maximum_energy",
                "energy_regeneration",
                "bonus_experience",
                "alchemy_power",
            },
            formulas = {
                energyPerPoint = "TODO_DESIGN_CONFIRMATION",
                alchemyPowerPerPoint = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "attribute_willpower",
            displayName = "Willpower",
            affects = {
                "spell_power",
                "hunger_loss_efficiency",
                "status_resistance",
            },
            formulas = {
                spellPowerPerPoint = "TODO_DESIGN_CONFIRMATION",
                hungerEfficiencyPerPoint = "TODO_DESIGN_CONFIRMATION",
            },
        },
    },
}
