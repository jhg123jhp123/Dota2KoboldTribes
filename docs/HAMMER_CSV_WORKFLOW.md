# Hammer CSV Workflow

This document explains how we can use the Kobold Tribes CSV to make Dota 2 Hammer work easier.

## Direct Answer

Hammer does not appear to support directly importing a gameplay CSV and automatically creating a finished Dota map.

The practical workflow is:

1. Use the CSV as source design data.
2. Convert it into scaled Hammer coordinates, region rectangles, and placement manifests.
3. Use those generated files to guide Tile Editor blockout, prefabs, spawn volumes, trigger volumes, and debug overlays.
4. Later, after we inspect real `.vmap` output from Workshop Tools, generate VMAP fragments or prefabs from the same manifests.

So yes, we can make the CSV do a lot of work for us. We should not expect the editor to magically consume the raw 16,384-row CSV.

## Generated CSV Outputs

The map processor now generates two Hammer-facing CSV files:

- `generated/hammer_marker_manifest.csv`
- `generated/hammer_region_rects.csv`

Run:

```bash
python3 tools/map_csv_processor.py \
  --csv /Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_128x128.csv \
  --legend /Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_legend.csv \
  --metadata /Users/abdurh/Downloads/kobold_tribes_map_dataset/kobold_tribes_map_metadata.json \
  --output-dir generated \
  --target-tile-size-units 128
```

## Scale Used

The original CSV says:

- 128 x 128 grid
- 256 units per tile
- 32,768 x 32,768 source footprint

Valve's fog-of-war documentation says playable space should not exceed:

- 16,384 x 16,384 units

Therefore the production Hammer conversion uses:

- 128 units per design tile
- 16,384 x 16,384 target footprint
- 0.5 scale from raw CSV `world_*` coordinates
- 64-unit Dota gridnav cells
- 2 x 2 gridnav cells per design tile

Use `hammer_x`, `hammer_y`, and `hammer_z_hint` from generated outputs for placement. Do not use raw CSV `world_x` and `world_y` for Hammer placement.

## hammer_region_rects.csv

This is the most useful file for Stage 1 blockout.

It contains grouped region rectangles:

- region id
- zone
- terrain
- elevation level
- walkable/buildable flags
- tile count
- grid bounds
- Hammer bounds
- Hammer center
- suggested Hammer layer

Use it to create:

- world layers or Hammer visgroups
- terrain blockout rectangles
- water masks
- cliff/mountain masses
- forest/dense forest volumes
- swamp zones
- camp clearing candidates
- no-build planning zones

This file has 282 region rows, which is much more practical than 16,384 raw tile rows.

## hammer_marker_manifest.csv

This is a placement guide for authored map features.

It contains:

- marker kind
- suggested Hammer use
- tile id
- grid coordinate
- Hammer coordinate
- source CSV coordinate
- zone
- terrain
- elevation
- walkable/buildable flags
- primary entity type/id
- spawn group
- boss arena
- point of interest
- road
- hazard
- suggested action

Use it for:

- tribe start placement
- boss arena anchors
- cave entrance markers
- point-of-interest markers
- wildlife spawn source markers
- road/trail guide points
- hazard trigger candidates
- resource/tree/forage reference points

Important: this file is not a command to place one entity per row. Many rows are references only.

## What To Feed Into Hammer

### Immediately Useful

Hammer can be driven manually by these generated CSVs:

- Open `hammer_region_rects.csv` beside Hammer.
- Create layers/visgroups matching `suggested_layer`.
- Use Hammer bounds to block out terrain masses.
- Use `hammer_marker_manifest.csv` to place starts, caves, bosses, roads, and POIs.

This is reliable today.

### Semi-Automated Next Step

After the first map exists, create a debug overlay/import pass:

- Generate simple marker prefabs or point entities from `hammer_marker_manifest.csv`.
- Use visible placeholder props or text labels for starts, bosses, caves, and POIs.
- Keep resource/decoration rows as debug-only overlays, not production entities.

This requires inspecting actual `.vmap` text from Workshop Tools so we generate valid Source 2 map data.

### Fully Automated Later Step

Once VMAP schema is confirmed:

- Generate a `kobold_map_markers.vmap` or prefab VMAP containing marker entities.
- Generate region trigger volumes for spawn zones and biome controllers.
- Generate `dota_minimap_boundary` placement.
- Generate placeholder no-build/no-path clip volumes for review.

This is feasible, but we should not hand-author VMAP syntax blindly.

## What The CSV Should Automate

Good automation targets:

- coordinate scaling
- region grouping
- region bounds
- start positions
- boss arena anchors
- cave entrance anchors
- POI anchors
- wildlife spawn-zone anchors
- resource-zone summaries
- decoration-zone summaries
- minimap boundaries
- debug labels
- layer names
- validation reports

Poor automation targets:

- finished terrain beauty
- every tree as `ent_dota_tree`
- every resource node as a live entity
- every decoration as a unique prop
- exact trail geometry
- final cliff/ramp readability
- final fog-of-war blockers
- final no-build/no-path blockers

Those need Tile Editor and manual Hammer review.

## Recommended Editor Workflow

### Pass 1: Region Blockout

Use `hammer_region_rects.csv`.

Create:

- water masses
- mountain/cliff masses
- grass buildable fields
- forest and dense forest bands
- swamp zones
- four start pads

Keep it ugly and fast.

### Pass 2: Marker Placement

Use `hammer_marker_manifest.csv`.

Place:

- tribe start markers
- boss arena placeholders
- cave mouth placeholders
- POI placeholders
- road guide splines
- hazard test volumes

Use obvious temporary props or labels.

### Pass 3: Navigation Check

Use Valve's gridnav constraints:

- Build Physics on.
- Build Grid Nav on.
- Preview gridnav in Hammer.
- Use `dota_gridnav_show` in game.
- Check green path continuity from starts to center.
- Add hero clip, creature clip, skip, or clip materials where needed.

### Pass 4: Runtime Connection

Convert stable Hammer markers into runtime systems:

- spawn controllers
- region controllers
- tribe starts
- boss arena logic
- resource volumes
- wildlife volumes
- quest markers

At this point the CSV becomes seed data, not runtime map truth.

## Why Not Load All 16,384 Rows At Runtime?

The full CSV is too granular for Dota runtime gameplay:

- It is heavier than needed.
- It duplicates Hammer's own navigation/pathing data.
- It encourages one-entity-per-tile thinking.
- It will drift from the final hand-tuned Hammer map.

Runtime should use simplified region data and Hammer-authored anchors.

## Next Tool Milestones

1. Generate a minimap-boundary recommendation file.
2. Generate a `hammer_debug_labels.csv` containing only starts, bosses, caves, POIs, and major region centers.
3. Inspect a real `.vmap` saved by Hammer.
4. Build a safe VMAP marker-prefab generator.
5. Generate a first-pass marker-only VMAP/prefab for import/testing.

The current CSV pipeline already provides the data needed for steps 1 and 2.
