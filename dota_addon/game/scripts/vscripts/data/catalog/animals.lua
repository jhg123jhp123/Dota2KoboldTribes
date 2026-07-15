return {
    schemaVersion = 1,
    baseStateMachine = {
        "idle",
        "wander",
        "flee",
        "retaliate",
        "pursue",
        "return_or_despawn",
        "fear_fire",
    },
    animals = {
        {
            id = "animal_wolf",
            displayName = "Wolf",
            temperament = "neutral_until_provoked",
            afraidOfFire = true,
            drops = {
                { id = "ingredient_raw_wolf_meat", count = 1, chance = 100 },
                { id = "ingredient_leather", count = 1, chance = "TODO_DESIGN_CONFIRMATION" },
            },
        },
        {
            id = "animal_dire_wolf",
            displayName = "Dire Wolf",
            temperament = "aggressive_on_sight",
            spawnTiming = "night",
            strongerThan = "animal_wolf",
            fasterThan = "animal_wolf",
            afraidOfFire = true,
            drops = {
                { id = "ingredient_raw_wolf_meat", count = 1, chance = 100 },
                { id = "ingredient_leather", count = 1, chance = "less_than_animal_wolf" },
            },
        },
        { id = "animal_bear", displayName = "Bear", temperament = "dangerous", drops = { { id = "ingredient_raw_bear_meat", count = "TODO_DESIGN_CONFIRMATION", chance = 100 } }, earlySoloTarget = false },
        { id = "animal_polar_bear", displayName = "White Bear", temperament = "dangerous", strongerThan = "animal_bear", drops = { { id = "ingredient_raw_bear_meat", count = "TODO_DESIGN_CONFIRMATION", chance = 100 } } },
        { id = "animal_pheasant", displayName = "Blue Junglefowl", temperament = "passive_or_skittish", drops = { { id = "ingredient_raw_pheasant", count = 1, chance = 100 } }, mayBeAttractedBy = "farm_bait" },
        { id = "animal_sheep", displayName = "Sheep", temperament = "passive", drops = { { id = "ingredient_raw_lamb", count = 1, chance = 100 }, { id = "ingredient_wool", count = 1, chance = 50 } }, source = { "natural", "building_farm" } },
        { id = "animal_stag", displayName = "Stag", temperament = "fast_and_skittish", drops = { { id = "ingredient_raw_stag_meat", count = 1, chance = 100 } }, supportsLateCooking = true },
    },
}
