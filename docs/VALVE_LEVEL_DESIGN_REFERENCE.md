# Valve Level Design Reference

This document records the official Valve Developer Community level-design references supplied for Kobold Survival map work.

Local source reviewed:

- `/Users/abdurh/Downloads/Level Design - Valve Developer Community.html`
- `/Users/abdurh/Downloads/developer.valvesoftware.com.zip`

Official page:

- `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design`

Saved page revision:

- `https://developer.valvesoftware.com/w/index.php?title=Dota_2_Workshop_Tools/Level_Design&oldid=449863`

## What The Page Is

The saved Valve page is a hub for creating Dota 2 custom maps with Hammer. It does not itself contain deep implementation steps; it organizes the official level-design references that should be checked while building the Hammer blockout.

## Official Reference Groups

### Introduction To Hammer

- Getting Started: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Getting_Started`
- Tile Editor Basics: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Tile_Editor_Basics`
- Compile and Run: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Compile_and_Run`

Use these before the first `kobold_survival_test` compile.

### Hammer Documentation

- Navigation: `https://developer.valvesoftware.com/wiki/Source_2/Docs/Level_Design/Navigation`
- Hammer Overview: `https://developer.valvesoftware.com/wiki/Source_2/Docs/Level_Design/Hammer_Overview`
- Basic Construction: `https://developer.valvesoftware.com/wiki/Source_2/Docs/Level_Design/Basic_Construction`
- Prefabs and Instances: `https://developer.valvesoftware.com/wiki/Source_2/Docs/Level_Design/Prefabs_and_Instances`
- Mesh Entities: `https://developer.valvesoftware.com/wiki/Source_2/Docs/Level_Design/Mesh_Entities`
- Tile Editor: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Tile_Editor`
- New Tilesets: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/New_Tilesets`
- Terrain Blending: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Terrain_Blending`
- World Layers: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/World_Layers`
- Creating A Dota-Style Map: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Creating_A_Dota-Style_Map`

Use these for terrain construction, reusable prefabs, large-map organization, layer discipline, and terrain visual treatment.

### Dota 2 Concepts

- Grid Navigation Mesh: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Navigation_Mesh`
- Fog of War: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Fog_of_War`
- Minimap: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Minimap`
- Common Developer Commands: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Common_Developer_Commands`
- Lighting: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Lighting`
- Performance: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Performance`
- Blocking Heroes' Routes Tutorial: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design/Dota/Blocking_Heroes%27_Routes`

Use these before locking any camp clearings, cliffs, forests, water crossings, minimap output, or route blockers.

### Dota 2 Example Maps

Valve lists these example maps:

- `dota_addons/holdout_example/holdout_example.vmap`
- `dota_addons/holdout_example/basic.vmap`
- `dota_addons/dota_pvp/dota_pvp.vmap`
- `dota_addons/dota_pvp/dota_pvp_tiled.vmap`
- `dota_addons/dota_pvp/simple_dota_map_example.vmap`

Use them as practical references for base map setup, Dota-specific entities, navigation, and compile expectations.

## Implications For Kobold Survival

- Keep the Hammer blockout staged. Do not jump straight from CSV to production terrain.
- Treat Tile Editor and terrain blending as official workflows to evaluate before committing to a hand-sculpted terrain approach.
- Use World Layers for large-map organization from the start.
- Use prefabs/instances for repeated camp structures, cave mouths, ruins, resource clusters, and decoration groups.
- Make Dota Grid Navigation Mesh review part of Stage 1, not a polish pass.
- Make Fog of War, Minimap, Lighting, and Performance separate validation checkpoints.
- Use the Blocking Heroes' Routes tutorial before finalizing cliffs, forests, water, and no-build/no-path zones.
- Inspect Valve example maps inside Workshop Tools before creating the final `kobold_survival_test.vmap` structure.

## Extracted Notes

The linked English subpages were extracted from `developer.valvesoftware.com.zip` into:

- `/Users/abdurh/Documents/Codex/2026-07-13/do/work/valve_docs_text`

Kobold Survival implementation notes are summarized in:

- `docs/VALVE_HAMMER_IMPLEMENTATION_NOTES.md`

Headings extracted from the full offline docs are available in:

- `docs/VALVE_DOC_HEADINGS_INDEX.md`
- `generated/valve_headings/valve_doc_headings_relevant.md`
- `generated/valve_headings/valve_doc_headings_relevant.json`
- `generated/valve_headings/valve_doc_headings_all.json`
