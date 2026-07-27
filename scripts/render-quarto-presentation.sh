#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <presentation-dir>"
  exit 1
fi

presentation_dir="$1"

if [ ! -d "$presentation_dir" ]; then
  presentation_dir="$(cd "$(dirname "$0")/.." && pwd)/$presentation_dir"
fi

if [ ! -f "$presentation_dir/index.qmd" ]; then
  echo "Missing index.qmd in $presentation_dir"
  exit 1
fi

if command -v quarto >/dev/null 2>&1; then
  QUARTO_BIN="$(command -v quarto)"
elif [ -x "/home/hermes/.local/quarto/1.10.18/bin/quarto" ]; then
  QUARTO_BIN="/home/hermes/.local/quarto/1.10.18/bin/quarto"
else
  echo "Quarto not found. Install it or add it to PATH."
  exit 1
fi

(
  cd "$presentation_dir"
  "$QUARTO_BIN" render index.qmd
)

echo "Rendered $presentation_dir/index.html"
