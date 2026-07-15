return {
    schemaVersion = 1,
    lootTables = {
        {
            id = "loot_animal_wolf",
            entries = {
                { item = "ingredient_raw_wolf_meat", count = 1, chance = 100 },
                { item = "ingredient_leather", count = 1, chance = "TODO_DESIGN_CONFIRMATION" },
            },
        },
        {
            id = "loot_animal_dire_wolf",
            entries = {
                { item = "ingredient_raw_wolf_meat", count = 1, chance = 100 },
                { item = "ingredient_leather", count = 1, chance = "TODO_DESIGN_CONFIRMATION_LESS_THAN_WOLF" },
            },
        },
        {
            id = "loot_animal_sheep",
            entries = {
                { item = "ingredient_raw_lamb", count = 1, chance = 100 },
                { item = "ingredient_wool", count = 1, chance = 50 },
            },
        },
        {
            id = "loot_quest_murloc_chieftain",
            entries = {
                { item = "item_weapon_murloc_doomhammer", count = 1, chance = 100 },
            },
        },
        {
            id = "loot_quest_darkness_shrine",
            entries = {
                { item = "item_utility_necromancers_necklace", count = 1, chance = 100 },
            },
        },
        {
            id = "loot_quest_wounded_wizard",
            entries = {
                { item = "item_utility_conjurers_charm", count = 1, chance = 100 },
            },
        },
        {
            id = "loot_boss_raging_arcane_beast",
            entries = "TODO_DESIGN_CONFIRMATION",
        },
    },
}
