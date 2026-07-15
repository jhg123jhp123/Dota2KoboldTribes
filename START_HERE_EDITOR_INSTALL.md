# Start Here: Manual Dota 2 Editor Install

This folder is the handoff package for **Kobold Survival**.

You are expected to manually copy files into your Dota 2 Workshop Tools addon folders. Do not copy this whole folder directly into only one Dota directory; the `game` and `content` parts go to different places.

## 1. Extract The Zip

Extract:

```text
KoboldSurvival_editor_handoff.zip
```

You should see:

```text
KoboldSurvival/
├── README.md
├── START_HERE_EDITOR_INSTALL.md
├── docs/
├── generated/
├── tools/
└── dota_addon/
    ├── game/
    └── content/
```

## 2. Copy Game Files

Copy the contents of:

```text
KoboldSurvival/dota_addon/game/
```

into your Dota 2 game addon folder:

```text
Steam/steamapps/common/dota 2 beta/game/dota_addons/kobold_survival/
```

After copying, this should exist:

```text
Steam/steamapps/common/dota 2 beta/game/dota_addons/kobold_survival/scripts/vscripts/addon_game_mode.lua
```

## 3. Copy Content Files

Copy the contents of:

```text
KoboldSurvival/dota_addon/content/
```

into your Dota 2 content addon folder:

```text
Steam/steamapps/common/dota 2 beta/content/dota_addons/kobold_survival/
```

The content folder is currently light because we are using stock placeholder models. Later, Hammer maps, custom models, particles, materials, and UI source files will matter much more here.

## 4. Create Or Open The Addon

Open Dota 2 Workshop Tools.

Use addon name:

```text
kobold_survival
```

If Workshop Tools asks you to create an addon, create it with that exact folder/addon name, then copy the files above into the generated folders.

## 5. Create A Temporary Test Map

Create a simple test map for now, for example:

```text
kobold_survival_test.vmap
```

Do not try to build the whole production map first. Make a flat test area large enough for:

- two hero starts;
- resource nodes;
- a revival shrine;
- a bit of water or a placeholder lake;
- room to build campfires, tents, farms, taverns, and smithies.

The map implementation docs are:

```text
docs/MAP_IMPLEMENTATION_PLAN.md
docs/HAMMER_BLOCKOUT_GUIDE.md
docs/HAMMER_CSV_WORKFLOW.md
docs/MAP_REGION_BREAKDOWN.md
```

## 6. First Console Commands

Enable cheats for local testing.

Useful commands:

```text
kobold_grant resource_lumber 20
kobold_grant resource_stone 20
kobold_grant resource_gold 100
kobold_grant resource_iron 10
kobold_grant ingredient_wool 5
kobold_grant ingredient_leather 5
kobold_grant ingredient_handful_berries 10
kobold_grant ingredient_spicy_herbs 10
kobold_grant ingredient_sageberry 10
kobold_grant ingredient_lambent_sunflower 10
kobold_grant resource_shadowstone 5
kobold_grant resource_radiant_gemstone 5
```

Spawn test units:

```text
kobold_spawn_ai sheep
kobold_spawn_ai pheasant
kobold_spawn_ai wolf
kobold_spawn_ai dire_wolf
kobold_spawn_ai bear
kobold_spawn_ai stag
kobold_spawn_ai murloc
kobold_spawn_ai boss
```

Create test items:

```text
kobold_item item_tool_fishing_rod 1
kobold_item item_food_roasted_lamb 3
kobold_item item_active_powdered_flask 2
```

Force weather:

```text
kobold_weather rain 120
kobold_weather winter 120
kobold_weather ghouls 120
kobold_weather darkness 120
kobold_weather clear 0
```

Test recipes:

```text
kobold_recipe recipe_roasted_lamb
kobold_recipe recipe_stag_stew
kobold_recipe recipe_fishing_rod
kobold_recipe recipe_powdered_flask
```

Test tribe stash:

```text
kobold_stash_put 0
kobold_stash_take item_food_roasted_lamb 1
```

## 7. What To Test First

Test in this order:

1. Addon loads without fatal Lua/KV errors.
2. Hero is forced to `npc_dota_hero_kobold_survivor`.
3. Hero receives starter abilities and starter items.
4. Resource commands modify tribe resources.
5. Building abilities create campfire, tent, farm, tavern, and shrine-related interactions.
6. Farm can be baited and starts attracting pheasants.
7. Fishing Rod channels and creates fish items.
8. Recipe commands create food/alchemy items.
9. Tribe stash deposit and withdrawal works.
10. Weather commands change net-table state and affect warmth/campfires.
11. Wildlife AI moves/flees/attacks.
12. Revival shrine channel revives dead allied kobolds.

## 8. Expected Rough Edges

This is not a finished custom game yet.

Expected first-editor problems:

- Dota API calls that behave slightly differently than expected.
- KV constants that need current-engine adjustment.
- Placeholder stock model paths that may need replacement.
- Spawn points outside your temporary map if the map is too small.
- No Panorama UI yet for inventory, stash, crafting, or survival meters.
- No final Hammer map yet.
- No production particles, sounds, or custom models yet.

## 9. Most Important Docs

Read these first:

```text
docs/PLAYTESTING.md
docs/MAX_IMPLEMENTATION_PASS.md
docs/RuntimeImplementation.md
docs/NATURE_RISING_MECHANIC_NOTES.md
docs/HAMMER_BLOCKOUT_GUIDE.md
```

## 10. When Something Breaks

Copy the Workshop Tools console error exactly.

The most useful error format is:

```text
File:
Line:
Error:
What you clicked or loaded:
```

The next cleanup pass should be driven by the real Dota editor logs.

