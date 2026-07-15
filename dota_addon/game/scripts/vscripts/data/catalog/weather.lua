return {
    schemaVersion = 1,
    systems = {
        {
            id = "weather_day_night",
            displayName = "Day and Night",
            required = true,
            features = {
                "world_clock",
                "day_phase",
                "night_phase",
                "lighting_transition",
                "temperature_transition",
                "wildlife_spawn_modifiers",
                "visibility_changes",
                "ui_clock",
            },
            timings = "TODO_DESIGN_CONFIRMATION",
        },
        {
            id = "weather_rain",
            displayName = "Rain",
            requiredForFirstSlice = false,
            effects = {
                warmthDrainsDuringDay = true,
                campfireAffected = "TODO_DESIGN_CONFIRMATION",
                visibilityAndAmbienceChange = true,
            },
        },
        {
            id = "event_winter_is_coming",
            displayName = "Winter Is Coming",
            category = "world_event",
            requiredForFirstSlice = false,
            rarity = "rare",
            effects = {
                "snow_begins",
                "warmth_drains_faster_than_rain",
                "survival_primary_pressure",
            },
            reward = {
                condition = "survive_without_reaching_zero_warmth",
                status = "status_cold_resistance",
                coldResistancePct = 10,
            },
        },
        {
            id = "event_night_of_the_ghouls",
            displayName = "Night of the Ghouls",
            category = "world_event",
            requiredForFirstSlice = false,
            effects = {
                "ghouls_spawn_repeatedly_until_morning",
                "ghouls_attack_kobolds_and_buildings",
                "ghouls_can_drop_equipment",
                "ghouls_award_experience",
            },
        },
    },
}
