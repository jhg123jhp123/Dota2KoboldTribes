# Valve Documentation Headings Index

The offline Valve documentation zip has been indexed so we can search and plan against its structure without manually opening every page.

## Generated Heading Files

- Full machine-readable index: `generated/valve_headings/valve_doc_headings_all.json`
- Relevant Dota/Source 2 machine-readable index: `generated/valve_headings/valve_doc_headings_relevant.json`
- Relevant Dota/Source 2 Markdown index: `generated/valve_headings/valve_doc_headings_relevant.md`

The extractor is:

- `tools/extract_valve_doc_headings.py`

Run it with:

```bash
python3 tools/extract_valve_doc_headings.py \
  --zip /Users/abdurh/Downloads/developer.valvesoftware.com.zip \
  --output-dir generated/valve_headings
```

## Extraction Summary

- Pages with headings found: 1,501
- Total headings extracted: 13,892
- Relevant Dota/Source 2 pages selected: 56

## Most Useful Heading Groups For Kobold Survival

### Map Startup

- Addon Overview
- Addon Creation
- File Structure
- Playing Addons
- Simulating Players During Development
- Getting Started
- Compile and Run

These help us launch the addon, understand where files must live, test locally, and start Hammer correctly.

### Hammer And Tile Editor

- Hammer Overview
- Navigation
- Tile Editor Basics
- Tile Editor
- Terrain Blending
- World Layers
- New Tilesets
- Prefabs and Instances
- Mesh Entities

These help us build the map efficiently. For Kobold Survival, Tile Editor, prefabs, instances, and mesh entities are the most relevant parts.

### Dota-Specific Map Rules

- Grid Navigation Mesh
- Fog of War
- Minimap
- Lighting
- Performance
- Blocking Heroes' Routes
- Common Developer Commands

These pages impose the constraints that changed our map scale and placement plan:

- Playable space should stay within `16,384 x 16,384`.
- Grid navigation uses `64 x 64` cells.
- Traversable elevations should use `128` unit increments.
- Destructible trees snap to gridnav and have a map limit.
- Hero clip and creature clip should be used deliberately.
- Minimap boundaries and generation are explicit map tasks.

### Scripting And Runtime

- Scripting
- API
- ThinkerFunctions
- Listening to Game Events
- Built-In Engine Events
- Data Driven Abilities
- Custom Nettables
- Panorama

These are less important for Hammer blockout, but they matter for connecting map markers to runtime systems, debug overlays, CustomNetTables, UI, spawners, and gameplay event wiring.

## How The Headings Help Us

The headings index gives us a searchable map of Valve's docs. Instead of guessing which page covers a topic, we can search the generated JSON/Markdown for terms such as:

- `GridNav`
- `Tile Editor`
- `World Layers`
- `Minimap`
- `Performance`
- `Mesh Entities`
- `Custom Nettables`
- `ThinkerFunctions`

This is especially useful while the live Valve wiki is protected by anti-bot checks.

## What It Does Not Do

The headings index does not replace the article text. It tells us where the relevant topics are. When implementation details matter, use the extracted text in:

- `/Users/abdurh/Documents/Codex/2026-07-13/do/work/valve_docs_text`

Or open the saved/downloaded HTML page from the zip.
