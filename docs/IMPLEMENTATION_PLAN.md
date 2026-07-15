# Kobold Survival Implementation Plan

## Purpose

This repository is the foundation for **Kobold Survival**, a Dota 2 Custom Game inspired by the survival structure of StarCraft II's Kobold Tribes.

Phase 0/1 is documentation, architecture, and canonical data only. No gameplay runtime systems are implemented in this phase.

## Repository Layout

```text
KoboldSurvival/
├── README.md
├── docs/
│   ├── Architecture.md
│   ├── DotaWorkshopScripting.md
│   ├── GAMEPLAY_SPEC.md
│   ├── CONTENT_CATALOG.md
│   ├── DESIGN_ASSUMPTIONS.md
│   ├── VERTICAL_SLICE_PLAN.md
│   ├── SystemOverview.md
│   ├── WorldGeneration.md
│   ├── IMPLEMENTATION_PLAN.md
│   └── research/
├── design/
│   ├── GDD/
│   ├── TDD/
│   └── Concepts/
├── tools/
├── assets/
│   ├── concept_art/
│   ├── ui/
│   └── audio/
├── dota_addon/
│   ├── game/
│   └── content/
├── scripts/
└── prototypes/
```

## Architecture Decisions

- Use a modular system layout instead of large manager classes.
- Keep game data in explicit configuration files where possible.
- Keep runtime systems small, composable, and testable.
- Prefer event-driven communication between systems.
- Keep global state minimal and isolated behind a bootstrap/runtime context.
- Treat Dota 2 Lua scripts as the runtime layer, not the design source of truth.
- Separate world definitions from world generation logic.
- Represent authored world layout with regions, not individual tiles.
- Convert world data into Lua tables for Dota runtime use.
- Design tribe rules for 2, 3, and 4 active tribes from the beginning.
- Use a Tile Registry as the query surface for generated runtime world data.
- Keep future systems such as combat, crafting, buildings, survival, and AI out of Phase 1.

## Assumptions

- The game will target Dota 2 Workshop Tools and server-side Lua.
- Panorama UI will be added later but is not part of this phase.
- World data should be available as Lua tables at runtime.
- JSON can remain an optional authoring, export, or validation format if tooling later benefits from it.
- The world builder will initially generate runtime data from authored regions rather than fully procedural terrain.
- Some StarCraft II Kobold Tribes concepts will be adapted, not copied directly.
- Dota-native assets or original assets should be preferred over direct use of StarCraft II assets.
- Visuals and model selection are intentionally deferred.
- The first supported team-count target is 2 tribes, with architecture required to support 3 and 4 tribes.
- Dota map scale is not yet locked. Phase 2 should test tile sizes against Dota movement, camera, pathing, and build-placement feel.

## Future Systems

- Player lifecycle and character selection
- Survival stats
- Inventory
- Crafting
- Resource harvesting
- Building placement
- Wildlife spawning
- Enemy AI
- Tribe factions
- PvPvE rules
- Boss encounters
- Progression
- Saving and persistence
- Panorama HUD
- Debug tooling
- Automated data validation

## Recommended Implementation Order

1. Repository foundation and documentation.
2. Dota addon bootstrap skeleton.
3. Reference study of real Dota custom games and Lua scripting patterns.
4. Lua-table data loading conventions.
5. Event bus and runtime context.
6. World definition validation.
7. Tile Registry stub with tests or debug commands.
8. World Builder dry-run mode.
9. Debug world visualization.
10. Tribe setup rules for 2-4 tribes.
11. Resource node prototypes.
12. Player spawn and tribe start rules.
13. Harvesting prototype.
14. Inventory prototype.
15. Crafting prototype.
16. Building placement prototype.
17. Wildlife and PvE prototype.
18. PvP rules and victory conditions.
19. UI and player onboarding.

## Phase 1 Deliverables

- Project directory structure.
- Architecture documentation.
- System overview documentation.
- World generation documentation.
- Proposed world-definition format.
- Tile Registry interface design.
- World Builder interface design.
- Placeholder Lua modules for future runtime systems.
- Canonical Lua data catalogs for future systems.
- Dota Workshop scripting notes.
- Existing custom-game reference notes.
- Helper documentation for future tools and assets.

## Phase 1 Non-Goals

- No combat system.
- No AI system.
- No inventory system.
- No crafting system.
- No buildings system.
- No survival mechanics.
- No weather system.
- No quests.
- No saving.
- No networking layer.
- No playable prototype.

## Current Smallest Implemented Phase

The first coherent implementation phase is the canonical data foundation:

- Stable content IDs.
- Lua catalog tables for attributes, survival resources, levels, skills, items, equipment, recipes, buildings, resource nodes, animals, spells, status effects, weather, quests, bosses, loot tables, spawn tables, and game modes.
- Updated tribe and world data aligned to the canonical gameplay specification.

This is intentionally not gameplay. It prepares the next phase, which should load and validate these catalogs at addon startup.
