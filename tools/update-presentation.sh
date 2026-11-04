#!/usr/bin/env bash
# Puts the latest presentation on the site: rebuilds the master deck from the chapters on main of the
# private repository and copies it, with the demo videos, to presentation/.
#
#   tools/update-presentation.sh [--publish] [path to the private repository]
#
# Without --publish only the files in presentation/ change; open presentation/index.html and check it.
# With --publish they are committed and pushed; GitHub Pages is live about a minute later.
set -euo pipefail

publish=false
if [ "${1:-}" = "--publish" ]; then publish=true; shift; fi
src="${1:-$HOME/fashionAIble-master}"
site="$(cd "$(dirname "$0")/.." && pwd)"
out="$site/presentation"

# The newest main, without touching the branch or the files of the checkout.
git -C "$src" fetch --quiet origin main
commit="$(git -C "$src" rev-parse --short origin/main)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
git -C "$src" archive origin/main docs/presentation | tar -x -C "$work"

# Python 3.9+; uv first, because "python3" on Windows can be the Microsoft Store placeholder.
if command -v uv >/dev/null 2>&1; then
  run_python() { uv run --no-project python -I "$@"; }
elif python3 -c 'import sys' >/dev/null 2>&1; then
  run_python() { python3 -I "$@"; }
else
  run_python() { py -3 -I "$@"; }
fi
run_python "$work/docs/presentation/master/build-presentation.py"

# The deck links its videos as media/<name>; they live in the chapters' main/media/ folders.
rm -rf "$out"
mkdir -p "$out/media"
cp "$work/docs/presentation/master/fashionaible-presentation.html" "$out/index.html"
videos=0
for f in "$work"/docs/presentation/chapters/*/main/media/*; do
  [ -f "$f" ] || continue
  cp "$f" "$out/media/"
  videos=$((videos + 1))
done
missing=0
for name in $(grep -o 'src="media/[^"]*"' "$out/index.html" | sed 's/src="media\///; s/"$//' | sort -u); do
  [ -f "$out/media/$name" ] || { echo "missing video (the slide shows its placeholder): $name"; missing=$((missing + 1)); }
done
[ "$videos" -gt 0 ] || rmdir "$out/media"
echo "presentation/ from main $commit: $videos video(s) copied, $missing missing"

if $publish; then
  git -C "$site" add -A presentation
  if git -C "$site" diff --cached --quiet; then
    echo "no change, nothing to publish"
  else
    git -C "$site" commit --quiet -m "Update the presentation (main $commit)"
    git -C "$site" push --quiet
    echo "published: https://fashionaible.github.io/fashionaible-app/presentation/"
  fi
fi
