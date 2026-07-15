# Map Region Breakdown

This document summarizes the supplied 128x128 CSV blockout in region terms that are useful for Hammer, gameplay design, and later runtime spawn systems.

## Global Summary

| metric | value |
| --- | --- |
| CSV rows | 16,384 |
| Grid size | 128 x 128 |
| Source tile size | 256 units |
| Source footprint | 32,768 x 32,768 units |
| Production Hammer tile size | 128 units |
| Production Hammer footprint | 16,384 x 16,384 units |
| Dota gridnav cell size | 64 units |
| Walkable tiles | 9,846 |
| Buildable tiles | 6,014 |
| Walkable components | 23 |
| Buildable components | 10 |
| Grouped regions, 4+ tiles | 282 |

The dominant walkable component contains 9,824 tiles and spans grid 3,3 to 124,124. The remaining 22 walkable components are one-tile pockets, mostly cave markers embedded in non-walkable mountain/cliff terrain.

## Zone Summary

| zone | grid bounds | tiles | walkable | buildable | gameplay role |
| --- | --- | --- | --- | --- | --- |
| `frost_north` | 0,0 to 127,31 | 4,096 | 1,686 | 1,133 | Northern starts, cold edge, water, mountain caves, frost boss |
| `western_highlands` | 0,32 to 34,96 | 2,194 | 1,407 | 1,111 | Western cliffs, rugged caves, raid routes, wolf boss side |
| `heartland` | 35,32 to 93,96 | 1,298 | 1,049 | 822 | Main cross-map land connector and campable middle land |
| `central_basin` | 40,40 to 88,83 | 1,055 | 901 | 378 | Contested central water, shore, forest, routes, great wyrm edge |
| `grimroot_marsh` | 31,60 to 79,96 | 1,563 | 1,237 | 127 | Swamp, herbs, sunken ruins, poison bog, marsh boss |
| `eastern_highlands` | 94,32 to 127,96 | 2,210 | 1,423 | 1,053 | Eastern cliffs, quarry side, caves, stone giant |
| `southern_wilds` | 0,97 to 127,127 | 3,968 | 2,143 | 1,390 | Southern starts, dense forest, southern mountains, late threats |

## Terrain Counts

| terrain | tiles | Hammer treatment |
| --- | --- | --- |
| `mountain` | 2,815 | Mostly non-walkable silhouette, cave shells, cliff backdrop |
| `forest` | 2,463 | Medium foliage clusters, partially buildable clearings |
| `deep_water` | 2,253 | Impassable water volumes |
| `grass` | 2,151 | Primary walkable and buildable camp space |
| `shallow_water` | 1,890 | Ford/crossing candidates, mostly low-build/no-build |
| `dense_forest` | 1,612 | Dense tree cover, limited visibility, high wood density |
| `cliff` | 1,505 | Height transitions, blockers, ramps only where authored |
| `shore` | 1,000 | Water transition, decoration, crossings |
| `swamp` | 695 | Slower, wet, limited building, herbs/mushrooms |

## Elevation Counts

| elevation | tiles | meaning |
| --- | --- | --- |
| -2 | 2,253 | Deep water |
| -1 | 1,918 | Shallow water or low swamp |
| 0 | 7,520 | Base ground |
| 1 | 1,632 | Raised ground or low cliff |
| 2 | 2,616 | Cliff or mountain |
| 3 | 445 | High mountain |

Hammer should not interpret these as exact Z values. Treat them as construction layers aligned to Valve's 128-unit traversable elevation increments:

- -2: deep water visual/non-walkable below Z 0 where useful
- -1: shallow traversable water, ford, wetland, or riverbed at Z 0
- 0: normal walkable terrain at Z 128
- 1: raised ledges, lower cliff shoulders, and ramps at Z 256
- 2: major cliff or mountain shelf at Z 384
- 3: high mountain silhouette at Z 512 or higher, generally non-walkable

No traversable terrain should be below Z 0.

## Tribe Starts

| start | grid | world | zone | notes |
| --- | --- | --- | --- | --- |
| `red_start` | 14,14 | -12672,12672 | `frost_north` | Northwest camp, good first blockout slice |
| `blue_start` | 113,14 | 12672,12672 | `frost_north` | Northeast camp, mirrors northern pressure |
| `yellow_start` | 14,113 | -12672,-12672 | `southern_wilds` | Southwest camp, south/west access |
| `green_start` | 113,113 | 12672,-12672 | `southern_wilds` | Southeast camp, recommended opponent for `red_start` |

The `world` column above is the original CSV source coordinate. Production Hammer placement uses half-scale coordinates:

| start | hammer world |
| --- | --- |
| `red_start` | -6336,6336 |
| `blue_start` | 6336,6336 |
| `yellow_start` | -6336,-6336 |
| `green_start` | 6336,-6336 |

All four starts are walkable and buildable in the CSV.

## Boss Arenas

| boss arena | marker grid | arena bounds | zone | current issue |
| --- | --- | --- | --- | --- |
| `frostmaw` | 64,12 | 59,7 to 69,17 | `frost_north` | Boss marker is on non-walkable mountain |
| `wolf_lord` | 22,62 | 17,57 to 27,67 | `western_highlands` | Boss marker is on non-walkable mountain |
| `stone_giant` | 106,62 | 101,57 to 111,67 | `eastern_highlands` | Marker is walkable but not buildable |
| `great_wyrm` | 64,64 | 59,59 to 69,69 | `grimroot_marsh` | Boss marker is in deep water |
| `grimroot` | 45,101 | 40,96 to 50,106 | `southern_wilds` | Marker is walkable swamp |
| `ember_queen` | 83,101 | 78,96 to 88,106 | `southern_wilds` | Marker is walkable dense forest |

Hammer should give each boss:

- A combat floor roughly 1,024 to 1,536 units across for the first pass, then tune by boss size.
- One or two readable entrances.
- No-build volume covering the arena.
- Nearby landmark silhouette.
- Optional retreat route that does not trivialize the boss.

## Points Of Interest

| POI | marker grid | region bounds | zone | current issue |
| --- | --- | --- | --- | --- |
| `ancient_ruins` | 48,25 | 45,22 to 51,28 | `frost_north` | Marker is non-walkable mountain |
| `watchtower_ruins` | 89,42 | 86,39 to 92,45 | `heartland` | Walkable, central/eastern overlook |
| `sunken_ruins` | 64,78 | 61,75 to 67,81 | `grimroot_marsh` | Walkable shallow water |
| `abandoned_village` | 35,84 | 32,81 to 38,87 | `grimroot_marsh` | Walkable swamp |
| `old_quarry` | 94,87 | 91,84 to 97,90 | `eastern_highlands` | Marker is non-walkable cliff |

Non-walkable POIs should become visual landmarks with an adjacent playable pad, ramp, cave mouth, or quest trigger.

## Caves And Mining Zones

The CSV contains 19 cave entrance markers, spread through:

- Northern mountains
- Western highlands
- Eastern highlands
- Southern mountains
- Wolf Lord side arena

Most cave markers are isolated walkable one-tile pockets. In Hammer, do not leave these as isolated pathing islands. Choose one of these treatments for each:

- Actual cave entrance with pathing connection and mine/encounter interior.
- Decorative cave mouth with no pathing.
- Hidden/locked entrance that becomes active through a quest or event.

Mining gameplay should concentrate around caves and cliffs, especially the western/eastern highlands and southern mountain bands.

## Water, Rivers, Lakes, And Beaches

The water system is one large connected design network once deep water and shallow water are combined.

Major water features:

- Northern border water across `frost_north`.
- Southern border water across `southern_wilds`.
- Central basin water and shore around grid x 40-88, y 40-83.
- Grimroot marsh water and swamp around grid x 31-79, y 60-96.
- Side water/shore transitions near western and eastern highlands.

Hammer treatment:

- Use deep water as hard impassable boundary or large obstacle.
- Use shallow water as selective crossing, not globally passable unless playtests prove it works.
- Use shore as visual transition and route-reading material.
- Place crossings where roads intersect shallow water/shore.
- Avoid making every shallow-water tile a valid combat route.

## Cliff Levels And Chokepoints

The CSV has 492 elevation transitions greater than one level near walkable tiles. Many are intended hard boundaries, but they must be made readable in Hammer.

Major cliff/mountain masses:

- Northern central mountain wall around grid x 38-90, y 5-33.
- Western vertical mountain/cliff band around grid x 18-36, y 44-122.
- Eastern vertical mountain/cliff band around grid x 92-110, y 21-107.
- Southern mountain arcs around grid x 41-88, y 98-122.

Likely chokepoint families:

- Northwest and northeast trails from the northern starts.
- Western highland passes around the wolf arena.
- Eastern highland passes around quarry/stone giant side.
- Central basin shore crossings.
- Grimroot marsh fords and swamp lanes.
- Southern forest-to-mountain entrances near the two southern starts.

Use ramps, pass widths, tree density, and water crossings to make multiple viable routes. Do not let one central bridge become the only correct raid path.

## Walkable Routes

The CSV has 208 `tribal_trail` markers. They are often diagonal, which means they appear disconnected under 4-neighbor tile analysis. Build them manually as smooth trails.

Route goals:

- Each start needs at least two exits.
- The center should be reachable through several imperfect paths.
- Forest routes should offer stealth/ambush but slower navigation.
- Road routes should offer speed but predictability.
- Water/shore crossings should create risk without hard-locking movement.

## Camp-Building Areas

The 10 buildable components are the best initial camp-area candidates:

| component | grid bounds | tiles | notes |
| --- | --- | --- | --- |
| west/southwest field | 5,45 to 26,122 | 1,296 | Very large west-side buildable band |
| east/northeast field | 102,5 to 122,90 | 1,250 | Very large east-side buildable band |
| inner east/north field | 73,5 to 100,80 | 840 | Strong access to heartland and north |
| northwest field | 5,5 to 26,41 | 761 | First test region, red start |
| central/west forest field | 28,36 to 67,90 | 738 | Powerful central-adjacent camp candidate |
| southeast inner field | 73,84 to 100,122 | 497 | Southern/eastern contested build area |
| southeast outer field | 103,87 to 122,122 | 495 | Green start area |
| southwest connector | 35,94 to 43,122 | 118 | Small south/west expansion pocket |
| northern pocket | 36,27 to 40,33 | 16 | Too small for main base, useful camp/minor POI |
| marsh edge pocket | 34,91 to 34,93 | 3 | Too small for base, decorative or micro objective |

No single camp should dominate. Add no-build restrictions to boss arenas, narrow trail chokepoints, and critical crossings.

## Resource Distribution

Source resource markers:

- Wood: 1,669 markers
- Berries: 186 markers
- Mushrooms: 130 markers
- Herbs: 111 markers

Resource emphasis by region:

- `southern_wilds`: highest wood count and good food spread.
- `eastern_highlands`: strong wood and food, plus cave/mining implications.
- `frost_north`: strong early wood/food but cold and mountain pressure.
- `heartland`: strong wood and central contested access.
- `western_highlands`: moderate wood/food with rugged access.
- `grimroot_marsh`: rare herbs and mushrooms, low buildable area.
- `central_basin`: contested wood/berries with water pressure.

Hammer/runtime treatment:

- Trees should be foliage clusters plus harvestable representatives.
- Berries, mushrooms, and herbs should be spawn volumes with density settings.
- Rare resources should be attached to caves, marsh islands, boss approaches, and remote highland pockets.
- Do not spawn all source markers as live entities at match start.

## Wildlife Spawn Areas

The CSV has 199 spawn markers grouped into 129 controller zones by the processor.

Spawn groups:

- `passive_small`: 75 markers
- `passive_large`: 69 markers
- `hostile_elite`: 30 markers
- `hostile_pack`: 19 markers
- `world_boss`: 3 markers
- `cave_boss`: 2 markers
- `elite_boss`: 1 marker

Design treatment:

- Passive animals should be common near starts and forests but avoid spawn camping.
- Hostile packs should pressure trails, dense forest, and night routes.
- Hostile elites should guard high-value remote areas.
- Boss spawners should be activated by arena logic, not idle global thinkers.

## Decorative Regions

The CSV has 924 decoration markers and 2,331 ambient FX markers. These should become biome-level decoration passes.

Decoration examples:

- `loose_boulders`
- `lily_pads`
- `fallen_log`
- `old_skeleton`
- `tree_stump`
- `mossy_rocks`
- `animal_skeleton`
- `driftwood`
- `wildflowers`
- `fish_bones`
- `dead_tree`
- `reeds`

Ambient examples:

- `ravens`
- `birds`
- `fireflies`
- `fish_school`
- `mosquitoes`
- `shore_flies`
- `grasshoppers`
- `butterflies`
- `frogs`

Use these as region dressing instructions, not literal entity placement.
