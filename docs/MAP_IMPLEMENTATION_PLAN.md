# Map Implementation Plan

This document converts the supplied Kobold Tribes map blockout dataset into a practical Dota 2 Hammer implementation plan.

The CSV is a design input, not production terrain. The final Hammer map should preserve the authored world structure while collapsing coordinate-level detail into regions, paths, volumes, prop groups, and runtime spawn controllers.

## Inputs Inspected

- `/Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_128x128.csv`
- `/Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_legend.csv`
- `/Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_metadata.json`
- `/Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_README.txt`
- `/Users/abdurh/Development/KoboldSurvival` project structure
- Valve Dota 2 Workshop Tools Level Design reference: `https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design`
- Saved Valve page: `/Users/abdurh/Downloads/Level Design - Valve Developer Community.html`
- Valve documentation zip: `/Users/abdurh/Downloads/developer.valvesoftware.com.zip`

The referenced concept image was not present in the dataset directory. This plan therefore treats the CSV, metadata, legend, and README as the inspected map source. Add the image to the dataset when available so the terrain silhouette, mood, landmark placement, and decorative density can be checked against the visual reference.

The saved Valve level-design page and relevant linked subpages from the zip have been reviewed. See `docs/VALVE_LEVEL_DESIGN_REFERENCE.md` and `docs/VALVE_HAMMER_IMPLEMENTATION_NOTES.md`.

## Generated Outputs

The offline processor is available at:

- `/Users/abdurh/Development/KoboldSurvival/tools/map_csv_processor.py`

Generated outputs are:

- `/Users/abdurh/Development/KoboldSurvival/generated/map_regions.json`
- `/Users/abdurh/Development/KoboldSurvival/generated/resource_spawns.json`
- `/Users/abdurh/Development/KoboldSurvival/generated/wildlife_spawns.json`
- `/Users/abdurh/Development/KoboldSurvival/generated/decorations.json`
- `/Users/abdurh/Development/KoboldSurvival/generated/map_validation_report.md`
- `/Users/abdurh/Development/KoboldSurvival/generated/hammer_marker_manifest.csv`
- `/Users/abdurh/Development/KoboldSurvival/generated/hammer_region_rects.csv`

Run the processor with:

```bash
python3 tools/map_csv_processor.py \
  --csv /Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_128x128.csv \
  --legend /Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_legend.csv \
  --metadata /Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_metadata.json \
  --output-dir generated \
  --target-tile-size-units 128
```

## Validation Result

The CSV contains 16,384 rows and validated with:

- 0 hard errors
- 7 warnings
- 23 walkable components
- 10 buildable components
- 282 grouped map regions above the default 4-tile threshold
- 1,107 resource zones
- 129 wildlife spawn controller zones
- 129 decoration/ambient zones

The warnings are design/Hammer tasks, not blockers:

- Several boss/POI markers are on non-walkable tiles and need nearby landing arenas.
- There is one dominant walkable area plus 22 one-tile walkable pockets, mostly cave markers inside mountains.
- There are 492 steep elevation transitions greater than one level near walkable tiles.

## Recommended Hammer Scale

Use the CSV coordinate system as the source design grid:

- Grid: 128 x 128
- CSV source tile size: 256 units
- CSV source footprint: 32,768 x 32,768 units
- Production Hammer tile size: 128 units
- Production Hammer footprint: 16,384 x 16,384 units
- Coordinate scale from source CSV to Hammer: 0.5
- Dota gridnav cell size: 64 units
- World origin: approximately the center of the grid
- Source coordinate formula from CSV:
  - `world_x = (grid_x - 63.5) * 256`
  - `world_y = (63.5 - grid_y) * 256`
- Production Hammer coordinate formula:
  - `hammer_x = (grid_x - 63.5) * 128`
  - `hammer_y = (63.5 - grid_y) * 128`

Recommended production approach:

- Preserve the 128 x 128 design grid, but scale it to the 16,384 x 16,384 Dota-compatible Hammer footprint.
- Do not make one terrain brush, mesh, entity, or prop per CSV tile.
- Use 128-unit Hammer tiles for generated coordinates.
- Use 256 x 256 Hammer blockout cells for most terrain forms, equal to 2 x 2 design tiles.
- Use 512 x 512 macro cells for mountains, large water bodies, dense forest masses, and distant border terrain.
- Use smaller manual work only at crossings, camp clearings, cave mouths, boss arenas, and chokepoints.

This scale is a correction from the original CSV metadata. Valve's fog-of-war documentation says playable space should not exceed 16,384 x 16,384 units, so the CSV's 32,768-unit source footprint must not be used directly for production.

## Should 128x128 Be Reduced?

Do not reduce the source grid in the data pipeline. Preserve 128x128 as the canonical design coordinate system.

Do reduce the Hammer coordinate scale and build granularity:

- Coordinate scale: 0.5 from source CSV coordinates.
- Terrain sculpting: 2x2 or 4x4 grouped cells.
- Forest placement: biome volumes and foliage clusters.
- Resource placement: spawn zones, not individual CSV resource nodes.
- Wildlife placement: spawn controllers per zone/cell, not every source marker.
- Decorations: prop groups and biome decorators, not one CSV decoration per entity.

If Hammer compile or runtime performance becomes poor after the 16,384-unit scale correction, the first reduction should be decorative density, entity count, lighting overlap, and forest density.

## Tribe Starting Zones

The CSV contains four valid tribe starts:

| start | grid | source world | hammer world | zone | role |
| --- | --- | --- | --- | --- | --- |
| `red_start` | 14,14 | -12672,12672 | -6336,6336 | `frost_north` | northwest start |
| `blue_start` | 113,14 | 12672,12672 | 6336,6336 | `frost_north` | northeast start |
| `yellow_start` | 14,113 | -12672,-12672 | -6336,-6336 | `southern_wilds` | southwest start |
| `green_start` | 113,113 | 12672,-12672 | 6336,-6336 | `southern_wilds` | southeast start |

Recommended modes:

- 2 tribes default: use diagonal starts, preferably `red_start` vs `green_start`, to exercise the full map and avoid a pure east-west or north-south bias.
- 2 tribes alternate: `blue_start` vs `yellow_start`.
- 4 tribes: use all four corner starts.
- 3 tribes: not perfectly solved by the current CSV. Use three corner starts for early tests, but add or tune a dedicated three-tribe layout before calling the mode balanced.

## Major World Regions

Use the CSV zones as the first Hammer region pass:

- `frost_north`: northern water, mountain, forest, and two northern starts.
- `western_highlands`: western cliffs, mountains, caves, and raids through rugged terrain.
- `eastern_highlands`: eastern cliffs, mountains, caves, quarry side, and rugged routes.
- `heartland`: central playable land connecting the side regions.
- `central_basin`: central contested water/shore/forest area.
- `grimroot_marsh`: swamp, shallow water, sunken ruins, herbs, poison bog, and marsh boss pressure.
- `southern_wilds`: southern forests, mountains, water edge, and two southern starts.

## Implementation Stages

### Stage 1

Build only:

- Terrain footprint
- Border water and central water
- Major cliffs and mountains
- Four tribe spawn zones
- Main roads and shallow crossings

Goal: verify scale, camera, pathing, spawn positions, and rough travel time.

### Stage 2

Add:

- Forest masses
- Mining areas
- Camp clearings
- Cave entrances
- Boss arena footprints

Goal: verify camp viability, chokepoints, resource access, and travel pressure.

### Stage 3

Add:

- Resource spawn controllers
- Wildlife spawn controllers
- Quest markers
- Ambient system volumes

Goal: prove the map can support gameplay without relying on one entity per CSV marker.

### Stage 4

Add:

- Decorative prop groups
- Skeletons, ruins, debris, stumps, boulders
- Insects, birds, ravens, fireflies, fish schools
- Fog volumes
- Sound zones
- Lighting passes

Goal: mood and readability after gameplay scale is proven.

## Manual Hammer Tasks

- Use `docs/VALVE_HAMMER_IMPLEMENTATION_NOTES.md` as the official constraint checklist.
- Verify Tile Editor setup, `basic_entities`/team start prefabs, Build Physics, Build Grid Nav, minimap generation, and gridnav preview during the first compile.
- Inspect Valve's example maps: `holdout_example`, `basic`, `dota_pvp`, `dota_pvp_tiled`, and `simple_dota_map_example`.
- Sculpt and paint the main landmass.
- Place water planes and water transitions.
- Build cliffs, ramps, and blocked mountain silhouettes.
- Build the four start zones as readable camp-safe areas.
- Create roads/trails as smooth paths instead of diagonal CSV steps.
- Place bridges, ford crossings, and shallow-water travel points.
- Carve camp clearings into forests.
- Build cave entrances and decide which cave markers are actual doors versus visual-only markers.
- Hand-shape boss arenas so each has a readable approach, combat floor, and retreat route.
- Add no-build volumes near boss arenas, cliffs, cave doors, roads, and major crossings.
- Add path blockers and test GridNav behavior.
- Keep high-value areas visible enough to be contestable but not obviously dominant.

## Automatable Tasks

- CSV validation.
- Region grouping.
- Hammer marker CSV export.
- Hammer region rectangle CSV export.
- Spawn-zone export.
- Decoration-zone export.
- Resource-zone export.
- Debug overlays for Hammer coordinates.
- Draft minimap/material masks.
- Runtime spawn-controller placement from simplified JSON.
- Region-to-Lua conversion for `data/worlds`.
- Consistency checks for walkability, buildability, elevation transitions, and spawner density.

## Performance Risks

- Accidentally building at the CSV's full 32,768 x 32,768 source scale.
- 1,669 tree markers if translated into unique entities.
- 427 forage markers if translated into individual runtime entities.
- 199 animal/boss spawn markers if each receives a thinker.
- 924 decoration markers if translated directly into unique props.
- Large numbers of unique prop models or materials.
- Too many constantly active ambient systems.
- Dense tree collision and path blockers in combat areas.
- Oversized water and fog effects.
- More than one visible water level in the same player view.
- More than 4,096 destructible Dota trees.
- Overlapping deferred point lights around camps, caves, and shrines.
- Boss arenas with expensive particle loops.
- Runtime parsing of the full 16,384-row CSV.

Mitigation:

- Use generated JSON, not the raw CSV, for runtime data.
- Use the generated `hammer_*` coordinates, not raw `world_*` CSV coordinates, for Hammer placement.
- Use spawn controllers and biome volumes.
- Use prop groups and reusable prefabs.
- Use clientside cosmetic props for non-gameplay decoration.
- Keep far-border mountains and water low-detail.
- Activate spawners by nearby players or region state.
- Use net tables sparingly for map debug overlays.

## Contradictions And Follow-Ups

- The dataset folder did not contain the concept image, so visual/image-vs-CSV contradictions cannot be checked yet.
- The CSV contains four starts while the current gameplay target begins with two tribes. This is good for expansion but requires mode-specific start selection.
- Some boss and point-of-interest markers are intentionally on non-walkable tiles. Hammer needs adjacent playable platforms or entrances.
- The road markers are diagonal and often not 4-neighbor connected. Hammer roads should be smooth trails, not literal tile paths.
- Cave markers appear as isolated one-tile walkable pockets in mountains. Decide which become cave entrances, which become mines, and which are decorative.
- The CSV metadata specifies a 32,768-unit footprint, but Dota fog of war requires a 16,384-unit maximum playable footprint. The production map uses 128 units per tile.

## Smallest Test Region

Build the northwest start slice first:

- Grid bounds: x 5-40, y 5-40
- Approximate Hammer bounds: -7488 to -3008 X, 3008 to 7488 Y
- Includes `red_start`, northern water/shore, mountains, forest, grass clearings, early road markers, caves nearby, and basic resource/wildlife conditions.

This is the smallest useful Hammer test because it exercises spawn placement, buildable camp area, cliffs, water edge, roads, forest density, and resource spawning without requiring the whole map.

For the first two-team combat/pathing test, add the mirrored southeast slice around `green_start` and connect both with a temporary straight trail through the center.
