# World Interfaces

The world layer owns map data transformation and runtime queries.

Phase 1 includes:

- `tile_registry.lua`: query interface for generated tile data.
- `world_builder.lua`: build interface for converting region definitions into runtime data.
- `world_types.lua`: documented data-shape notes for future implementation.

No terrain generation or gameplay placement logic is implemented in Phase 1.
