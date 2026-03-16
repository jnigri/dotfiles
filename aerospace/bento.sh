#!/usr/bin/env bash
set -euo pipefail

ws="$(aerospace list-workspaces --focused)"
count="$(aerospace list-windows --workspace "$ws" --count)"

# When the 3rd window appears, group it with its left neighbor => bento-like 2 columns
if [ "$count" -eq 3 ]; then
  aerospace join-with left
  aerospace balance-sizes --workspace "$ws"
  exit 0
fi

# When the 4th window appears, try to make a 2x2:
# move the new window left once (next to the left column), then group it with the left neighbor.
if [ "$count" -eq 4 ]; then
  aerospace move left
  aerospace join-with left
  aerospace balance-sizes --workspace "$ws"
  exit 0
fi
