#!/usr/bin/env python3
"""
Extract headings from an offline Valve Developer Community zip.

The zip can be very large, so this reads HTML files directly from the archive
and writes compact heading indexes for later project research.
"""

from __future__ import annotations

import argparse
import json
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote
import zipfile


IGNORED_NAV_HEADINGS = {
    "Navigation menu",
    "Personal tools",
    "Namespaces",
    "Views",
    "Search",
    "Navigation",
    "Workshop",
    "Support",
    "Steam Community",
    "Tools",
}


RELEVANT_PREFIXES = (
    "Dota_2_Workshop_Tools/Level_Design",
    "Dota_2_Workshop_Tools/Scripting",
    "Dota_2_Workshop_Tools/Addon_Overview",
    "Dota_2_Workshop_Tools/Panorama",
    "Dota_2_Workshop_Tools/Custom_Nettables",
    "Source_2/Docs/Level_Design",
)


IGNORED_PREFIXES = (
    "Zh/",
    "Ru/",
    "Es/",
    "Pt-br/",
    "Fr/",
    "De/",
    "Ja/",
    "Ko/",
    "Special:",
    "Talk:",
    "User",
    "Category",
)


class HeadingParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.in_content = False
        self.skip_depth = 0
        self.current_level: int | None = None
        self.current_parts: list[str] = []
        self.headings: list[dict] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attrs_dict = dict(attrs)
        if tag == "div" and attrs_dict.get("id") == "mw-content-text":
            self.in_content = True

        if not self.in_content:
            return

        if tag in {"script", "style", "table"}:
            self.skip_depth += 1
            return

        if self.skip_depth:
            return

        if tag in {"h1", "h2", "h3", "h4", "h5", "h6"}:
            self.current_level = int(tag[1])
            self.current_parts = []

    def handle_endtag(self, tag: str) -> None:
        if not self.in_content:
            return

        if tag in {"script", "style", "table"} and self.skip_depth:
            self.skip_depth -= 1
            return

        if self.skip_depth:
            return

        if self.current_level is not None and tag == f"h{self.current_level}":
            text = " ".join("".join(self.current_parts).split())
            if text and text not in IGNORED_NAV_HEADINGS:
                self.headings.append({"level": self.current_level, "text": text})
            self.current_level = None
            self.current_parts = []

    def handle_data(self, data: str) -> None:
        if self.in_content and not self.skip_depth and self.current_level is not None:
            self.current_parts.append(data)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Extract Valve doc headings from an offline zip.")
    parser.add_argument("--zip", required=True, help="Path to developer.valvesoftware.com.zip")
    parser.add_argument("--output-dir", required=True, help="Directory for generated heading indexes")
    return parser.parse_args()


def is_relevant(path: str) -> bool:
    if path.startswith(IGNORED_PREFIXES):
        return False
    return path.startswith(RELEVANT_PREFIXES)


def title_from_path(path: str) -> str:
    if path.endswith(".html"):
        path = path[:-5]
    return unquote(path).replace("_", " / ")


def extract_headings(zip_path: Path) -> tuple[list[dict], list[dict]]:
    all_pages: list[dict] = []
    relevant_pages: list[dict] = []

    with zipfile.ZipFile(zip_path) as archive:
        for info in archive.infolist():
            if not info.filename.startswith("developer.valvesoftware.com/wiki/"):
                continue
            if not info.filename.endswith(".html"):
                continue

            rel_path = info.filename.removeprefix("developer.valvesoftware.com/wiki/")
            html = archive.read(info.filename).decode("utf-8", errors="replace")
            parser = HeadingParser()
            parser.feed(html)
            if not parser.headings:
                continue

            page = {
                "path": rel_path,
                "title": title_from_path(rel_path),
                "headings": parser.headings,
            }
            all_pages.append(page)
            if is_relevant(rel_path):
                relevant_pages.append(page)

    return all_pages, relevant_pages


def render_markdown(all_pages: list[dict], relevant_pages: list[dict]) -> str:
    lines = [
        "# Valve Documentation Headings",
        "",
        f"- All pages with headings: {len(all_pages)}",
        f"- Relevant Dota/Source 2 pages selected: {len(relevant_pages)}",
        f"- Total extracted headings: {sum(len(page['headings']) for page in all_pages)}",
        "",
        "## Relevant Dota/Source 2 Pages",
        "",
    ]

    for page in sorted(relevant_pages, key=lambda item: item["path"]):
        lines.append(f"### {page['path']}")
        for heading in page["headings"]:
            indent = "  " * max(0, heading["level"] - 2)
            lines.append(f"{indent}- H{heading['level']}: {heading['text']}")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    args = parse_args()
    zip_path = Path(args.zip)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    all_pages, relevant_pages = extract_headings(zip_path)

    (output_dir / "valve_doc_headings_all.json").write_text(
        json.dumps(all_pages, indent=2),
        encoding="utf-8",
    )
    (output_dir / "valve_doc_headings_relevant.json").write_text(
        json.dumps(relevant_pages, indent=2),
        encoding="utf-8",
    )
    (output_dir / "valve_doc_headings_relevant.md").write_text(
        render_markdown(all_pages, relevant_pages),
        encoding="utf-8",
    )

    print(f"All pages with headings: {len(all_pages)}")
    print(f"Relevant pages: {len(relevant_pages)}")
    print(f"Output: {output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
