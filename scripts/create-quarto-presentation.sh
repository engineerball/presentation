#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <slug> <title>"
  exit 1
fi

slug="$1"
shift
TITLE="$*"

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
template_dir="$repo_root/templates/quarto-reveal"
target_dir="$repo_root/$slug"

if [ -e "$target_dir" ]; then
  echo "Target already exists: $target_dir"
  exit 1
fi

mkdir -p "$target_dir"
cp "$template_dir/theme.scss" "$target_dir/theme.scss"
cp "$template_dir/speaker-notes.md" "$target_dir/speaker-notes.md"
TITLE="$TITLE" python3 - <<'PY' "$template_dir/index.qmd" "$target_dir/index.qmd"
import os
import sys
from pathlib import Path
src = Path(sys.argv[1])
dst = Path(sys.argv[2])
dst.write_text(src.read_text().replace('__TITLE__', os.environ['TITLE']))
PY

echo "Created Quarto presentation scaffold at $target_dir"
