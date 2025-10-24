#!/usr/bin/env python3
"""Validate YAML files in the repository."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

try:
    import yaml
except ModuleNotFoundError as exc:  # pragma: no cover - defensive import guard
    raise SystemExit(
        "PyYAML is required to validate YAML files. Install it with 'pip install pyyaml'."
    ) from exc


def find_yaml_files(root: Path) -> list[Path]:
    """Return a sorted list of all .yaml files beneath the provided root."""
    return sorted(root.rglob("*.yaml"))


def validate_file(path: Path) -> list[str]:
    """Validate a YAML file returning a list of error messages."""
    errors: list[str] = []
    try:
        with path.open("r", encoding="utf-8") as handle:
            # Load all documents to ensure multi-document files are fully parsed.
            list(yaml.safe_load_all(handle))
    except yaml.YAMLError as err:
        errors.append(str(err))
    except UnicodeDecodeError as err:
        errors.append(f"Invalid encoding: {err}")
    return errors


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "root",
        nargs="?",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="Repository root to scan for YAML files (defaults to project root).",
    )
    args = parser.parse_args(argv)

    root = args.root
    if not root.exists():
        parser.error(f"The path '{root}' does not exist.")

    yaml_files = find_yaml_files(root)
    if not yaml_files:
        print("No .yaml files found to validate.")
        return 0

    has_errors = False
    for file_path in yaml_files:
        errors = validate_file(file_path)
        if errors:
            has_errors = True
            print(f"YAML validation failed for {file_path}:", file=sys.stderr)
            for message in errors:
                print(f"  - {message}", file=sys.stderr)

    if has_errors:
        return 1

    print(f"Validated {len(yaml_files)} YAML file(s) successfully.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
