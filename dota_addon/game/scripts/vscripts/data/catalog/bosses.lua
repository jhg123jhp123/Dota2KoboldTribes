return {
    schemaVersion = 1,
    sharedBossFields = {
        "scalingHealth",
        "scalingDamage",
        "phaseThresholds",
        "telegraphedAttacks",
        "uniqueLootTable",
        "contributionTracking",
        "teamRewardOwnership",
        "leashOrAntiExploitRules",
    },
    bosses = {
        {
            id = "boss_raging_arcane_beast",
            displayName = "Raging Arcane Beast",
            summonRequirements = {
                { id = "item_utility_necromancers_necklace", count = 1 },
                { id = "item_utility_conjurers_charm", count = 1 },
            },
            manaCostBeforeModifiers = 200,
            ritualSpell = "spell_boss_summon_ritual",
            requiredForFirstSlice = false,
            implementationPriority = "first_boss_after_ordinary_combat_is_stable",
        },
        { id = "boss_demon_lord_jaryx", displayName = "Demon Lord Jaryx", requiredForFirstSlice = false, implementationPriority = "later", design = "TODO_DESIGN_CONFIRMATION" },
        { id = "boss_firebourne", displayName = "Firebourne", requiredForFirstSlice = false, implementationPriority = "later", design = "TODO_DESIGN_CONFIRMATION" },
    },
}
