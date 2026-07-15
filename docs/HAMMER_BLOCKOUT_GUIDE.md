# Hammer Blockout Guide

This guide describes how to turn the supplied map dataset into an editable Dota 2 Hammer blockout without overbuilding the map too early.

## Working Coordinate System

Keep the CSV grid as the shared reference:

- `grid_x`: 0 to 127, west to east
- `grid_y`: 0 to 127, north to south
- CSV source tile size: 256 units
- CSV source footprint: 32,768 x 32,768 units
- Hammer target tile size: 128 units
- Hammer target footprint: 16,384 x 16,384 units
- Dota gridnav cell size: 64 units

Source coordinate conversion:

```text
world_x = (grid_x - 63.5) * 256
world_y = (63.5 - grid_y) * 256
```

Hammer coordinate conversion:

```text
hammer_x = (grid_x - 63.5) * 128
hammer_y = (63.5 - grid_y) * 128
```

Hammer examples:

| grid | hammer world |
| --- | --- |
| 0,0 | -8128,8128 |
| 64,64 | 64,-64 |
| 127,127 | 8128,-8128 |
| 14,14 | -6336,6336 |
| 113,113 | 6336,-6336 |

Use the CSV's 256-unit grid only as source reference. Use 128-unit design tiles in Hammer, 256-unit blockout cells for most construction, and 512-unit chunks for large natural masses.

## File Setup

Create a test map named:

```text
kobold_survival_test
```

This name is already referenced by:

```text
/Users/abdurh/Development/KoboldSurvival/dota_addon/game/addoninfo.txt
```

Before production work, open Valve's Dota 2 Workshop Tools Level Design reference in a normal browser:

```text
https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Level_Design
```

The saved page and linked subpages from `/Users/abdurh/Downloads/developer.valvesoftware.com.zip` were reviewed. Use [VALVE_LEVEL_DESIGN_REFERENCE.md](/Users/abdurh/Development/KoboldSurvival/docs/VALVE_LEVEL_DESIGN_REFERENCE.md) and [VALVE_HAMMER_IMPLEMENTATION_NOTES.md](/Users/abdurh/Development/KoboldSurvival/docs/VALVE_HAMMER_IMPLEMENTATION_NOTES.md) as the local reference.

Before the first serious blockout compile, check:

- Getting Started
- Compile and Run
- Grid Navigation Mesh
- Blocking Heroes' Routes
- Performance

Before the first public-facing map pass, check:

- Fog of War
- Minimap
- Lighting
- Terrain Blending
- World Layers

Recommended early Hammer layers or visgroups:

- `terrain_base`
- `water`
- `cliffs_mountains`
- `roads_crossings`
- `tribe_starts`
- `camp_clearings`
- `caves_mines`
- `boss_arenas`
- `resource_zones`
- `wildlife_zones`
- `quest_markers`
- `decorations`
- `debug_grid`

## Stage 1: Footprint, Water, Cliffs, Starts, Roads

Build only the parts needed to test scale and movement.

### Terrain Footprint

- Block out the full 16,384 x 16,384 Hammer target square.
- Keep playable land mostly inside grid 3,3 to 124,124.
- Use low-detail border terrain for far edges.
- Do not create detailed terrain for every CSV tile.

### Water

- Add northern and southern border water.
- Add central basin water.
- Add Grimroot marsh water.
- Add shore material/transition zones.
- Make deep water impassable.
- Make shallow water selectively passable only at intended fords/crossings.

### Major Cliffs And Mountains

Block these first:

- Northern central mountain wall: roughly x 38-90, y 5-33.
- Western highland wall: roughly x 18-36, y 44-122.
- Eastern highland wall: roughly x 92-110, y 21-107.
- Southern mountain arcs: roughly x 41-88, y 98-122.

Treat elevation levels as construction hints:

- -2: deep water visual/non-walkable, allowed below Z 0 when not traversable
- -1: shallow traversable water or riverbed at Z 0
- 0: base ground at Z 128
- 1: raised ledge or low cliff at Z 256
- 2: major cliff/mountain shelf at Z 384
- 3: high mountain silhouette at Z 512 or higher, generally non-walkable

Traversable surfaces should use 128-unit Z increments and should not be below Z 0.

### Tribe Starts

Place four readable start pads:

- `red_start`: grid 14,14
- `blue_start`: grid 113,14
- `yellow_start`: grid 14,113
- `green_start`: grid 113,113

Each start needs:

- 1,500 to 2,500 Hammer units of practical early camp space.
- At least two exits.
- Nearby basic resources.
- No immediate hostile spawn directly on top of the camp.
- Clear silhouette and color/team debugging marker.

### Roads And Crossings

Do not place roads by individual CSV road cells. The road markers are often diagonal and should be converted into smooth trails.

Build:

- Start-to-heartland trails.
- Side highland trails.
- Central basin shore paths.
- Marsh fords.
- Southern forest trails.

Add debug pathing markers at crossings so early playtests can discuss exact chokepoints.

## Stage 2: Forests, Mining, Clearings, Caves, Boss Arenas

### Forests

Use biome volumes and foliage clusters:

- `forest`: medium tree density, readable movement lanes.
- `dense_forest`: dense cover, slower readability, stronger wood identity.
- `grass`: keep open enough for building.
- `swamp`: use dead trees, reeds, wet materials, lower buildability.

Avoid filling every tree marker. Use representative harvestable trees plus non-interactive foliage clusters.

### Mining Areas

Use cave and cliff regions as mining identity:

- Western highlands.
- Eastern highlands.
- Northern mountains.
- Southern mountain arcs.

Place mining zones as volumes or clustered nodes near cave mouths and quarry-like ledges.

### Camp Clearings

Use the buildable components from `generated/map_regions.json` as candidates, then manually shape them.

Rules:

- Open enough for multiple small buildings.
- Not so large that one base can control too many routes.
- Avoid placing perfect base pads beside boss arenas.
- Add no-build blockers on roads, crossings, ramps, caves, and arena floors.

### Caves

For each cave marker, choose one treatment:

- Real cave entrance.
- Mine entrance.
- Decorative cave mouth.
- Quest-locked entrance.

The CSV currently treats many caves as isolated one-tile walkable pockets. Hammer must connect or block these intentionally.

### Boss Arenas

Block out all six arenas, but only detail one or two during early tests:

- `frostmaw`
- `wolf_lord`
- `stone_giant`
- `great_wyrm`
- `grimroot`
- `ember_queen`

Each arena needs:

- Combat floor.
- Entry/exit readability.
- No-build volume.
- Nearby but not overlapping resource temptation.
- Space for boss movement and player retreat.

## Stage 3: Resources, Wildlife, Quests, Ambient Systems

### Resource Entities

Use `/Users/abdurh/Development/KoboldSurvival/generated/resource_spawns.json`.

Placement rule:

- Resource zone becomes one spawn controller or small group.
- Controller decides live node count.
- Controller respawns inside a bounded area.
- Do not place all 2,096 source resource markers as live entities.

### Wildlife Spawners

Use `/Users/abdurh/Development/KoboldSurvival/generated/wildlife_spawns.json`.

Placement rule:

- One spawn controller per generated spawn zone.
- Passive wildlife near food/forest regions.
- Hostile packs on risky trails and night routes.
- Elites in remote or high-value regions.
- Bosses activated by arena state.

Avoid per-spawner thinkers until a player is nearby.

### Quest Markers

Use POI markers as quest anchors:

- `ancient_ruins`
- `watchtower_ruins`
- `sunken_ruins`
- `abandoned_village`
- `old_quarry`

Quest markers should be placed on or near playable ground, even when the CSV marker itself is non-walkable.

### Ambient Systems

Use ambient volumes, not point spam:

- Birds in ordinary forests.
- Ravens near dead/skeleton regions.
- Fireflies in central basin and forest clearings.
- Mosquitoes/frogs in Grimroot marsh.
- Fish schools in water volumes.
- Shore flies near beaches.

## Stage 4: Decorations, Mood, Lighting, Audio

Use `/Users/abdurh/Development/KoboldSurvival/generated/decorations.json`.

Decoration placement should use:

- Prop groups.
- Foliage clusters.
- Reusable prefabs.
- Biome decorators.
- Low-density manual hero props around important landmarks.

Do not place one Hammer entity for every decoration CSV entry.

Priority visual passes:

- Start-zone readability.
- Central contested territory.
- Marsh mood.
- Cave silhouettes.
- Boss-arena silhouettes.
- Road/crossing readability.
- Remote high-value areas.

## Pathing Pass

After Stage 1 and again after Stage 2:

1. Compile the map.
2. Spawn a hero at each start.
3. Walk from each start to center.
4. Walk from each start to both neighboring starts.
5. Test all shallow crossings.
6. Test cave approaches.
7. Test boss arena entrances.
8. Add blockers where cliffs, trees, and water leak pathing.
9. Remove blockers where routes are too narrow or confusing.

## First Playable Slice

Build the northwest start slice first:

- Grid x 5-40
- Grid y 5-40
- Approximate Hammer x -7488 to -3008
- Approximate Hammer y 3008 to 7488

Include:

- `red_start`
- Nearby water/shore
- Nearby mountain wall
- Forest and grass camp area
- First road/trail section
- At least one cave mouth, even if decorative
- A few resource and wildlife test controllers

Then mirror or rough in the southeast `green_start` slice and connect both with a temporary simple trail for two-team testing.

## Editor Test Checklist

Use this checklist after each stage:

- Map loads with `kobold_survival_test`.
- Hero spawns at intended start.
- Camera framing feels acceptable.
- Main walkable areas are connected.
- Start zones have enough build space.
- No-build areas prevent obvious abuse.
- Cliffs visually match pathing.
- Shallow-water crossings are readable.
- No single base location controls too many resources/routes.
- Spawn controllers are zone-based.
- Decorative props do not block important combat lanes unless intended.
- Compile/runtime performance remains stable.
