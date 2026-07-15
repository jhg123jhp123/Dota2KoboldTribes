return {
    schemaVersion = 1,
    spawnTables = {
        {
            id = "spawn_starting_region_basic_resources",
            purpose = "basic_food_trees_and_stone_near_tribe_starts",
            entries = {
                { id = "node_ordinary_tree", weight = 60 },
                { id = "node_stone_deposit", weight = 20 },
                { id = "node_berry_bush", weight = 10 },
                { id = "animal_sheep", weight = 10 },
            },
        },
        {
            id = "spawn_night_predators",
            purpose = "night_danger",
            entries = {
                { id = "animal_dire_wolf", weight = 100 },
            },
        },
        {
            id = "spawn_central_contested_resources",
            purpose = "higher_rewards_with_pvp_risk",
            entries = {
                { id = "node_elder_tree", weight = 10 },
                { id = "node_gold_deposit", weight = 20 },
                { id = "node_shadowstone_source", weight = 5 },
                { id = "node_radiant_gemstone_source", weight = 5 },
            },
        },
    },
}
