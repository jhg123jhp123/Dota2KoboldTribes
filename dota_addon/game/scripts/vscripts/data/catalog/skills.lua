return {
    schemaVersion = 1,
    startingPoints = 0,
    manualAllocation = true,
    milestonePoints = { 15, 20, 25 },
    skills = {
        {
            id = "skill_forestry",
            displayName = "Forestry",
            perPointEffects = {
                treeDamage = 1.5,
                structureDamage = 1,
                armour = 0.2,
                staminaRestoredOnTreeFelled = "TODO_DESIGN_CONFIRMATION",
                warmthRestoredOnTreeFelled = "TODO_DESIGN_CONFIRMATION",
                plantTreeCooldownReduction = "TODO_DESIGN_CONFIRMATION",
                plantedTreeGrowthSpeed = "TODO_DESIGN_CONFIRMATION",
            },
            milestones = {
                [15] = {
                    effects = {
                        "additional_plant_tree_charge",
                        "fast_early_planted_tree_growth",
                        "chance_to_auto_plant_replacement",
                    },
                },
                [20] = {
                    effects = {
                        "heal_for_percentage_of_tree_and_structure_damage",
                        "growing_trees_create_non_stacking_ally_healing_aura",
                    },
                },
                [25] = {
                    effects = {
                        "additional_plant_tree_charge",
                        "mature_planted_trees_cleanse_nearby_allies_with_internal_cooldown",
                        "completed_tree_growth_grants_temporary_energy_regeneration",
                    },
                },
            },
        },
        {
            id = "skill_mining",
            displayName = "Mining",
            perPointEffects = {
                miningDamageOrSpeed = "TODO_DESIGN_CONFIRMATION",
                staminaCostReduction = "TODO_DESIGN_CONFIRMATION",
                yieldBonus = "TODO_DESIGN_CONFIRMATION",
                rareMineralChance = "TODO_DESIGN_CONFIRMATION",
                pickaxeEffectiveness = "TODO_DESIGN_CONFIRMATION",
            },
            milestones = {
                [15] = "TODO_DESIGN_CONFIRMATION",
                [20] = "TODO_DESIGN_CONFIRMATION",
                [25] = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "skill_cooking",
            displayName = "Cooking",
            recipeUnlockEveryPoints = 5,
            perPointEffects = {
                cookedFoodRestorationPct = 2,
                cookingSpeedPct = 1.5,
                potionThrowCooldownReduction = "TODO_DESIGN_CONFIRMATION",
                campfireDurationBonus = "TODO_DESIGN_CONFIRMATION",
            },
            milestones = {
                [15] = "TODO_DESIGN_CONFIRMATION",
                [20] = "TODO_DESIGN_CONFIRMATION",
                [25] = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "skill_foraging",
            displayName = "Foraging",
            perPointEffects = {
                harvestSpeed = "TODO_DESIGN_CONFIRMATION",
                plantYield = "TODO_DESIGN_CONFIRMATION",
                extraIngredientChance = "TODO_DESIGN_CONFIRMATION",
                rareHerbChance = "TODO_DESIGN_CONFIRMATION",
                gatheringSurvivalBenefit = "TODO_DESIGN_CONFIRMATION",
            },
            milestones = {
                [15] = "TODO_DESIGN_CONFIRMATION",
                [20] = "TODO_DESIGN_CONFIRMATION",
                [25] = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "skill_artisanship",
            displayName = "Artisanship",
            perPointEffects = {
                itemCraftingSpeed = "TODO_DESIGN_CONFIRMATION",
                buildingSpeed = "TODO_DESIGN_CONFIRMATION",
                structureDurability = "TODO_DESIGN_CONFIRMATION",
                repairEffectiveness = "TODO_DESIGN_CONFIRMATION",
                equipmentQuality = "TODO_DESIGN_CONFIRMATION",
            },
            milestones = {
                [15] = "TODO_DESIGN_CONFIRMATION",
                [20] = "TODO_DESIGN_CONFIRMATION",
                [25] = "TODO_DESIGN_CONFIRMATION",
            },
        },
    },
}
