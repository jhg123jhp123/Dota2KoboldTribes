return {
    schemaVersion = 1,
    resources = {
        {
            id = "survival_health",
            displayName = "Health",
            zeroBehavior = "death",
            configurable = {
                equipmentDropBehavior = "TODO_DESIGN_CONFIRMATION",
                enemyRewardOnDeath = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "survival_mana",
            displayName = "Mana",
            aliases = { "Energy" },
            zeroBehavior = "cannot_cast_mana_cost_actions",
            configurable = {
                baseMaximum = "TODO_DESIGN_CONFIRMATION",
                baseRegenerationPerSecond = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "survival_hunger",
            displayName = "Hunger",
            drain = {
                mode = "continuous",
                basePerSecond = "TODO_DESIGN_CONFIRMATION",
            },
            zeroBehavior = {
                status = "status_starved",
                recurringHealthDamage = "TODO_DESIGN_CONFIRMATION",
            },
        },
        {
            id = "survival_warmth",
            displayName = "Warmth",
            drain = {
                nightPerSecond = "TODO_DESIGN_CONFIRMATION",
                rainPerSecond = "TODO_DESIGN_CONFIRMATION",
                severeWeatherPerSecond = "TODO_DESIGN_CONFIRMATION",
            },
            zeroBehavior = {
                status = "status_frostbite",
                recurringHealthDamage = "TODO_DESIGN_CONFIRMATION",
                preventsRunning = true,
            },
        },
        {
            id = "survival_stamina",
            displayName = "Stamina",
            drain = {
                mode = "action_based",
                runningPerSecond = "TODO_DESIGN_CONFIRMATION",
                choppingPerAction = "TODO_DESIGN_CONFIRMATION",
                miningPerAction = "TODO_DESIGN_CONFIRMATION",
                attackingPerAction = "TODO_DESIGN_CONFIRMATION",
            },
            recovery = {
                naturalPerSecond = "TODO_DESIGN_CONFIRMATION",
                tentMultiplier = "TODO_DESIGN_CONFIRMATION",
                sleepingBagMultiplier = "TODO_DESIGN_CONFIRMATION",
            },
            zeroBehavior = {
                status = "status_stamina_exhausted",
                canDirectlyKill = false,
            },
        },
    },
}
