# Kobold Survival Gameplay Spec

This document is the project source of truth for intended gameplay. It is derived from the canonical gameplay specification provided on 2026-07-13.

## Game Identity

Kobold Survival is a team-based PvPvE survival RPG. It is not a lane-based MOBA.

Core pillars:

- Competitive tribal survival.
- Cooperation inside each tribe.
- Harsh but readable environmental pressure.
- Crafting, camp construction, equipment, cooking, and exploration.
- Eventual tribal warfare after preparation.
- Clear match-level progression, not persistent account progression.

## Default Match

- Two opposing tribes.
- One human player controls one kobold hero.
- Up to five or six kobolds per tribe, depending on lobby configuration.
- Northern and Southern tribes start in separated world regions.
- PvP is always possible after initial protection ends.
- Friendly fire is disabled by default.
- Primary victory condition: eliminate every kobold on the opposing tribe.
- Dead players do not automatically respawn unless a selected game mode explicitly enables revival or respawning.

Future variants may support custom teams, free-for-all, cooperative/practice mode, fortress defense, timed survival victory, score victory, surrender, or central structure destruction. These are not initial targets.

## Core Fantasy

Each player begins as a weak, poorly equipped kobold in a dangerous forest.

Early priorities:

- Find food.
- Gather lumber and stone.
- Build a campfire.
- Build a tent or equivalent shelter.
- Survive the first night.
- Hunt animals and cook food.
- Begin skill specialization.
- Build crafting facilities.
- Explore for rare resources and events.
- Coordinate with the tribe.
- Fight the opposing tribe when prepared.

The environment should be able to kill careless players through starvation, cold, hostile wildlife, exhaustion, or world events before PvP dominates the match.

## Match Rhythm

### Early Game

The first day is a survival preparation phase. Players search for basic materials, food, camp locations, and rare resource opportunities.

Minimum first-night preparation:

- One campfire.
- One tent or equivalent shelter.
- One to three portions of food.

Prototype costs:

- Campfire: 1 lumber and 1 stone.
- Tent: 1 lumber plus either 1 leather or 1 wool.

All costs are data-driven.

### First Night

At night:

- Ambient temperature falls.
- Warmth drains.
- Aggressive nocturnal creatures appear or become more numerous.
- Visibility is reduced.
- Fires become strategically important.
- Players cook, craft, and recover stamina while sheltered.

Dire wolves should roam or spawn at night, attack on sight, and fear fire.

### Midgame

Tribes develop camps and specializations:

- Farm.
- Workbench or craft table.
- Storage.
- Smithy.
- Hunter's lodge.
- Tavern.
- Rare resource exploration.
- Random quest participation.
- Enemy scouting.

### Endgame

Endgame play includes:

- Organized raids.
- Ambushes.
- Camp destruction.
- High-value quests.
- Secret boss summoning.
- Rare equipment.
- Direct elimination of the enemy tribe.

Losing buildings should be serious, but not immediate defeat while tribe members remain alive.

## Kobold Base Actions

Every kobold initially supports these conceptual actions:

- Walk.
- Run.
- Stop.
- Basic attack.
- Interact.
- Gather or harvest.
- Pick up item.
- Drop item.
- Consume food.
- Open inventory.
- Open build menu.
- Open cooking menu when eligible.
- Open crafting interface near the appropriate station.
- Plant tree.
- Allocate skill points.
- Inspect survival status.
- Equip or unequip an item.

Running is faster than walking but drains stamina.

## Survival Resources

Each kobold has:

- Health.
- Mana or Energy.
- Hunger.
- Warmth.
- Stamina.

Health reaching zero kills the kobold. Equipment-drop behavior and enemy rewards are configurable.

Hunger decreases over time. At zero, apply `status_starved` and recurring health damage until hunger rises above zero.

Warmth decreases at night, during rain, during severe weather, and in cold terrain or water. At zero, apply `status_frostbite`, recurring health damage, and prevent running until warmth recovers or cold exposure ends.

Stamina is consumed by actions. At zero, apply a temporary collapse/stun. Stamina collapse cannot directly kill the player.

## Primary Attributes

Kobold Survival uses five independent attributes:

- Strength.
- Dexterity.
- Endurance.
- Intelligence.
- Willpower.

Do not map these directly onto Dota's Strength, Agility, and Intelligence without an abstraction layer.

## Leveling

- Every kobold starts at match level 1.
- Initial level cap: 10.
- Each level grants automatic attribute growth and five skill points.
- No persistent account leveling in early phases.

Cumulative XP targets:

| Level | XP |
| --- | ---: |
| 1 | 0 |
| 2 | 280 |
| 3 | 670 |
| 4 | 1170 |
| 5 | 1780 |
| 6 | 2500 |
| 7 | 3330 |
| 8 | 4270 |
| 9 | 5320 |
| 10 | 6480 |

XP is awarded for active participation, including gathering, cooking, crafting, building, killing wildlife, killing hostile monsters, killing enemy kobolds, taming animals, restarting fires, planting trees, and completing quests.

## Skills

Five match-specific skills:

- Forestry.
- Mining.
- Cooking.
- Foraging.
- Artisanship.

Players start at zero in every skill and spend skill points manually. Specialists unlock superior outcomes, but every kobold can perform basic actions.

Support milestone benefits at:

- 15 points.
- 20 points.
- 25 points.

Skill bonuses and milestones are data-driven.

## First Vertical Slice

The first playable sequence is:

1. Two kobolds spawn in separate test zones.
2. Each has Health, Hunger, Warmth and Stamina.
3. Day transitions into night.
4. Hunger decreases over time.
5. Warmth decreases at night.
6. Running consumes stamina.
7. Stamina reaching zero causes collapse.
8. The player can fell an ordinary tree for Lumber.
9. The player can mine a stone deposit for Stone.
10. The player can kill one Sheep for Raw Lamb and possible Wool.
11. The player can build a Campfire.
12. The fire restores warmth and scares a Wolf.
13. The player can cook Raw Lamb into Roasted Lamb.
14. The player can build a Tent.
15. The Tent accelerates stamina recovery.
16. The player gains experience from these activities.
17. Leveling grants five skill points.
18. Skill points may be spent in Forestry or Cooking.
19. Forestry improves tree harvesting.
20. Cooking improves Roasted Lamb and campfire duration.

Do not implement advanced AI, quests, bosses, smithing, or procedural terrain during this milestone.
