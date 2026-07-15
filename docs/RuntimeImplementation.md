# Runtime Implementation

This document summarizes the first gameplay scaffold.

## Entry Points

- `dota_addon/game/scripts/vscripts/addon_game_mode.lua`
  - Provides Dota's `Precache` and `Activate` hooks.
- `dota_addon/game/scripts/vscripts/kobold_survival.lua`
  - Owns game-rule setup, service creation, event listeners, hero initialization, world spawning, and win checks.

## Services

- `TeamService`
  - Enables the first two tribes and maps tribe IDs to Dota teams.
- `ResourceService`
  - Stores shared tribal resources by team.
  - Publishes `kobold_resources`.
- `ProgressionService`
  - Tracks XP, custom level, skill points, and skill ranks.
  - Publishes `kobold_progression`.
- `SurvivalService`
  - Tracks hunger, warmth, and stamina per hero.
  - Applies early starvation, frostbite, and stamina exhaustion behavior.
  - Publishes `kobold_survival`.
- `BuildingService`
  - Reserves resources at channel start.
  - Refunds on interruption.
  - Spawns completed building units.
  - Tracks campfire fuel.
  - Produces farm sheep, handles berry bait for pheasants, supports domesticated farm sheep, and hires temporary murloc slaves from taverns.
  - Publishes `kobold_world`.
- `FishingService`
  - Validates fishing target points against water-like terrain where map data exists.
  - Rolls fish and rare fishing rewards from a weighted table.
  - Creates fish items directly in the caster inventory and publishes fishing catch totals in `kobold_world`.
- `RecipeService`
  - Implements cooking, alchemy, and Fishing Rod recipe completion.
  - Produces multiple item copies for charge-like consumables.
- `InventoryService`
  - Provides a shared tribe stash keyed by item name.
  - Supports deposit/withdraw through abilities and debug commands.
  - Publishes `kobold_inventory`.
- `RevivalService`
  - Tracks dead kobolds by team.
  - Revives the nearest dead allied kobold through a shrine after a 10-second channel.
  - Uses KTNR-inspired material tiers based on the dead kobold's level.
  - Publishes `kobold_deaths`.
- `WeatherService`
  - Tracks clear, rain, winter, ghoul-night, and darkness states.
  - Modifies warmth drain and campfire fuel burn.
  - Publishes `kobold_weather`.
- `SpawnService`
  - Spawns starter resources, central resources, wildlife, and revival shrine placeholders.
- `AIService`
  - Registers spawned wildlife and bosses.
  - Runs simple state machines for prey, predators, territorial animals, and the first boss.
  - Grants first-pass loot and XP on wildlife/boss death.

## Ability Integration

Existing ability and item Lua now uses `KoboldAbilityHelpers` as the bridge into runtime services. This keeps individual ability scripts small while letting systems evolve behind stable helper methods.

Implemented behavior includes:

- Run toggle affects movement speed and drains stamina through `SurvivalService`.
- Food restores health, mana, hunger, warmth, and stamina where KV values exist.
- Fish restore KTNR-inspired survival values and apply first-pass buffs where they map cleanly to Dota modifiers.
- Fishing Rod channels on target water, catches fish on successful channel, gives a lightweight endurance approximation, and halves hunger drain while equipped.
- Build abilities reserve, refund, and complete through `BuildingService`.
- Farm actions can bait pheasants with berries and purchase domesticated sheep behavior with gold.
- Taverns can hire temporary murloc slaves, and the Murlocket grants a nearby murloc berserk aura.
- Contextual gathering grants tribal resources and depletes spawned resource nodes.
- Cooking creates a food item when the tribe has recipe ingredients.
- Alchemy items now have first-pass clickable effects: smoke/cloak, cleanse, poison, burst, booze buff, and mastery XP.
- Tribe stash actions allow Dota inventory overflow to move into shared team storage.
- Revival shrine action channels on a shrine and consumes level-scaled materials to revive an ally.
- Blind Rainfish triggers rain through `WeatherService`.
- Refuel campfire spends lumber and extends campfire fuel.
- Skill spend buttons call `ProgressionService`.
- The boss ritual spawns `npc_kobold_boss_raging_arcane_beast`.

## AI Implementation

Current AI profiles:

- Sheep and stag:
  - Wander near home.
  - Flee from kobolds, predators, and boss units.
- Pheasants:
  - Spawn from baited farms.
  - Use passive prey movement and drop raw pheasant.
- Wolves:
  - Mild day aggression.
  - Larger night acquisition radius.
  - Flee from active campfire fear aura.
- Dire wolves:
  - More aggressive, especially at night.
  - Higher leash and pursuit range.
- Bears:
  - Territorial behavior around home.
  - Heavy melee pulse when close to a target.
- Raging Arcane Beast:
  - Acquires nearby kobolds.
  - Uses arcane projectile, burst, and field abilities when castable.

This is intentionally not a full behavior-tree framework yet. It is a compact state-machine service that can be replaced or expanded once the map and combat pacing are proven.

## Net Tables

Declared in `scripts/custom_net_tables.txt`:

- `kobold_survival`
- `kobold_resources`
- `kobold_progression`
- `kobold_tribes`
- `kobold_world`
- `kobold_inventory`
- `kobold_deaths`
- `kobold_weather`

These are intended for the first Panorama HUD.

## Design Constraints Preserved

- Tribe resources are shared by team.
- The default mode is competitive tribal survival.
- The first implementation supports two active tribes, while data contracts still support two, three, and four.
- Systems stay modular and service-oriented rather than one giant manager class.
