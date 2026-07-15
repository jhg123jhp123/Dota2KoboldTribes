#!/usr/bin/env python3
"""
Offline processor for the Kobold Tribes 128x128 CSV blockout.

This tool is intentionally editor-side only. It validates the coordinate-level
CSV, groups dense tile data into practical regions, and exports simplified JSON
files that designers and Hammer blockout scripts can consume later.
"""

from __future__ import annotations

import argparse
import collections
import csv
import json
import math
import os
from typing import Callable


REQUIRED_COLUMNS = [
    "tile_id",
    "grid_x",
    "grid_y",
    "world_x",
    "world_y",
    "tile_size_units",
    "zone",
    "terrain",
    "elevation_level",
    "water_depth",
    "walkable",
    "buildable",
    "road",
    "primary_entity_type",
    "primary_entity_id",
    "resource_type",
    "resource_tier",
    "resource_quantity",
    "respawn_seconds",
    "spawn_group",
    "boss_arena",
    "point_of_interest",
    "decoration",
    "ambient_fx",
    "hazard",
    "designer_notes",
]


INTEGER_FIELDS = {
    "grid_x",
    "grid_y",
    "world_x",
    "world_y",
    "tile_size_units",
    "elevation_level",
    "water_depth",
    "walkable",
    "buildable",
    "resource_tier",
    "resource_quantity",
    "respawn_seconds",
}


WALKABLE_ENTITY_TYPES = {
    "animal_spawner",
    "cave_entrance",
    "tribe_start",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate and simplify the Kobold map CSV.")
    parser.add_argument("--csv", required=True, help="Path to kobold_tribes_map_128x128.csv")
    parser.add_argument("--legend", help="Optional path to kobold_tribes_map_legend.csv")
    parser.add_argument("--metadata", help="Optional path to kobold_tribes_map_metadata.json")
    parser.add_argument("--output-dir", required=True, help="Directory for generated JSON/report files")
    parser.add_argument("--min-region-tiles", type=int, default=4)
    parser.add_argument("--spawn-cell-size", type=int, default=16)
    parser.add_argument(
        "--target-tile-size-units",
        type=int,
        default=128,
        help="Hammer units per design tile in generated Hammer coordinates. Defaults to 128 to keep a 128x128 map inside Dota's 16384x16384 fog-of-war limit.",
    )
    return parser.parse_args()


def to_int(value: str | int | None) -> int | None:
    if value == "" or value is None:
        return None
    if isinstance(value, int):
        return value
    return int(value)


def load_metadata(path: str | None) -> dict:
    if not path:
        return {}
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def load_legend(path: str | None) -> dict:
    legend = {
        "terrain_values": set(),
        "elevation_values": set(),
    }
    if not path:
        return legend

    with open(path, newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            category = row.get("category", "")
            value = row.get("value", "")
            if category == "Terrain":
                legend["terrain_values"].add(value)
            elif category == "Elevation":
                legend["elevation_values"].add(int(value))
    return legend


def load_rows(path: str) -> tuple[list[dict], list[str]]:
    rows: list[dict] = []
    with open(path, newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        headers = reader.fieldnames or []
        for raw in reader:
            row = dict(raw)
            for field in INTEGER_FIELDS:
                row[field] = to_int(row.get(field))
            rows.append(row)
    return rows, headers


def apply_hammer_coordinates(rows: list[dict], metadata: dict, target_tile_size: int) -> None:
    width = int(metadata.get("grid_width", 128))
    height = int(metadata.get("grid_height", 128))
    center_x = (width - 1) / 2
    center_y = (height - 1) / 2

    for row in rows:
        grid_x = row["grid_x"]
        grid_y = row["grid_y"]
        elevation = row["elevation_level"]

        row["hammer_x"] = round((grid_x - center_x) * target_tile_size)
        row["hammer_y"] = round((center_y - grid_y) * target_tile_size)

        if elevation <= -2:
            row["hammer_z_hint"] = -128
        elif elevation == -1:
            row["hammer_z_hint"] = 0
        else:
            row["hammer_z_hint"] = (elevation + 1) * 128


def tile_key(x: int, y: int) -> str:
    return f"{x},{y}"


def bbox(rows: list[dict]) -> dict:
    xs = [row["grid_x"] for row in rows]
    ys = [row["grid_y"] for row in rows]
    wx = [row["world_x"] for row in rows if row["world_x"] is not None]
    wy = [row["world_y"] for row in rows if row["world_y"] is not None]
    hammer_x = [row["hammer_x"] for row in rows if row.get("hammer_x") is not None]
    hammer_y = [row["hammer_y"] for row in rows if row.get("hammer_y") is not None]
    result = {
        "x1": min(xs),
        "y1": min(ys),
        "x2": max(xs),
        "y2": max(ys),
        "world_x1": min(wx) if wx else None,
        "world_y1": min(wy) if wy else None,
        "world_x2": max(wx) if wx else None,
        "world_y2": max(wy) if wy else None,
        "tile_count": len(rows),
    }
    if hammer_x and hammer_y:
        result["hammer_x1"] = min(hammer_x)
        result["hammer_y1"] = min(hammer_y)
        result["hammer_x2"] = max(hammer_x)
        result["hammer_y2"] = max(hammer_y)
    return result


def center(rows: list[dict]) -> dict:
    count = len(rows)
    result = {
        "grid_x": round(sum(row["grid_x"] for row in rows) / count, 2),
        "grid_y": round(sum(row["grid_y"] for row in rows) / count, 2),
        "world_x": round(sum(row["world_x"] for row in rows if row["world_x"] is not None) / count, 2),
        "world_y": round(sum(row["world_y"] for row in rows if row["world_y"] is not None) / count, 2),
    }
    if rows and rows[0].get("hammer_x") is not None:
        result["hammer_x"] = round(sum(row["hammer_x"] for row in rows) / count, 2)
        result["hammer_y"] = round(sum(row["hammer_y"] for row in rows) / count, 2)
    return result


def counter_summary(rows: list[dict], field: str) -> dict:
    counts = collections.Counter(row[field] for row in rows)
    return {str(key): value for key, value in sorted(counts.items(), key=lambda pair: str(pair[0]))}


def build_grid(rows: list[dict]) -> dict[tuple[int, int], dict]:
    return {(row["grid_x"], row["grid_y"]): row for row in rows}


def neighbors4(x: int, y: int) -> list[tuple[int, int]]:
    return [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]


def connected_components(
    rows: list[dict],
    predicate: Callable[[dict], bool],
    key_fn: Callable[[dict], tuple] | None = None,
) -> list[list[dict]]:
    grid = build_grid(rows)
    seen: set[tuple[int, int]] = set()
    components: list[list[dict]] = []

    for row in rows:
        start = (row["grid_x"], row["grid_y"])
        if start in seen or not predicate(row):
            continue

        key = key_fn(row) if key_fn else None
        stack = [start]
        seen.add(start)
        component = []

        while stack:
            current = stack.pop()
            current_row = grid[current]
            component.append(current_row)

            for neighbor in neighbors4(*current):
                neighbor_row = grid.get(neighbor)
                if neighbor in seen or neighbor_row is None or not predicate(neighbor_row):
                    continue
                if key_fn and key_fn(neighbor_row) != key:
                    continue
                seen.add(neighbor)
                stack.append(neighbor)

        components.append(component)

    return components


def summarize_components(
    components: list[list[dict]],
    key_fields: list[str],
    min_tiles: int = 1,
    id_prefix: str = "region",
) -> list[dict]:
    output = []
    for index, component in enumerate(sorted(components, key=len, reverse=True), start=1):
        if len(component) < min_tiles:
            continue
        first = component[0]
        item = {
            "id": f"{id_prefix}_{index:04d}",
            "tile_count": len(component),
            "bounds": bbox(component),
            "center": center(component),
        }
        for field in key_fields:
            item[field] = first[field]
        output.append(item)
    return output


def summarize_zone(rows: list[dict]) -> list[dict]:
    zones = []
    by_zone: dict[str, list[dict]] = collections.defaultdict(list)
    for row in rows:
        by_zone[row["zone"]].append(row)

    for zone, zone_rows in sorted(by_zone.items()):
        zones.append({
            "zone": zone,
            "bounds": bbox(zone_rows),
            "center": center(zone_rows),
            "terrain_counts": counter_summary(zone_rows, "terrain"),
            "elevation_counts": counter_summary(zone_rows, "elevation_level"),
            "walkable_tiles": sum(1 for row in zone_rows if row["walkable"] == 1),
            "buildable_tiles": sum(1 for row in zone_rows if row["buildable"] == 1),
        })
    return zones


def summarize_boundaries(rows: list[dict]) -> dict:
    grid = build_grid(rows)
    zone_boundaries = collections.Counter()
    terrain_boundaries = collections.Counter()
    samples = []

    for row in rows:
        x = row["grid_x"]
        y = row["grid_y"]
        for nx, ny in [(x + 1, y), (x, y + 1)]:
            other = grid.get((nx, ny))
            if not other:
                continue
            if row["zone"] != other["zone"]:
                key = tuple(sorted([row["zone"], other["zone"]]))
                zone_boundaries[key] += 1
                if len(samples) < 40:
                    samples.append({
                        "type": "zone",
                        "from": row["zone"],
                        "to": other["zone"],
                        "a": {"x": x, "y": y},
                        "b": {"x": nx, "y": ny},
                    })
            if row["terrain"] != other["terrain"]:
                key = tuple(sorted([row["terrain"], other["terrain"]]))
                terrain_boundaries[key] += 1

    return {
        "zone_boundaries": {f"{a} | {b}": count for (a, b), count in zone_boundaries.most_common()},
        "terrain_boundaries": {f"{a} | {b}": count for (a, b), count in terrain_boundaries.most_common()},
        "samples": samples,
    }


def summarize_resource_spawns(rows: list[dict]) -> dict:
    resource_rows = [row for row in rows if row["resource_type"]]
    components = connected_components(
        resource_rows,
        lambda row: bool(row["resource_type"]),
        lambda row: (row["zone"], row["resource_type"], row["resource_tier"]),
    )
    zones = summarize_components(
        components,
        ["zone", "resource_type", "resource_tier"],
        min_tiles=1,
        id_prefix="resource_zone",
    )

    by_type = collections.defaultdict(lambda: {"tile_count": 0, "quantity": 0})
    for row in resource_rows:
        key = f"{row['zone']}:{row['resource_type']}:tier_{row['resource_tier']}"
        by_type[key]["tile_count"] += 1
        by_type[key]["quantity"] += row["resource_quantity"] or 0

    for zone in zones:
        zone["recommended_placement"] = "spawn_zone"
        zone["suggested_max_live_nodes"] = max(1, math.ceil(zone["tile_count"] / 8))

    return {
        "summary": dict(sorted(by_type.items())),
        "resource_zones": zones,
    }


def summarize_wildlife_spawns(rows: list[dict], cell_size: int) -> dict:
    spawn_rows = [row for row in rows if row["spawn_group"]]
    by_group = collections.Counter((row["zone"], row["spawn_group"]) for row in spawn_rows)
    cells = collections.defaultdict(list)

    for row in spawn_rows:
        cell_x = row["grid_x"] // cell_size
        cell_y = row["grid_y"] // cell_size
        cells[(row["zone"], row["spawn_group"], cell_x, cell_y)].append(row)

    spawn_zones = []
    for index, ((zone, group, cell_x, cell_y), cell_rows) in enumerate(
        sorted(cells.items(), key=lambda item: (item[0][0], item[0][1], item[0][2], item[0][3])),
        start=1,
    ):
        spawn_zones.append({
            "id": f"wildlife_zone_{index:04d}",
            "zone": zone,
            "spawn_group": group,
            "cell": {"x": cell_x, "y": cell_y, "size_tiles": cell_size},
            "bounds": bbox(cell_rows),
            "center": center(cell_rows),
            "source_marker_count": len(cell_rows),
            "recommended_placement": "one spawn controller for this cell, not one entity per marker",
        })

    exact_markers = [
        {
            "tile_id": row["tile_id"],
            "grid": {"x": row["grid_x"], "y": row["grid_y"]},
            "world": {"x": row["world_x"], "y": row["world_y"]},
            "hammer_world": {"x": row.get("hammer_x"), "y": row.get("hammer_y"), "z_hint": row.get("hammer_z_hint")},
            "zone": row["zone"],
            "spawn_group": row["spawn_group"],
            "primary_entity_id": row["primary_entity_id"],
            "boss_arena": row["boss_arena"],
        }
        for row in spawn_rows
    ]

    return {
        "summary": {f"{zone}:{group}": count for (zone, group), count in sorted(by_group.items())},
        "spawn_zones": spawn_zones,
        "source_markers": exact_markers,
    }


def summarize_decorations(rows: list[dict]) -> dict:
    decoration_rows = [row for row in rows if row["decoration"] or row["ambient_fx"]]
    by_decoration = collections.Counter((row["zone"], row["decoration"]) for row in rows if row["decoration"])
    by_ambient = collections.Counter((row["zone"], row["ambient_fx"]) for row in rows if row["ambient_fx"])

    zones = collections.defaultdict(list)
    for row in decoration_rows:
        key = (row["zone"], row["decoration"] or "ambient_only", row["ambient_fx"] or "")
        zones[key].append(row)

    decoration_zones = []
    for index, ((zone, decoration, ambient_fx), zone_rows) in enumerate(
        sorted(zones.items(), key=lambda item: (item[0][0], item[0][1], item[0][2])),
        start=1,
    ):
        decoration_zones.append({
            "id": f"decoration_zone_{index:04d}",
            "zone": zone,
            "decoration": decoration,
            "ambient_fx": ambient_fx,
            "bounds": bbox(zone_rows),
            "center": center(zone_rows),
            "source_marker_count": len(zone_rows),
            "recommended_placement": "cluster, prop group, prefab, or biome controller",
        })

    return {
        "decoration_summary": {f"{zone}:{name}": count for (zone, name), count in sorted(by_decoration.items())},
        "ambient_summary": {f"{zone}:{name}": count for (zone, name), count in sorted(by_ambient.items())},
        "decoration_zones": decoration_zones,
    }


def validate(rows: list[dict], headers: list[str], metadata: dict, legend: dict) -> dict:
    errors = []
    warnings = []
    grid = build_grid(rows)

    missing_columns = [column for column in REQUIRED_COLUMNS if column not in headers]
    if missing_columns:
        errors.append(f"Missing required columns: {', '.join(missing_columns)}")

    width = int(metadata.get("grid_width", 128))
    height = int(metadata.get("grid_height", 128))
    expected_count = int(metadata.get("row_count", width * height))
    expected_tile_size = int(metadata.get("tile_size_units", 256))

    if len(rows) != expected_count:
        errors.append(f"Expected {expected_count} rows, found {len(rows)}")

    duplicates = len(rows) - len(grid)
    if duplicates:
        errors.append(f"Found {duplicates} duplicate coordinates")

    missing_coordinates = []
    for y in range(height):
        for x in range(width):
            if (x, y) not in grid:
                missing_coordinates.append((x, y))
    if missing_coordinates:
        errors.append(f"Missing {len(missing_coordinates)} coordinates")

    terrain_values = legend["terrain_values"]
    elevation_values = legend["elevation_values"]

    for row in rows:
        x = row["grid_x"]
        y = row["grid_y"]
        if x is None or y is None or x < 0 or x >= width or y < 0 or y >= height:
            errors.append(f"{row.get('tile_id', '<unknown>')}: coordinate out of range")
        if row["tile_size_units"] != expected_tile_size:
            errors.append(f"{row['tile_id']}: tile_size_units should be {expected_tile_size}")
        if terrain_values and row["terrain"] not in terrain_values:
            errors.append(f"{row['tile_id']}: unknown terrain '{row['terrain']}'")
        if elevation_values and row["elevation_level"] not in elevation_values:
            errors.append(f"{row['tile_id']}: unknown elevation {row['elevation_level']}")
        if row["walkable"] not in (0, 1):
            errors.append(f"{row['tile_id']}: walkable should be 0 or 1")
        if row["buildable"] not in (0, 1):
            errors.append(f"{row['tile_id']}: buildable should be 0 or 1")
        if row["buildable"] == 1 and row["walkable"] != 1:
            errors.append(f"{row['tile_id']}: buildable tile is not walkable")

        entity_type = row["primary_entity_type"]
        if entity_type in WALKABLE_ENTITY_TYPES and row["walkable"] != 1:
            warnings.append(f"{row['tile_id']}: {entity_type} is not on a walkable tile")
        if entity_type == "tribe_start" and row["buildable"] != 1:
            warnings.append(f"{row['tile_id']}: tribe_start is not on a buildable tile")
        if entity_type in {"boss_spawner", "point_of_interest"} and row["walkable"] != 1:
            warnings.append(f"{row['tile_id']}: {entity_type} may need a nearby walkable landing area")

    walkable_components = connected_components(rows, lambda row: row["walkable"] == 1)
    if len(walkable_components) > 1:
        small = [component for component in walkable_components if len(component) < 4]
        warnings.append(
            f"Found {len(walkable_components)} disconnected walkable areas; "
            f"{len(small)} are smaller than 4 tiles"
        )

    elevation_jumps = []
    for row in rows:
        x = row["grid_x"]
        y = row["grid_y"]
        for nx, ny in [(x + 1, y), (x, y + 1)]:
            other = grid.get((nx, ny))
            if not other:
                continue
            delta = abs(row["elevation_level"] - other["elevation_level"])
            if delta > 1 and (row["walkable"] == 1 or other["walkable"] == 1):
                elevation_jumps.append((row, other, delta))
    if elevation_jumps:
        warnings.append(f"Found {len(elevation_jumps)} elevation transitions greater than 1 near walkable tiles")

    cell_counts = collections.Counter()
    for row in rows:
        if row["spawn_group"] or row["primary_entity_type"] in {"animal_spawner", "boss_spawner"}:
            cell_counts[(row["grid_x"] // 8, row["grid_y"] // 8)] += 1
    overcrowded = [(cell, count) for cell, count in cell_counts.items() if count > 8]
    if overcrowded:
        warnings.append(f"Found {len(overcrowded)} overcrowded 8x8 spawn cells")

    return {
        "errors": errors,
        "warnings": warnings,
        "walkable_components": summarize_components(walkable_components, [], min_tiles=1, id_prefix="walkable"),
        "buildable_components": summarize_components(
            connected_components(rows, lambda row: row["buildable"] == 1),
            [],
            min_tiles=1,
            id_prefix="buildable",
        ),
        "elevation_jump_samples": [
            {
                "from": {"tile_id": a["tile_id"], "x": a["grid_x"], "y": a["grid_y"], "elevation": a["elevation_level"]},
                "to": {"tile_id": b["tile_id"], "x": b["grid_x"], "y": b["grid_y"], "elevation": b["elevation_level"]},
                "delta": delta,
            }
            for a, b, delta in elevation_jumps[:100]
        ],
    }


def write_json(path: str, data: dict | list) -> None:
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(data, handle, indent=2, sort_keys=True)
        handle.write("\n")


def marker_suggestion(row: dict) -> tuple[str, str, str]:
    if row["primary_entity_type"] == "tribe_start":
        return "tribe_start", "team player start / spawn anchor", "Place or align the team start prefab here."
    if row["primary_entity_type"] == "boss_spawner":
        return "boss_spawner", "custom boss spawn marker + trigger volume", "Create a boss arena floor nearby if this tile is not walkable."
    if row["primary_entity_type"] == "cave_entrance":
        return "cave_entrance", "cave entrance prefab", "Decide real entrance, mine entrance, quest lock, or decorative cave."
    if row["primary_entity_type"] == "point_of_interest":
        return "point_of_interest", "quest/landmark prefab", "Place the visual landmark and a nearby playable quest marker."
    if row["primary_entity_type"] == "animal_spawner" or row["spawn_group"]:
        return "wildlife_spawner", "spawn controller marker", "Use as a spawn-zone source, not a thinker per marker."
    if row["hazard"]:
        return "hazard", "trigger volume", "Author as a gameplay trigger or scripted hazard zone."
    if row["road"]:
        return "road_guide", "trail guide point", "Use as a path spline guide, not as literal tile geometry."
    return "reference", "editor reference marker", "Reference only."


def should_export_marker(row: dict) -> bool:
    return any([
        row["primary_entity_type"],
        row["spawn_group"],
        row["boss_arena"],
        row["point_of_interest"],
        row["road"],
        row["hazard"],
    ])


def write_hammer_marker_csv(path: str, rows: list[dict]) -> None:
    fields = [
        "marker_kind",
        "suggested_hammer_use",
        "tile_id",
        "grid_x",
        "grid_y",
        "hammer_x",
        "hammer_y",
        "hammer_z_hint",
        "source_world_x",
        "source_world_y",
        "zone",
        "terrain",
        "elevation_level",
        "walkable",
        "buildable",
        "primary_entity_type",
        "primary_entity_id",
        "spawn_group",
        "boss_arena",
        "point_of_interest",
        "road",
        "hazard",
        "suggested_action",
    ]

    with open(path, "w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            if not should_export_marker(row):
                continue
            marker_kind, suggested_hammer_use, suggested_action = marker_suggestion(row)
            writer.writerow({
                "marker_kind": marker_kind,
                "suggested_hammer_use": suggested_hammer_use,
                "tile_id": row["tile_id"],
                "grid_x": row["grid_x"],
                "grid_y": row["grid_y"],
                "hammer_x": row.get("hammer_x"),
                "hammer_y": row.get("hammer_y"),
                "hammer_z_hint": row.get("hammer_z_hint"),
                "source_world_x": row["world_x"],
                "source_world_y": row["world_y"],
                "zone": row["zone"],
                "terrain": row["terrain"],
                "elevation_level": row["elevation_level"],
                "walkable": row["walkable"],
                "buildable": row["buildable"],
                "primary_entity_type": row["primary_entity_type"],
                "primary_entity_id": row["primary_entity_id"],
                "spawn_group": row["spawn_group"],
                "boss_arena": row["boss_arena"],
                "point_of_interest": row["point_of_interest"],
                "road": row["road"],
                "hazard": row["hazard"],
                "suggested_action": suggested_action,
            })


def write_region_rect_csv(path: str, map_regions: dict) -> None:
    fields = [
        "region_id",
        "zone",
        "terrain",
        "elevation_level",
        "walkable",
        "buildable",
        "tile_count",
        "grid_x1",
        "grid_y1",
        "grid_x2",
        "grid_y2",
        "hammer_x1",
        "hammer_y1",
        "hammer_x2",
        "hammer_y2",
        "center_hammer_x",
        "center_hammer_y",
        "suggested_layer",
    ]
    with open(path, "w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for region in map_regions["grouped_regions"]:
            bounds = region["bounds"]
            center_data = region["center"]
            writer.writerow({
                "region_id": region["id"],
                "zone": region["zone"],
                "terrain": region["terrain"],
                "elevation_level": region["elevation_level"],
                "walkable": region["walkable"],
                "buildable": region["buildable"],
                "tile_count": region["tile_count"],
                "grid_x1": bounds["x1"],
                "grid_y1": bounds["y1"],
                "grid_x2": bounds["x2"],
                "grid_y2": bounds["y2"],
                "hammer_x1": bounds.get("hammer_x1"),
                "hammer_y1": bounds.get("hammer_y1"),
                "hammer_x2": bounds.get("hammer_x2"),
                "hammer_y2": bounds.get("hammer_y2"),
                "center_hammer_x": center_data.get("hammer_x"),
                "center_hammer_y": center_data.get("hammer_y"),
                "suggested_layer": f"{region['zone']}_{region['terrain']}",
            })


def markdown_table(headers: list[str], rows: list[list[object]]) -> str:
    output = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join(["---"] * len(headers)) + " |",
    ]
    for row in rows:
        output.append("| " + " | ".join(str(value) for value in row) + " |")
    return "\n".join(output)


def write_report(path: str, rows: list[dict], validation: dict, boundaries: dict, scale: dict) -> None:
    zone_rows = []
    for zone in summarize_zone(rows):
        zone_rows.append([
            zone["zone"],
            zone["bounds"]["tile_count"],
            zone["walkable_tiles"],
            zone["buildable_tiles"],
            zone["bounds"]["x1"],
            zone["bounds"]["y1"],
            zone["bounds"]["x2"],
            zone["bounds"]["y2"],
        ])

    terrain_counts = collections.Counter(row["terrain"] for row in rows)
    terrain_rows = [[terrain, count] for terrain, count in terrain_counts.most_common()]

    lines = [
        "# Map Validation Report",
        "",
        "Generated by `tools/map_csv_processor.py`.",
        "",
        "## Summary",
        "",
        f"- Source tile rows: {len(rows)}",
        f"- Source CSV footprint: {scale['source_footprint_units']['x']} x {scale['source_footprint_units']['y']} units",
        f"- Target Hammer footprint: {scale['target_hammer_footprint_units']['x']} x {scale['target_hammer_footprint_units']['y']} units",
        f"- Target Hammer tile size: {scale['target_hammer_tile_size_units']} units",
        f"- Coordinate scale: {scale['coordinate_scale']}",
        f"- Dota gridnav cell size: {scale['dota_gridnav_cell_units']} units",
        f"- Dota fog-of-war max playable size: {scale['dota_fog_of_war_max_playable_units']['x']} x {scale['dota_fog_of_war_max_playable_units']['y']} units",
        f"- Walkable components: {len(validation['walkable_components'])}",
        f"- Buildable components: {len(validation['buildable_components'])}",
        f"- Validation errors: {len(validation['errors'])}",
        f"- Validation warnings: {len(validation['warnings'])}",
        "",
        "## Zones",
        "",
        markdown_table(
            ["zone", "tiles", "walkable", "buildable", "x1", "y1", "x2", "y2"],
            zone_rows,
        ),
        "",
        "## Terrain Counts",
        "",
        markdown_table(["terrain", "tiles"], terrain_rows),
        "",
        "## Validation Errors",
        "",
    ]

    if validation["errors"]:
        lines.extend(f"- {error}" for error in validation["errors"])
    else:
        lines.append("- None")

    lines.extend(["", "## Validation Warnings", ""])
    if validation["warnings"]:
        lines.extend(f"- {warning}" for warning in validation["warnings"])
    else:
        lines.append("- None")

    lines.extend(["", "## Major Zone Boundaries", ""])
    for name, count in list(boundaries["zone_boundaries"].items())[:20]:
        lines.append(f"- {name}: {count} adjacent edges")

    lines.extend(["", "## Largest Walkable Components", ""])
    for component in validation["walkable_components"][:12]:
        bounds = component["bounds"]
        lines.append(
            f"- {component['id']}: {component['tile_count']} tiles, "
            f"bounds ({bounds['x1']},{bounds['y1']}) to ({bounds['x2']},{bounds['y2']})"
        )

    lines.extend(["", "## Elevation Jump Samples", ""])
    if validation["elevation_jump_samples"]:
        for sample in validation["elevation_jump_samples"][:20]:
            lines.append(
                f"- {sample['from']['tile_id']} elevation {sample['from']['elevation']} "
                f"to {sample['to']['tile_id']} elevation {sample['to']['elevation']} "
                f"(delta {sample['delta']})"
            )
    else:
        lines.append("- None")

    with open(path, "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines))
        handle.write("\n")


def main() -> int:
    args = parse_args()
    metadata = load_metadata(args.metadata)
    legend = load_legend(args.legend)
    rows, headers = load_rows(args.csv)
    apply_hammer_coordinates(rows, metadata, args.target_tile_size_units)
    validation = validate(rows, headers, metadata, legend)

    source_tile_size = int(metadata.get("tile_size_units", 256))
    grid_width = int(metadata.get("grid_width", 128))
    grid_height = int(metadata.get("grid_height", 128))
    source_footprint_x = grid_width * source_tile_size
    source_footprint_y = grid_height * source_tile_size
    hammer_footprint_x = grid_width * args.target_tile_size_units
    hammer_footprint_y = grid_height * args.target_tile_size_units

    region_components = connected_components(
        rows,
        lambda row: True,
        lambda row: (row["zone"], row["terrain"], row["elevation_level"], row["walkable"], row["buildable"]),
    )
    scale = {
        "source_tile_size_units": source_tile_size,
        "target_hammer_tile_size_units": args.target_tile_size_units,
        "coordinate_scale": args.target_tile_size_units / source_tile_size,
        "source_footprint_units": {"x": source_footprint_x, "y": source_footprint_y},
        "target_hammer_footprint_units": {"x": hammer_footprint_x, "y": hammer_footprint_y},
        "dota_fog_of_war_max_playable_units": {"x": 16384, "y": 16384},
        "dota_gridnav_cell_units": 64,
        "target_tile_gridnav_cells": args.target_tile_size_units / 64,
        "recommended_hammer_blockout_cell_tiles": 2,
        "recommended_hammer_blockout_cell_units": args.target_tile_size_units * 2,
        "recommended_hammer_macro_cell_tiles": 4,
        "recommended_hammer_macro_cell_units": args.target_tile_size_units * 4,
        "elevation_hint": "Treat CSV elevation as design layers. Suggested Z: deep water visual below 0, shallow water at 0, base ground at 128, then 128-unit increments.",
        "note": "Use CSV tiles as design cells; scale to target Hammer coordinates and group before placement.",
    }

    map_regions = {
        "source_csv": os.path.abspath(args.csv),
        "metadata": metadata,
        "recommended_scale": scale,
        "zone_summaries": summarize_zone(rows),
        "terrain_counts": counter_summary(rows, "terrain"),
        "elevation_counts": counter_summary(rows, "elevation_level"),
        "biome_boundaries": summarize_boundaries(rows),
        "grouped_regions": summarize_components(
            region_components,
            ["zone", "terrain", "elevation_level", "walkable", "buildable"],
            min_tiles=args.min_region_tiles,
            id_prefix="map_region",
        ),
        "small_region_count_below_threshold": sum(1 for component in region_components if len(component) < args.min_region_tiles),
        "walkable_components": validation["walkable_components"],
        "buildable_components": validation["buildable_components"],
    }

    boundaries = map_regions["biome_boundaries"]

    os.makedirs(args.output_dir, exist_ok=True)
    write_json(os.path.join(args.output_dir, "map_regions.json"), map_regions)
    write_json(os.path.join(args.output_dir, "resource_spawns.json"), summarize_resource_spawns(rows))
    write_json(os.path.join(args.output_dir, "wildlife_spawns.json"), summarize_wildlife_spawns(rows, args.spawn_cell_size))
    write_json(os.path.join(args.output_dir, "decorations.json"), summarize_decorations(rows))
    write_report(os.path.join(args.output_dir, "map_validation_report.md"), rows, validation, boundaries, scale)
    write_hammer_marker_csv(os.path.join(args.output_dir, "hammer_marker_manifest.csv"), rows)
    write_region_rect_csv(os.path.join(args.output_dir, "hammer_region_rects.csv"), map_regions)

    print(f"Processed {len(rows)} rows")
    print(f"Errors: {len(validation['errors'])}")
    print(f"Warnings: {len(validation['warnings'])}")
    print(f"Output: {args.output_dir}")
    return 1 if validation["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
