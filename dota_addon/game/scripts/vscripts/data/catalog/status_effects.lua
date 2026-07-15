return {
    schemaVersion = 1,
    statusEffects = {
        {
            id = "status_starved",
            displayName = "Starved",
            source = "survival_hunger_zero",
            recurringHealthDamage = "TODO_DESIGN_CONFIRMATION",
            endsWhen = "hunger_above_zero",
        },
        {
            id = "status_frostbite",
            displayName = "Frostbite",
            source = "survival_warmth_zero",
            recurringHealthDamage = "TODO_DESIGN_CONFIRMATION",
            preventsRunning = true,
            endsWhen = "warmth_above_zero_or_cold_exposure_ends",
        },
        {
            id = "status_stamina_exhausted",
            displayName = "Collapsed",
            source = "survival_stamina_zero",
            stunDurationSeconds = "TODO_DESIGN_CONFIRMATION",
            canDirectlyKill = false,
        },
        {
            id = "status_resting",
            displayName = "Resting",
            source = "item_utility_sleeping_bag_or_shelter",
            playerCanCancelImmediately = true,
        },
        {
            id = "status_spawn_protection",
            displayName = "Spawn Protection",
            source = "game_mode",
            durationSeconds = "TODO_DESIGN_CONFIRMATION",
            endsWhenAttackingEnemy = true,
            restrictedToStartingRegion = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "status_stealthed",
            displayName = "Stealthed",
            source = "recipe_powdered_flask",
            breaksOn = { "attacking", "casting", "taking_damage" },
        },
        {
            id = "status_cold_resistance",
            displayName = "Cold Resistance",
            source = "event_winter_is_coming",
            valuePct = 10,
            duration = "remainder_of_match",
        },
    },
}
