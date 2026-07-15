# Kobold Survival

Kobold Survival is a Dota 2 Custom Game project inspired by the survival gameplay lineage of StarCraft II's Kobold Tribes.

This project is not a direct clone. The goal is to build a modern survival RPG with crafting, exploration, progression, base building, and PvPvE play using Dota 2's engine and tooling.

## Current Phase

Phase 1 has moved from documentation-only foundation into a first playable-addon scaffold.

This repository currently contains:

- Project structure
- Architecture documentation
- System overview documentation
- World generation documentation
- Proposed world-definition format
- Tile Registry interface stubs
- World Builder interface stubs
- Lua-table world and tribe data contracts
- Canonical gameplay, content catalog, assumptions, and vertical-slice plan docs
- Initial Lua data catalogs for future systems
- Data/schema placeholders for future tooling
- Dota addon entrypoint
- Forced kobold hero KV
- Custom unit KV for buildings, resource nodes, wildlife, shrines, and boss placeholders
- Runtime services for teams, shared tribe resources, tribe stash inventory, survival meters, progression, buildings, recipes, revival, weather, fishing, AI, and starter world spawns
- Custom net table declarations for future Panorama UI

## Still Incomplete

- Real map file
- Final combat tuning
- AI behavior trees
- Final custom inventory UI
- Full crafting UI
- Quests
- Saving
- Networking hardening
- Production visuals/models

## Repository Layout

```text
KoboldSurvival/
├── README.md
├── docs/
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

## Design Direction

The game should favor systems that are:

- Data-driven
- Modular
- Easy to extend
- Easy to test
- Well documented
- Suitable for a long-term codebase

## Documentation Map

- `docs/IMPLEMENTATION_PLAN.md`: phase plan, assumptions, and recommended build order.
- `docs/Architecture.md`: architecture principles and module boundaries.
- `docs/SystemOverview.md`: planned systems and how they should communicate.
- `docs/WorldGeneration.md`: world-definition format, Tile Registry, and World Builder contracts.
- `docs/DotaWorkshopScripting.md`: Dota 2 Workshop scripting notes and reference-study queue.
- `docs/research/CustomGameReferences.md`: existing Dota custom-game repositories and lessons to study.
- `docs/GAMEPLAY_SPEC.md`: canonical gameplay direction.
- `docs/CONTENT_CATALOG.md`: stable content IDs.
- `docs/DESIGN_ASSUMPTIONS.md`: unresolved values and TODO confirmations.
- `docs/VERTICAL_SLICE_PLAN.md`: phased first playable milestone plan.
- `docs/RuntimeImplementation.md`: current runtime service implementation.
- `docs/PLAYTESTING.md`: first Workshop Tools smoke-test path.

## Development Notes

The Dota addon folder now has a first runtime scaffold. Expect the first Workshop Tools launch to reveal model, KV, or current-API issues; those logs should drive the next cleanup pass.
