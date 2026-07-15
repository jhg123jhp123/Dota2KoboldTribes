# Maximum Implementation Pass

This pass adds high-value runtime systems intended to make the first Dota 2 Workshop Tools session more productive.

## Added Systems

- `InventoryService`
  - Shared tribe stash by Dota team.
  - Deposit first stashable item.
  - Deposit a specific item slot through debug command.
  - Withdraw items by item name.
  - Publishes `kobold_inventory`.

- `RevivalService`
  - Tracks dead heroes by team.
  - Supports 10-second shrine channel revival.
  - Uses guide-derived material tiers:
    - Levels 1-4: `1 Stone + 1 Wool + 1 Spicy Herb`
    - Levels 5-7: `1 Iron + 1 Radiant Gemstone + 1 Sageberry`
    - Levels 8+: `1 Radiant Gemstone + 1 Shadowstone + 1 Lambent Sunflower`
  - Publishes `kobold_deaths`.

- `WeatherService`
  - Supports `clear`, `rain`, `winter`, `ghouls`, and `darkness`.
  - Weather affects warmth loss and campfire fuel burn.
  - Blind Rainfish now triggers rain.
  - Publishes `kobold_weather`.

## Expanded Gameplay

- Cooking recipes now cover all currently defined food items.
- Alchemy recipes produce active consumables.
- Fishing Rod recipe exists as `recipe_fishing_rod`.
- Alchemy items have first-pass effects:
  - Powdered Flask: enemy slow/vision penalty, ally cloak/speed.
  - Cleansing Draught: purge and mana regeneration.
  - Diseased Cocktail: poison and healing reduction.
  - Unstable Concoction: area burst and brief stamina collapse.
  - Drunken Booze: short speed/attack buff with a small incoming-damage drawback.
  - Elixir of Mastery: grants custom XP.

## Added Test Commands

- `kobold_item <item_name> <count>`
- `kobold_recipe <recipe_id>`
- `kobold_stash_put <slot>`
- `kobold_stash_take <item_name> <count>`
- `kobold_weather <clear|rain|winter|ghouls|darkness> <seconds>`
- `kobold_xp <amount>`
- `kobold_revive`

## Still Editor-Dependent

- Real Hammer map geometry.
- Actual terrain/pathing validation.
- Panorama inventory/crafting/stash UI.
- Production particles and sounds for weather and alchemy.
- Balance tuning after real movement, combat, and resource pacing are visible.

