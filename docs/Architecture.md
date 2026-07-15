# Architecture

## Goals

Kobold Survival should be built as a long-lived Dota 2 Custom Game codebase. The architecture should support experimentation early without forcing a rewrite once the project grows.

Primary goals:

- Data-driven behavior.
- Small modules with clear ownership.
- Composition over inheritance.
- Minimal global state.
- Event-driven communication.
- Defensive public interfaces.
- Testable data transforms.
- Clear separation between authored data and runtime state.

## Layered Structure

```text
Authored Data
    ↓
Validation and Loading
    ↓
World Builder
    ↓
Runtime Registries
    ↓
Gameplay Systems
    ↓
UI and Debug Tools
```

### Authored Data

Authored data describes the game without executing it. Examples include world definitions, resource tables, item definitions, recipes, wildlife tables, building definitions, and progression curves.

Phase 1 defines the world format only.

### Validation And Loading

Data should be validated before runtime systems use it. Validation should catch missing fields, invalid enum values, out-of-bounds regions, duplicate IDs, and malformed spawn rules.

Validation can happen outside Dota 2 with tools, and again inside Lua for defensive runtime checks.

### World Builder

The World Builder converts authored world regions into runtime data. It should not own gameplay rules. Its job is to place terrain metadata, resources, decorations, spawn points, caves, roads, rivers, lakes, and encounter markers.

### Runtime Registries

Registries expose query APIs for generated runtime data. The Tile Registry is the first planned registry. It answers questions such as:

- What tile is at this grid coordinate?
- Is this position walkable?
- Is this position buildable?
- What biome is here?
- What resources can spawn nearby?

### Gameplay Systems

Gameplay systems should consume registry data and publish events. They should not parse raw world definitions directly.

Future examples:

- Harvesting system asks the Tile Registry what resources exist.
- Building system asks if a location is buildable.
- Wildlife system asks for spawn points and biome constraints.
- Boss system asks for arena markers.

### UI And Debug Tools

Panorama UI and debug tools should observe state through explicit runtime APIs and events. They should not reach deeply into system internals.

## Module Boundaries

Prefer modules named around responsibility:

- `world/tile_registry.lua`
- `world/world_builder.lua`
- `core/runtime_context.lua`
- `core/event_bus.lua`
- `data/worlds/*.json`

Avoid broad manager names unless they represent a genuine orchestration boundary. Most systems should be small and composable.

## Runtime Context

The runtime context should hold references to shared services:

- Event bus
- Data registry
- Tile Registry
- Debug logger
- Game settings

The context should be passed into systems during initialization. Avoid hidden globals except for the narrow Dota 2 bootstrap entry point.

## Event-Driven Communication

Systems should communicate with named events instead of direct cross-system calls where practical.

Example future event names:

- `world.generated`
- `tile.updated`
- `resource.spawned`
- `resource.depleted`
- `player.spawned`
- `tribe.created`
- `building.placed`

Events should carry small payloads with documented fields.

## Defensive Programming

Public interfaces should:

- Validate required arguments.
- Return `nil` plus an error string when a lookup can fail.
- Avoid mutating caller-owned tables unless clearly documented.
- Keep generated runtime data immutable where possible.
- Log invalid data with enough context to fix it.

## Naming Conventions

Lua modules:

- File names use `snake_case`.
- Module tables use `PascalCase`.
- Public methods use `PascalCase` when mirroring Dota or specified project interfaces.
- Internal helpers use `snake_case`.

Data:

- IDs use `snake_case`.
- Region names use readable title case.
- Enum values use lowercase `snake_case`.

## Dota 2 Constraints

Dota 2 custom games run server-side Lua with Dota-specific APIs. This affects architecture:

- Runtime code must tolerate reloads during development.
- Server state is authoritative.
- Client UI must receive mirrored data through Panorama-safe channels.
- World placement may need map-authored entities, dummy units, or custom spawn logic.
- Some systems that are simple in SC2 triggers may require explicit Lua services in Dota 2.

## Phase 1 Boundary

Phase 1 defines contracts and documentation only. No actual gameplay loop is implemented.
