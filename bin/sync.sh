#!/usr/bin/env bash
#
# Copies this hub library into Bonsai plugins' lib/bonsai-hub/ folders.
#
# Usage (from anywhere):
#   bin/sync.sh                      Update every sibling plugin that already bundles the hub.
#   bin/sync.sh bonsai-code-injector Add or update the hub in the named plugin folder(s).
#
# Plugins are expected to sit next to this repo, e.g.
#   Bonsai Plugins/bonsai-hub
#   Bonsai Plugins/bonsai-page-transitions
#
# After syncing, commit lib/bonsai-hub/ in each plugin and include it in the
# release zip.

set -euo pipefail

HUB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGINS_DIR="$(dirname "$HUB_DIR")"
FILES=(bonsai-hub.php includes assets)

if [ "$#" -gt 0 ]; then
	TARGETS=("$@")
else
	TARGETS=()
	for dir in "$PLUGINS_DIR"/*/; do
		name="$(basename "$dir")"
		if [ "$name" != "bonsai-hub" ] && [ -f "$dir/lib/bonsai-hub/bonsai-hub.php" ]; then
			TARGETS+=("$name")
		fi
	done
fi

if [ "${#TARGETS[@]}" -eq 0 ]; then
	echo "No plugins bundle the hub yet. Name one: bin/sync.sh <plugin-folder>"
	exit 1
fi

VERSION="$(grep -m1 -oE "candidate_version = '[^']+'" "$HUB_DIR/bonsai-hub.php" | cut -d"'" -f2)"

for name in "${TARGETS[@]}"; do
	target="$PLUGINS_DIR/$name"

	if [ ! -d "$target" ]; then
		echo "Skipped $name: no such folder in $PLUGINS_DIR"
		continue
	fi

	# Replace wholesale so files removed from the hub don't linger.
	rm -rf "$target/lib/bonsai-hub"
	mkdir -p "$target/lib/bonsai-hub"

	for file in "${FILES[@]}"; do
		cp -R "$HUB_DIR/$file" "$target/lib/bonsai-hub/"
	done

	echo "Synced Bonsai Hub $VERSION into $name"
done
