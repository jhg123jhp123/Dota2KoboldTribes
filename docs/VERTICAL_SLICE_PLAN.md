# Vertical Slice Plan

## Goal

Build the smallest playable sequence that proves Kobold Survival's survival loop in Dota 2:

1. Spawn two kobolds in separate test zones.
2. Track Health, Hunger, Warmth, and Stamina.
3. Transition from day to night.
4. Decrease Hunger over time.
5. Decrease Warmth at night.
6. Drain Stamina while running.
7. Collapse when Stamina reaches zero.
8. Fell ordinary trees for Lumber.
9. Mine stone deposits for Stone.
10. Kill Sheep for Raw Lamb and possible Wool.
11. Build Campfire.
12. Use fire for warmth and wolf fear.
13. Cook Raw Lamb into Roasted Lamb.
14. Build Tent.
15. Recover Stamina faster near Tent.
16. Award XP from these activities.
17. Grant five skill points on level up.
18. Spend points in Forestry or Cooking.
19. Apply Forestry to tree harvesting.
20. Apply Cooking to Roasted Lamb and campfire duration.

## Non-Goals

- Advanced AI.
- Full quests.
- Bosses.
- Smithing.
- Procedural terrain.
- Full inventory UI.
- Full building catalog.
- Taming.
- Weather beyond day/night for the first pass.
- 3-4 tribe gameplay in the first pass.

## Phase 0: Data Foundation

Status: implemented as the current smallest coherent phase.

Deliverables:

- Canonical gameplay docs.
- Content catalog.
- Design assumptions.
- Lua data definitions for attributes, survival resources, levels, skills, items, recipes, buildings, resource nodes, animals, spells, statuses, weather, quests, bosses, loot tables, spawn tables, game modes, and world regions.
- No runtime gameplay logic.

## Phase 1: Addon Bootstrap

Deliverables:

- Minimal `addon_game_mode.lua`.
- `Precache(context)` and `Activate()` entry points.
- Runtime context initialization.
- Load data catalogs.
- Print data validation summary in console.
- No player-facing mechanics yet.

Acceptance:

- Addon launches in a blank Dota custom game map.
- Console confirms data catalogs loaded.
- No runtime errors on launch.

## Phase 2: Player And Survival State

Deliverables:

- Spawn one kobold hero per player.
- Initialize survival state table per player.
- Tick Hunger and Warmth.
- Apply `status_starved` and `status_frostbite`.
- Mirror survival state to debug output or minimal UI.

Acceptance:

- Hunger decreases.
- Warmth decreases at night.
- Starvation and frostbite can damage the kobold.

## Phase 3: Movement And Stamina

Deliverables:

- Walk/run mode.
- Stamina drain while running.
- Natural stamina recovery.
- Collapse at zero stamina.
- Tent recovery hook stub.

Acceptance:

- Running is useful but risky.
- Zero stamina creates a temporary stun and cannot directly kill.

## Phase 4: Gathering Prototype

Deliverables:

- Ordinary tree entity.
- Stone deposit entity.
- Sheep entity.
- Lumber, Stone, Raw Lamb, and Wool rewards.
- XP awards for gathering and hunting.

Acceptance:

- Player can gather enough resources for Campfire and Tent.

## Phase 5: Campfire And Cooking

Deliverables:

- Build Campfire.
- Campfire fuel and warmth radius.
- Raw Lamb to Roasted Lamb recipe.
- Cooking skill affects food and fire duration.
- Wolf fear response near active fire.

Acceptance:

- Campfire meaningfully protects against cold and wolves.
- Roasted Lamb restores Health and Hunger.

## Phase 6: Tent And Basic Skills

Deliverables:

- Build Tent.
- Tent stamina recovery modifier.
- Leveling grants skill points.
- Forestry and Cooking point spending.
- Forestry affects tree harvesting.

Acceptance:

- The first-day to first-night survival loop is playable.

## Implementation Rule

Each phase should be playable or verifiable before moving to the next. Values without confirmed balance must live in configuration and be marked in `docs/DESIGN_ASSUMPTIONS.md`.
