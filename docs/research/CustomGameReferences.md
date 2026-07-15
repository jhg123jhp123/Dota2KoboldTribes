# Custom Game References

## Purpose

Kobold Survival should be informed by existing Dota custom-game projects before we implement gameplay. This document tracks the references worth studying and the specific lessons we should extract.

## Primary References

### Valve Dota 2 Workshop Tools Scripting Guide

URL: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting`

Use as the canonical conceptual reference for Dota Workshop scripting. Automated fetching may be blocked, so treat this as a manual-browser reference.

Study topics:

- Addon entry points.
- Script folder conventions.
- Precache and activate lifecycle.
- Lua usage in Workshop Tools.

### ModDota Lua Server API

URL: `https://docs.moddota.com/lua_server/`

Use as the practical API lookup reference for server-side Lua classes and functions.

Study topics:

- `CDOTAGameRules`
- `CDOTABaseGameMode`
- `CDOTA_BaseNPC`
- `CDOTA_Ability_Lua`
- `CDOTA_Modifier_Lua`
- `CustomNetTables`
- `CustomGameEventManager`
- `GridNav`

### Barebones

URL: `https://github.com/bmddota/barebones`

Barebones is a starter Dota 2 custom-game kit. It is useful for understanding how a complete addon is organized.

Study topics:

- `addon_game_mode.lua` as entry point.
- `settings.lua` for high-level mode configuration.
- `gamemode.lua` for initialization.
- `events.lua` for Dota event hooks.
- common libraries such as timers, notifications, physics, containers, and selection.

Kobold Survival should learn from the structure, but keep our own modules smaller and domain-focused.

### SpellLibrary

URL: `https://github.com/Pizzalol/SpellLibrary`

SpellLibrary collects remade Dota abilities for the modding community.

Study topics:

- Ability script organization.
- Keeping ability values in `AbilitySpecial` instead of hardcoding them.
- Per-hero or per-domain Lua folders.
- Modifier naming conventions.
- Reuse of default particles and sounds during prototyping.

Kobold Survival should use similar data-driven habits for abilities, tools, resources, and survival effects.

### dota-2-lua-abilities

URL: `https://github.com/Elfansoer/dota-2-lua-abilities`

This repository is a large Dota 2 Lua ability reference.

Study topics:

- Modern `ability_lua` implementations.
- `CDOTA_Ability_Lua` and `CDOTA_Modifier_Lua` patterns.
- Testing an addon with `dota_launch_custom_game`.
- Organizing content, resource, scripts, particles, sounds, and maps in one addon.

### GameTracking-Dota2

URL: `https://github.com/SteamTracking/GameTracking-Dota2`

Use as a reference for stock Dota data and asset names, not as a template for custom-game architecture.

Study topics:

- Unit names.
- Ability names.
- Item names.
- Particle paths.
- Sound event names.
- Current Dota data conventions.

## What We Need To Learn Before Gameplay

- How to bootstrap a Dota custom game cleanly.
- How to configure 2, 3, and 4 custom teams.
- How team selection and starting positions are represented.
- How large custom maps usually handle spawn markers and pathing.
- How to sync server state to Panorama.
- How to organize Lua abilities and modifiers for a large project.
- Which community libraries are still safe to depend on, and which ideas should be reimplemented locally.

## Reference Study Output

Before Phase 2 implementation, produce:

- A proposed Dota addon bootstrap layout.
- A team/tribe configuration contract.
- A data loading convention for Lua tables.
- A scale-test plan for tile size and region bounds.
- A shortlist of reusable community patterns.
- A list of patterns to avoid.
