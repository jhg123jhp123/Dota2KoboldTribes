# System Overview

## Project Shape

Kobold Survival is expected to become a large PvPvE survival RPG. The codebase should grow through independent systems that communicate through explicit interfaces and events.

The first technical foundation is the world layer:

- World Definition
- World Builder
- Tile Registry

Everything else should build on top of those pieces later.

## Planned System Groups

### Core

Core systems provide shared infrastructure.

- Runtime context
- Event bus
- Data loading
- Logging
- Debug commands
- Validation helpers

Phase 1 status: interface placeholders only.

### World

World systems describe and query the map.

- Region-based world definition
- World Builder
- Tile Registry
- Spawn point registry
- Debug visualization

Phase 1 status: documented interfaces and example data.

### Player

Player systems will eventually own lifecycle and player state.

- Player join/leave handling
- Character selection
- Respawn
- Tribe assignment
- Player progression

Phase 1 status: future system only.

### Survival

Survival systems will eventually create pressure over time.

- Hunger
- Warmth
- Rest
- Exposure
- Injuries
- Environmental hazards

Phase 1 status: explicitly not implemented.

### Inventory And Crafting

Inventory and crafting will eventually support gathering and progression.

- Item definitions
- Inventory storage
- Stack handling
- Recipes
- Crafting stations
- Tool tiers

Phase 1 status: explicitly not implemented.

### Building

Building systems will eventually use Tile Registry queries to validate placement.

- Placement previews
- Buildable terrain checks
- Collision checks
- Ownership
- Repair
- Destruction

Phase 1 status: explicitly not implemented.

### Wildlife And AI

Wildlife and AI will eventually use biome and spawn rules from world data.

- Passive creatures
- Hostile creatures
- Camps
- Patrols
- Bosses
- Aggression rules

Phase 1 status: explicitly not implemented.

### Combat

Combat will eventually adapt Dota 2 ability and modifier systems to survival RPG needs.

- Weapons
- Abilities
- Damage profiles
- Armor and resistance
- Crowd control
- Death handling

Phase 1 status: explicitly not implemented.

### Tribe And PvP

Tribe systems will eventually define teams, territory, diplomacy, and victory rules.

- Starting locations
- Shared tribe resources
- Territory markers
- Raiding rules
- Victory conditions

Phase 1 status: future system only.

### UI

UI will eventually be implemented with Panorama.

- Survival meters
- Inventory
- Crafting
- Building placement
- Map/region info
- Tribe status
- Debug panels

Phase 1 status: future system only.

## World Data Flow

```text
world_definition.json
    ↓
WorldBuilder.ValidateDefinition()
    ↓
WorldBuilder.BuildRuntimeData()
    ↓
TileRegistry.Initialize()
    ↓
Gameplay systems query TileRegistry
```

## Event Flow

Future systems should publish events after state changes:

```text
World Builder
    publishes: world.generated

Resource System
    listens: world.generated
    publishes: resource.spawned, resource.depleted

Building System
    listens: tile.updated
    publishes: building.placed, building.removed

UI Sync
    listens: selected public events
    mirrors safe data to Panorama
```

## Public Contract Rules

- Systems expose narrow public methods.
- Systems should not expose internal tables directly.
- Query methods should return stable data shapes.
- Mutations should publish events.
- Generated world data should be read-only after build unless a system explicitly owns mutation.

## Phase 2 Candidate Scope

The recommended next milestone is still not full gameplay. It should prove the world layer:

- Load one world definition.
- Validate required fields.
- Build a runtime tile grid from region bounds.
- Query tiles by grid and world position.
- Print debug summaries.
- Add minimal tests or scripted validation outside Dota 2 where possible.
