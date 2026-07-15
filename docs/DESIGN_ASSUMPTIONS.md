# Design Assumptions

This document records uncertain values and implementation assumptions. Any value marked `TODO_DESIGN_CONFIRMATION` may be changed without treating it as a design reversal.

## Source Of Truth

The canonical gameplay specification provided on 2026-07-13 supersedes earlier placeholder docs and data.

Known earlier placeholders replaced or marked for replacement:

- Invented tribe names such as Northfang, Mudclaw, Ashsnout, and Mossback.
- Invented map feature names such as Old North Road, Mooncap Pond, Root Warren, Blackwater Run, and Sunken Idol.
- Invented resources and creatures not listed in the canonical spec, such as bog iron and marsh lurker.

## Team And Tribe Assumptions

- First playable build supports only two tribes.
- Future architecture must support two, three, and four tribes.
- Tribe IDs are `tribe_north`, `tribe_south`, `tribe_east`, and `tribe_west`.
- `tribe_east` and `tribe_west` are future placeholders for custom team configurations.
- Display names are generic until final naming direction is confirmed.

## Match Assumptions

- Target match length is 40 to 60 minutes.
- Primary win condition is opposing tribe elimination.
- No automatic respawn in the default mode.
- Revival may exist in a later mode or system but is not part of the first vertical slice.
- Spawn protection is allowed as a short configurable early-game safety window.

## Scale Assumptions

- `tileSize = 128` is a placeholder.
- Test `64`, `128`, and `256` world-unit tiles in Workshop Tools before locking scale.
- Dota `GridNav` should remain authoritative for pathability checks.

## Prototype Balance Assumptions

- Campfire cost: 1 lumber and 1 stone.
- Tent cost: 1 lumber plus either 1 leather or 1 wool.
- Farm cost: 1 lumber and 1 stone.
- Farm sheep production interval: 22 seconds.
- Farm stops production while four sheep created by that farm remain alive.
- Sheep wool drop chance: 50%.
- Sheep raw lamb drop chance: 100%.
- Ordinary tree drops 1 lumber.
- Elder tree drops 3 lumber and 1 infused lumber.
- Elder tree count should be configured and not hardcoded.

## TODO Design Confirmations

- Exact Dota map scale and tile size.
- Whether the first test map should use custom terrain or plain Hammer test zones.
- Exact equipment stats for most known items.
- Final Mining milestone benefits.
- Final Cooking milestone benefits.
- Final Foraging milestone benefits.
- Final Artisanship milestone benefits.
- Exact effects for Diseased Cocktail.
- Exact effects for Unstable Concoction.
- Exact effects for Drunken Booze.
- Exact Elixir of Mastery reward.
- Exact Tribal Shield targeting.
- Boss loot tables and phase scripts.
- Equipment drop behavior on kobold death.
- Whether resources live as item entities, tribe inventory entries, or both.

## Current Technical Assumption

The smallest coherent first implementation phase is a Lua data catalog, not gameplay runtime. This lets future systems reference stable IDs and configuration tables before mechanics are built.
