return {
    schemaVersion = 1,
    defaultMode = "mode_team_elimination",
    modes = {
        {
            id = "mode_team_elimination",
            displayName = "Team Elimination",
            initialTeamCount = 2,
            supportedTeamCountsEventually = { 2, 3, 4 },
            playersPerTeam = {
                min = 1,
                max = 5,
            },
            winCondition = "eliminate_all_opposing_kobolds",
            automaticRespawn = false,
            revivalEnabled = true,
            friendlyFire = false,
            pvpAlwaysOnAfterProtection = true,
            spawnProtection = {
                enabled = true,
                durationSeconds = "TODO_DESIGN_CONFIRMATION",
                endsWhenAttackingEnemy = true,
            },
        },
        {
            id = "mode_fortress",
            displayName = "Fortress",
            implementationStatus = "future_variant",
            objective = "defend_home_fortress",
        },
        { id = "mode_practice", displayName = "Practice", implementationStatus = "future_variant" },
        { id = "mode_cooperative", displayName = "Cooperative", implementationStatus = "future_variant" },
        { id = "mode_free_for_all", displayName = "Free For All", implementationStatus = "future_variant" },
    },
}
