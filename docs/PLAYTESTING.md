# Playtesting Guide

This document tracks the current local smoke-test path for the Dota 2 addon scaffold.

## Current State

The addon now has a playable runtime scaffold:

- `addon_game_mode.lua` entrypoint.
- Forced `npc_dota_hero_kobold_survivor` hero.
- Custom ability and item KV.
- Custom building, resource node, wildlife, shrine, and boss unit KV.
- Service layer for teams, resources, progression, survival, buildings, recipes, tribe stash inventory, revival, weather, fishing, AI, and world spawns.
- Custom net tables for future Panorama UI.

This is not a polished game yet. It is the first Workshop-loadable slice intended to expose Dota-specific errors quickly.

## Expected First Test

1. Open Dota 2 Workshop Tools.
2. Create or copy a test map named `kobold_survival_test`.
3. Ensure the addon game folder is visible as the active custom game.
4. Launch the map with one or more players/bots.
5. Confirm the game forces `npc_dota_hero_kobold_survivor`.
6. Confirm the hero receives starter abilities and starter items.
7. Try:
   - Gather a spawned resource node.
   - Build a campfire.
   - Build a tent.
   - Use the run toggle and watch stamina behavior.
   - Eat `item_food_roasted_lamb`.
   - Use `kobold_spawn_ai wolf`, `kobold_spawn_ai bear`, and `kobold_spawn_ai boss`.
   - Use `kobold_grant resource_lumber 5` from the console with cheats enabled.
   - Use the Fishing Rod on water or placeholder terrain.
   - Build a farm, bait it with berries, and wait for pheasants.
   - Build or stand near a revival shrine and test `ability_kobold_revive_ally`.
   - Deposit and withdraw an item through the tribe stash actions.

## Console Commands

- `kobold_grant <resource_id> <amount>`: gives a resource to the caller's tribe.
- `kobold_dump`: prints the caller's tribe resource table.
- `kobold_spawn_ai <kind>`: spawns a test AI unit near the caller. Kinds: `sheep`, `pheasant`, `stag`, `wolf`, `dire_wolf`, `bear`, `murloc`, `boss`.
- `kobold_item <item_name> <count>`: creates test items.
- `kobold_recipe <recipe_id>`: completes a recipe if the tribe can pay.
- `kobold_stash_put <slot>`: deposits an inventory slot into the tribe stash.
- `kobold_stash_take <item_name> <count>`: withdraws items from the tribe stash.
- `kobold_weather <clear|rain|winter|ghouls|darkness> <seconds>`: forces a weather/event state.
- `kobold_xp <amount>`: grants custom XP.
- `kobold_revive`: revives the nearest dead ally through a nearby shrine.

## Known Rough Edges

- The map file itself is not created yet.
- Many model paths are temporary Dota stock assets and may need replacement if Workshop Tools reports missing models.
- The first spawn pass uses generated world coordinates. A real Hammer map should add spawn anchors later.
- Building placement is point-based and does not yet validate collisions, pathing, footprint size, or no-build zones.
- Inventory has a runtime tribe stash and debug/ability access, but no Panorama UI yet.
- Revival shrine behavior is implemented as a first-pass nearest-dead-ally channel, but needs UX and balance testing.
- Weather has runtime survival/campfire effects, but no visual particles, sound zones, or map ambience yet.
- Wildlife and boss AI are first-pass state machines, not final encounter scripting.
- UI is CustomNetTables-ready but Panorama panels are not created yet.
- Lua syntax was not validated locally because no Lua interpreter/compiler is installed on this machine.

## First Issues To Fix From Editor Logs

1. Missing or invalid model paths.
2. Invalid KV constants.
3. Ability behavior flags that Dota rejects.
4. Hero force-pick timing.
5. Spawn positions outside the playable test map.
6. Lua API calls that differ from current Workshop behavior.
