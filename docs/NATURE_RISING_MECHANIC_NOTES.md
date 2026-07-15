# Nature Rising Mechanic Notes

These notes translate the supplied KTNR guide into first-pass Dota 2 Custom Game mechanics. They are implementation guidance, not a promise to clone every mechanic exactly.

## Fishing

Fishing is implemented as a tool-driven channel.

- Tool: `item_tool_fishing_rod`
- Runtime system: `services/fishing_service.lua`
- KV file: `scripts/npc/npc_items_custom.txt`
- Item Lua: `vscripts/items/kobold_items.lua`

The Fishing Rod:

- is crafted later through the Hunter's Lodge recipe layer;
- is temporarily granted as a starting test item until that crafting layer exists;
- channels on a point for 5 seconds;
- requires water-like terrain when the Tile Registry has production map data;
- allows fishing during placeholder smoke tests when no water tiles exist yet;
- grants a `+5` endurance approximation through Strength until custom attributes are fully separated;
- halves hunger drain while equipped.

Current catch table:

- `item_fish_striped_lurker`
- `item_fish_blind_rainfish`
- `item_fish_jewel_danio`
- `item_fish_fire_ammonite`
- `item_fish_forest_trout`
- `item_fish_highland_guppy`
- `item_fish_giant_sunfish`
- `item_fish_slippery_eel`
- `item_fish_albino_cavefish`
- `item_fish_water_scorpion`
- `item_fish_toxic_frog`
- `item_fish_tiger_gourami`
- `item_fishing_murloc_treat`
- `item_utility_murlocket`

## Farm

Farm is implemented as a passive production building plus explicit interaction abilities.

- Building: `building_farm`
- Unit: `npc_kobold_building_farm`
- Runtime system: `services/building_service.lua`

Implemented farm behavior:

- costs `1 Lumber + 1 Stone`;
- has `200` health and `1` armor;
- produces sheep over time;
- can be baited with `1 Handful of Berries`;
- bait lasts 120 seconds;
- baited farms attract pheasants at a limited spawn rate;
- domesticated sheep behavior can be purchased for `5 Gold`;
- farm-produced sheep stay closer to the farm after domestication.

## Tavern And Murlocs

The Tavern is now the first murloc access point.

- Building: `building_tavern`
- Unit: `npc_kobold_building_tavern`
- Runtime system: `services/building_service.lua`

Implemented tavern behavior:

- costs `2 Lumber + 2 Stone`;
- hires `npc_kobold_murloc_slave` for `45 Gold`;
- hired murlocs last 300 seconds;
- hired murlocs are player-controllable by the hiring player;
- the Murlocket grants a nearby murloc berserk aura.

## Intentional Placeholders

The following are represented as first-pass approximations and should be revisited after editor testing:

- fishing location-specific pools;
- day-only fish logic for Giant Sunfish;
- Blind Rainfish weather integration;
- Tiger Gourami pet death prevention;
- exact custom attribute mapping for Endurance and spell-duration bonuses;
- murloc harvesting automation;
- Negotiator perk discount and duration bonus;
- fishing quests and circular research zones;
- dedicated models, particles, sounds, and localization.
