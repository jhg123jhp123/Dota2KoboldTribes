return {
    schemaVersion = 1,
    spells = {
        {
            id = "spell_affliction",
            displayName = "Affliction",
            role = "ranged_magical_damage_over_time",
            targetProfile = "armoured_targets",
            effects = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "spell_stealth",
            displayName = "Stealth",
            role = "concealment_scouting_initiation_escape",
            breaksOn = { "attacking", "casting", "taking_damage" },
            effects = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "spell_siphon_life",
            displayName = "Siphon Life",
            role = "damage_and_self_heal",
            scalesWith = "spell_power",
            effects = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "spell_shield",
            displayName = "Shield",
            role = "damage_absorption",
            scalesWith = { "spell_power", "attribute_willpower" },
            effects = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "spell_tribal_shield",
            displayName = "Tribal Shield",
            role = "protect_caster_or_nearby_allies",
            targeting = "TODO_DESIGN_CONFIRMATION",
            effects = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "spell_boss_summon_ritual",
            displayName = "Boss Summon Ritual",
            role = "summon_endgame_boss",
            requirements = {
                "item_utility_necromancers_necklace",
                "item_utility_conjurers_charm",
            },
            manaCost = 200,
            channelDurationSeconds = "TODO_DESIGN_CONFIRMATION",
            interruptible = "TODO_DESIGN_CONFIRMATION",
            consumesItems = "TODO_DESIGN_CONFIRMATION",
        },
    },
}
