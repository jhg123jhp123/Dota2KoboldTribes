# Map Assumptions

This document records assumptions and unresolved questions from converting the supplied Kobold Tribes map dataset into a Dota 2 Hammer plan.

## Source Assumptions

- The CSV is a preliminary blockout specification, not an import-ready `.vmap`.
- The CSV is allowed to drive coordinates, zones, terrain categories, resources, wildlife, points of interest, and boss arenas.
- The concept image was referenced by the request but was not present in `/Users/abdurh/Downloads/kobold_tribes_map_dataset/`.
- Until the concept image is available, the CSV/metadata/legend are the only inspected map source.
- Valve's Dota 2 Workshop Tools Level Design page was reviewed from the saved browser HTML at `/Users/abdurh/Downloads/Level Design - Valve Developer Community.html`.
- The saved Valve page is a reference hub; its linked subpages were not included in the saved file and should be reviewed when needed.
- The supplied 128x128 grid should be preserved as the canonical design coordinate system.

## Scale Assumptions

- The CSV tile size of 256 units is source data only.
- Production Hammer placement uses 128 units per design tile.
- Hammer construction should group tiles into 256-unit cells for ordinary terrain.
- Larger terrain masses should use 512-unit chunks or hand-shaped terrain, not tile-by-tile geometry.
- The CSV's 32,768 x 32,768 source footprint is too large for Dota fog of war. The production target is 16,384 x 16,384.
- Border regions can be low-detail and partly decorative.

## Gameplay Assumptions

- The map must support 2, 3, and 4 tribe starts eventually.
- The first balanced target is 2 tribes.
- For 2 tribes, diagonal starts are preferred for early full-map tests: `red_start` vs `green_start`.
- For 4 tribes, all four corner starts are used.
- For 3 tribes, the CSV does not yet provide an obviously balanced arrangement.
- Buildable space in the CSV is a suggestion, not a final building permission map.
- Boss arenas, roads, cave mouths, crossings, and key quest areas should receive no-build volumes.
- Deep water is impassable.
- Shallow water is not automatically passable everywhere. Hammer should decide which shallow areas become crossings.
- Mountains and cliffs are mostly non-walkable unless they are an authored pass, cave approach, ramp, or combat space.
- Traversable ground should use 128-unit Z increments and should not be below Z 0.

## Technical Assumptions

- The Dota runtime should not parse the full 16,384-row CSV.
- Runtime systems should use simplified generated data or hand-authored Lua tables.
- Resource and wildlife spawns should be region/volume based.
- Ambient systems should activate by region or proximity.
- Expensive thinkers should be avoided for passive map state.
- Decorative CSV entries are density hints, not direct entity instructions.
- The generated JSON files are editor/build inputs for now, not final runtime contract files.
- Generated Hammer placement should use `hammer_*` coordinates, not raw CSV `world_*` coordinates.

## CSV Observations

- The CSV has zero validation errors.
- There are four tribe starts, not only two.
- There is one dominant walkable landmass and 22 isolated one-tile walkable pockets.
- Many isolated pockets are cave markers in mountain terrain.
- There are 492 steep elevation transitions near walkable tiles.
- Some boss and POI markers are on non-walkable tiles.
- Road markers are often diagonal and should become smooth Hammer trails.
- Water and shore are highly connected, including border water, central basin water, and marsh water.
- The Grimroot marsh has many rare herb/mushroom markers but very little buildable space.
- Southern wilds and highlands carry large amounts of wood.

## Known Contradictions Or Friction

- Request mentions a concept image, but no image file was found in the dataset folder.
- Current gameplay direction emphasizes two tribes, while the CSV contains four corner starts.
- Some boss marker locations are not directly usable as combat floor positions.
- Some POI marker locations are non-walkable and need adjacent playable space.
- Diagonal road markers do not form clean 4-neighbor connected paths.
- Cave markers create isolated pathing islands if interpreted literally.
- Dense decoration, destructible tree count, deferred light overlap, and always-active thinkers are the primary map performance risks after the scale correction.
- World layers can toggle visual/entity state, but not physics or navigation.

## Questions Before Final VMAP Work

- Where is the concept image file, and should it override any CSV placements?
- Which linked Valve subpages should be downloaded next: Getting Started, Compile and Run, Grid Navigation Mesh, Fog of War, Minimap, Lighting, Performance, or Blocking Heroes' Routes?
- Should the default two-tribe matchup be northwest vs southeast, northeast vs southwest, or north pair vs south pair?
- Should three-tribe mode be supported on this exact four-corner layout, or should it receive a separate start layout?
- Which shallow-water areas should be traversable?
- Which cave markers are real entrances versus decorative cave mouths?
- Which boss arenas should be available in the first playable milestone?
- Should central basin water be a major barrier, a risky travel route, or mostly visual?
- How many simultaneous live resource nodes should each region support?
- What is the maximum acceptable travel time from a start to the central contested territory?
- What is the target entity budget for trees, resources, wildlife, props, and ambient systems?

## Decisions To Revisit After First Hammer Test

- Final confirmation of the 16,384 x 16,384 target footprint.
- Tile-to-Hammer scale.
- Start-zone build radius.
- Road and crossing widths.
- Forest density.
- Camp clearing sizes.
- No-build map.
- Resource density.
- Wildlife danger near starts.
- Boss arena dimensions.
- Lighting and fog readability.
