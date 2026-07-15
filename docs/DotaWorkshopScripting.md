# Dota Workshop Scripting Notes

## Purpose

This document records how Kobold Survival should approach Dota 2 custom-game scripting before gameplay implementation begins.

The user-provided primary reference is:

- Valve Developer Community: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting`

Automated access to the Valve wiki may be blocked by bot protection, so this page should be treated as a manual canonical reference inside a normal browser. Practical API lookup should also use ModDota's generated Lua server API reference and real open-source custom games.

## Current Direction

- Runtime data should be Lua tables.
- World data remains region-authored, then converted into generated runtime tile data.
- The game should support 2, 3, and 4 active tribes.
- Visuals and model selection are deferred.
- Existing Dota custom games should be studied before implementation so we follow proven Workshop patterns.

## Dota Runtime Concepts To Learn First

### Addon Bootstrap

Study how real projects structure:

- `addon_game_mode.lua`
- `Precache(context)`
- `Activate()`
- Game mode initialization
- Reload-safe global tables

The goal is to keep `addon_game_mode.lua` tiny and delegate to modular systems.

### Game Rules And Game Mode Entity

Study:

- `GameRules`
- `GameRules:GetGameModeEntity()`
- team setup
- pregame/start state hooks
- respawn rules
- custom hero assignment
- victory conditions

For Kobold Survival, team setup must be data-driven enough to configure 2, 3, or 4 tribes.

### Events

Study:

- `ListenToGameEvent`
- event payloads
- player connect/disconnect lifecycle
- hero spawned events
- entity killed events
- round/game state events

Kobold Survival should wrap raw Dota events in a project event bus rather than letting every system listen directly.

### Thinkers And Timers

Study:

- entity context thinkers
- game mode thinkers
- timer libraries used by existing custom games

Survival games need periodic pressure, but Phase 1 should only define how periodic work will be scheduled later.

### Data-Driven Abilities And Lua Abilities

Study:

- `ability_lua`
- `CDOTA_Ability_Lua`
- `CDOTA_Modifier_Lua`
- `LinkLuaModifier`
- `AbilitySpecial`
- KV files under `scripts/npc`

For our project, ability numbers should live in KV or data tables, not buried in Lua.

### Custom UI Communication

Study:

- `CustomNetTables`
- `CustomGameEventManager`
- Panorama event handlers
- server-authoritative state mirrored to clients

No UI is implemented in Phase 1, but the architecture should assume UI sync will exist.

### World And Pathing

Study:

- `GridNav`
- map-authored entity markers
- spawn groups
- trees
- path blockers
- world-space coordinates

The Tile Registry should not pretend Dota pathing does not exist. It should combine authored world data with Dota's own pathing checks.

## Map Scale Research Notes

The exact tile size is not locked.

Current placeholder:

- `tileSize = 128`

Reasoning:

- It is large enough to represent a meaningful world cell rather than a tiny nav sample.
- It is small enough to support localized build/resource queries.
- It aligns with common power-of-two map/grid thinking.

Validation needed:

- Test `64`, `128`, and `256` world-unit tiles in Hammer/Workshop Tools.
- Compare against Dota hero collision, melee range, ranged attack ranges, camera framing, tree radius, and building footprint.
- Use `GridNav` conversion functions to confirm how Dota's navigation grid maps to world positions.
- Pick a gameplay tile size only after testing movement and placement feel in a blank map.

## Reference Repositories To Study

Recommended study order:

1. `bmddota/barebones`: addon structure, bootstrap, settings, common libraries, event hooks.
2. `Pizzalol/SpellLibrary`: Lua/KV ability organization and data-driven `AbilitySpecial` habits.
3. `Elfansoer/dota-2-lua-abilities`: modern ability implementations and addon testing workflow.
4. `SteamTracking/GameTracking-Dota2`: Valve game data reference for stock units, abilities, items, and assets.
5. ModDota API docs: quick lookup for server-side classes and methods.

## Phase 1 Boundary

This document is for study and architecture only. It does not authorize implementing combat, AI, crafting, buildings, survival mechanics, weather, quests, saving, or networking.
