# World Generation

## Purpose

World generation in Kobold Survival should start from authored regions, not hand-authored individual tiles.

Regions describe design intent:

- Biome
- Terrain
- Elevation range
- Resources
- Wildlife
- Ambient effects
- Props
- Roads
- Rivers
- Lakes
- Caves
- Boss arenas
- Tribe starts

The World Builder later converts those regions into runtime tile data and spawn metadata.

## Canonical Runtime Format

Use Lua tables as the canonical runtime format.

Reasons:

- Dota 2 server scripts already run Lua.
- Lua modules can be loaded with `require`.
- Runtime data can preserve comments and local helper tables.
- It avoids adding a JSON parser dependency to early game runtime code.

JSON can still be useful as an optional authoring, export, or external-validation format. If both formats exist, Lua tables are the runtime source of truth unless a later toolchain explicitly changes that.

## Top-Level World Definition

```lua
return {
    schemaVersion = 1,
    id = "kobold_survival_default",
    name = "Kobold Survival Default World",
    grid = {
        tileSize = 128,
        width = 128,
        height = 128,
        origin = {
            x = 0,
            y = 0,
        },
    },
    regions = {},
}
```

## Region Definition

Each region describes a rectangular authored area. Regions may overlap only when the World Builder explicitly supports priority rules.

```lua
{
    id = "northern_forest",
    name = "Northern Forest",
    bounds = {
        x1 = 0,
        y1 = 0,
        x2 = 40,
        y2 = 35,
    },
    priority = 10,
    biome = "forest",
    terrain = "grass",
    elevation = {
        min = 0,
        max = 3,
    },
    treeDensity = 0.75,
    resourceRules = {
        {
            resourceId = "node_ordinary_tree",
            weight = 60,
            clusterSize = {
                min = 2,
                max = 7,
            },
        },
    },
    wildlifeRules = {
        {
            unitId = "animal_sheep",
            spawnTag = "wildlife",
            weight = 30,
            packSize = {
                min = 1,
                max = 3,
            },
        },
    },
    ambient = {
        "birds",
        "fireflies",
    },
    decorativeProps = {
        "fallen_log",
        "mossy_rock",
    },
    roads = {},
    rivers = {},
    lakes = {},
    caves = {},
    bossArenas = {},
    tribeStarts = {},
}
```

## Region Field Notes

- `id`: stable machine-readable identifier.
- `name`: user-facing label for tools and debug output.
- `bounds`: region rectangle in grid coordinates.
- `priority`: conflict resolution hint when regions overlap.
- `biome`: broad ecological category.
- `terrain`: base ground type.
- `elevation`: abstract min/max elevation range.
- `treeDensity`: optional density hint from `0.0` to `1.0`.
- `resourceRules`: weighted resource spawn rules.
- `wildlifeRules`: weighted wildlife spawn rules.
- `ambient`: named ambient effect tags.
- `decorativeProps`: named decoration tags.
- `roads`, `rivers`, `lakes`, `caves`: authored feature descriptors.
- `bossArenas`: authored encounter area descriptors.
- `tribeStarts`: valid team/player starting locations.

## Tile Registry Interface

The Tile Registry is the runtime query surface for generated tile data.

Required interface:

```lua
TileRegistry:GetTile(gridX, gridY)
TileRegistry:GetTileAtPosition(worldPosition)
TileRegistry:GridToWorld(gridX, gridY)
TileRegistry:WorldToGrid(worldPosition)
TileRegistry:GetElevation(gridX, gridY)
TileRegistry:IsWalkable(gridX, gridY)
TileRegistry:IsBuildable(gridX, gridY)
TileRegistry:GetBiome(gridX, gridY)
TileRegistry:GetResources(gridX, gridY)
TileRegistry:GetNearbyTiles(gridX, gridY, radius)
TileRegistry:GetSpawnPoints(filters)
```

Query methods should not mutate world data.

Implementation note: Dota exposes `GridNav` helpers for world/grid conversion and pathability queries, including `GridPosToWorldCenterX`, `GridPosToWorldCenterY`, `WorldToGridPosX`, `WorldToGridPosY`, `IsTraversable`, and `IsBlocked`. The Tile Registry should wrap project-authored world data and consult Dota pathing data where Dota should remain authoritative.

## Tile Data Shape

Future generated tiles should use a stable shape similar to:

```lua
{
    gridX = 12,
    gridY = 18,
    worldX = 1536,
    worldY = 2304,
    biome = "forest",
    terrain = "grass",
    elevation = 2,
    walkable = true,
    buildable = true,
    regionId = "northern_forest",
    resources = { "node_ordinary_tree", "node_berry_bush" },
    spawnTags = { "wildlife" }
}
```

## World Builder Interface

The World Builder transforms authored world data into runtime registries.

Required interface:

```lua
WorldBuilder:LoadDefinition(moduleName)
WorldBuilder:LoadDefinitionTable(definition)
WorldBuilder:ValidateDefinition(definition)
WorldBuilder:BuildRuntimeData(definition)
WorldBuilder:GenerateTerrain(definition)
WorldBuilder:PlaceResources(runtimeData, definition)
WorldBuilder:PlaceDecorations(runtimeData, definition)
WorldBuilder:PlaceWildlifeSpawners(runtimeData, definition)
WorldBuilder:PlaceBossArenas(runtimeData, definition)
WorldBuilder:PlaceTribeStarts(runtimeData, definition)
```

For Phase 1 these are contracts only.

## Validation Rules

Initial validation should eventually check:

- Required top-level fields.
- Unique world ID.
- Positive grid dimensions.
- Valid tile size.
- At least one region.
- Unique region IDs.
- Region bounds inside grid.
- Bounds where `x1 <= x2` and `y1 <= y2`.
- Known biome and terrain values.
- Spawn weights greater than zero.
- No duplicate tribe start IDs.

## Debugging Recommendations

When implementation begins, add debug output before gameplay:

- World summary.
- Region coverage summary.
- Tile count by biome.
- Tile count by terrain.
- Resource spawn summary.
- Wildlife spawn summary.
- Unused or invalid feature warnings.

## Phase 1 Status

This document defines the intended format and interfaces only. Terrain generation, resource placement, wildlife placement, and map mutation are not implemented yet.
