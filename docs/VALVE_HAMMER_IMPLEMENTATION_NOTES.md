# Valve Hammer Implementation Notes

These notes summarize the Dota 2 Workshop Tools level-design pages extracted from:

- `/Users/abdurh/Downloads/developer.valvesoftware.com.zip`
- `/Users/abdurh/Documents/Codex/2026-07-13/do/work/valve_docs_text`

They are implementation constraints for Kobold Survival's Hammer map work.

## Setup And Compile

- Launch Dota 2 Workshop Tools from Steam, create or select the addon, then launch Hammer from the Asset Browser.
- Hammer depends on Dota 2 running; closing Dota 2 closes the associated tools.
- A new map should be saved under the addon's `content/dota_addons/<addon>/maps` folder as a `.vmap`.
- Add the required base Dota entities by using `basic_entities.vmap` for a simple test map, or inspect/use the team-specific `basic_entities_radiant` and `basic_entities_dire` prefabs when team-specific player starts matter.
- Build with `F9` or `File > Build Map`.
- For first tests, enable load-in-engine, bring-engine-to-front, and minimap creation.
- If launching manually, use `dota_launch_custom_game <addon_name> <map_name>`.
- If the addon does not assign a team yet, join a team from console during early tests.
- Build Physics and Build Grid Nav must be enabled when navigation-relevant map changes have been made.

## Scale And Fog Of War

- Dota's fog-of-war system imposes a practical playable-space maximum of `16384 x 16384` Hammer units.
- The supplied CSV source footprint is `32768 x 32768` at 256 units per CSV tile, so the CSV cannot be used at full source scale if Dota fog of war is enabled.
- Keep the 128 x 128 design grid, but scale it to 128 Hammer units per tile for production blockout.
- Target production footprint: `16384 x 16384` Hammer units.
- The coordinate scale from CSV source units to Hammer target units is `0.5`.
- Use the CSV's 256-unit positions as source references only; generated files now include `hammer_*` coordinates at the 128-unit tile scale.

## Elevation

- Dota gameplay spaces should be mostly flat, with stairs/ramps between discrete elevation levels.
- Traversable elevations should use 128-unit Z increments.
- No traversable ground should be below Z 0.
- Suggested Kobold Survival elevation mapping:
  - Deep water: visual/non-walkable below Z 0 where useful.
  - Shallow traversable water or riverbed: Z 0.
  - Base ground: Z 128.
  - Raised ground: Z 256.
  - Major cliff/mountain combat shelf: Z 384.
  - High mountain silhouette: Z 512 or higher, generally non-walkable.
- Avoid rolling gameplay hills if fog-of-war correctness matters.

## Grid Navigation

- Dota navigation is generated as a top-down 2D plane.
- The grid navigation cell size is `64 x 64` Hammer units.
- At the recommended 128-unit map tile scale, each design tile equals 2 x 2 gridnav cells.
- Walkable surfaces need appropriate walkable material data. Valve's blend materials already support this; custom materials need a `dota.nav.walkable 1` user material attribute.
- Preview navigation in Hammer with the navigation preview button or `Ctrl + Q` from Tile Editor workflows.
- Preview in game with `dota_gridnav_show`.
- Large height deltas and clip meshes can block grid cells.
- Overhangs and under-bridges are not reliable gameplay routes because gridnav is top-down.

## Clip And Blocker Materials

- Dota clip meshes affect the navigation grid square they touch.
- Use skip/clip materials for general path blocking or controlled bridge/ramp walkability.
- Use hero clip where heroes should not move, blink, or teleport.
- Use creature clip where AI-controlled creatures should be blocked but heroes should still be able to use the route.
- Use small 32 x 32 blockers centered in 64-unit grid cells for precise clip placement. Use larger blockers only where broad areas are intentionally blocked.
- Cliffs, dense trees, cave backs, water edges, boss arena boundaries, and no-build chokepoints need explicit gridnav checks.

## Trees And Foliage

- `ent_dota_tree` snaps to the 64-unit navigation grid.
- Avoid placing multiple destructible trees inside the same 64 x 64 grid square.
- The map tree limit is 4,096.
- Tile Editor tree placement enforces valid tree spacing and helps prevent overlaps.
- Decorative non-gameplay foliage should use non-networked clientside props where possible.
- Plants and decorative foliage do not need to be gameplay trees unless they must affect navigation or fog.

## Tile Editor

- Tile Editor can create tile terrain, elevations, ramps, water, paths, trees, plants, props, and blend painting.
- Use paths for readability and route guarantee; paths can adjust height, add ramps, and remove trees.
- Path tiles are not the only way to create navigation, but they are useful for route clarity.
- Water should be managed carefully: visible water at multiple levels has additional rendering cost.
- Water cannot directly touch a tile with a height change greater than one 128-unit step.
- Tile Editor blend painting supports up to four blend layers and can help create visual terrain depth without breaking flat gameplay requirements.

## Minimap

- The minimap is a static top-down image and must be regenerated after geometry changes.
- Compile can auto-create a minimap image if the option is enabled.
- Manual minimap creation uses two `dota_minimap_boundary` entities at opposite map corners, then `dota_minimap_create` in console.
- Generated minimap images go under `materials/overviews`.
- Minimap settings go under `resource/overviews/<map_name>.txt`.

## Lighting

- Dota 2 lighting is dynamic and does not require a lighting compile.
- Use `env_global_light` for global light settings.
- Use `ent_dota_lightinfo` for localized lighting and fog blends.
- Avoid overlapping `ent_dota_lightinfo` inner radii.
- If fog of war becomes black, the camera may be outside the relevant `ent_dota_lightinfo` outer radius.
- Use `env_deferred_light` sparingly for campfires, torches, shrines, and cave mouths.
- Avoid overlapping many deferred point-light radii; use `r_deferred_simple_light 2` to debug overdraw.

## Performance

- Prefer clientside cosmetic props for ambient creatures and non-gameplay decoration.
- Use real server/networked entities only when gameplay state matters.
- Keep destructible tree count below 4,096.
- Do not translate every CSV tree/resource/decoration marker into a unique Hammer entity.
- Tile Editor can produce very dense maps; object, plant, and tree density still needs budget control.
- Runtime spawners should activate by region/proximity rather than constantly thinking across the full map.

## World Layers

- World layers can toggle visual/entity content at runtime.
- World layers cannot change physics or navigation.
- Use world layers for visual state changes, quest reveals, ruins, cave set dressing, and event decorations.
- Do not rely on world layers for opening new pathing unless the pathing was already valid or handled through another supported mechanism.

## Prefabs, Instances, And Triggers

- Use prefabs for reusable external `.vmap` chunks such as cave mouths, resource clusters, shrine structures, ruins, and camp dressing.
- Use instances for repeated local geometry that benefits from live editing and batching.
- The `basic_entities` prefab contains required entities for a minimal custom map.
- Trigger volumes can be created from meshes with trigger materials and tied to entities.
- Trigger meshes are useful for shop-like regions, boss attackable regions, no-ward/no-build-like control volumes, spawn volumes, and quest areas.

## Kobold Survival Decisions

- Production map target: 128 x 128 design grid at 128 Hammer units per tile.
- Buildout cell: 2 x 2 design tiles, or 256 x 256 Hammer units.
- Macro terrain cell: 4 x 4 design tiles, or 512 x 512 Hammer units.
- First Hammer blockout should use Tile Editor or Tile Editor-compatible terrain where possible because it handles Dota constraints well.
- Hand-authored geometry is still appropriate for cave mouths, boss arenas, ruins, bridges, cliffs, and hero landmarks, but it must be gridnav-tested.
