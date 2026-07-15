# Runtime Data

This folder is reserved for authored data or generated runtime data used by server-side Lua.

Lua tables are the canonical runtime data format.

Phase 1 includes:

- `worlds/kobold_survival_default.lua`: canonical runtime world definition.
- `worlds/kobold_survival_default.json`: optional parallel example for tooling/schema discussion.
- `tribes/tribe_rules.lua`: data contract for 2, 3, and 4 tribe configurations.
- `catalog/*.lua`: canonical content and balance data contracts from the gameplay specification.
