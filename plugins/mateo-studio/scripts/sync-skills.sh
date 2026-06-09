#!/usr/bin/env bash
# sync-skills.sh — refresh the vendored design skills from their upstream repos.
#
# The plugin vendors third-party skills (so a fresh machine needs nothing installed).
# Vendored copies are a snapshot; run this to pull the latest upstream versions.
# Invoked by the /mateo-sync command, or manually:  bash scripts/sync-skills.sh
#
# To add a skill, append a line to SOURCES below:
#   "<dest-relative-to-skills-lib>|<github-owner/repo>|<subpath-in-repo>"
# Use "." as subpath when the repo root IS the skill folder.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_LIB="${PLUGIN_ROOT}/skills-lib"

# dest | repo | subpath-in-repo
SOURCES=(
  "frontend/ui-ux-pro-max|nextlevelbuilder/ui-ux-pro-max-skill|."
  "frontend/impeccable|pbakaus/impeccable|."
  "frontend/taste-skill|leonxlnx/taste-skill|."
)

command -v git >/dev/null 2>&1 || { echo "sync-skills: git not found on PATH." >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

updated=0; failed=0
for entry in "${SOURCES[@]}"; do
  IFS='|' read -r dest repo subpath <<< "$entry"
  echo "→ ${dest}  (from ${repo})"
  clone_dir="${TMP}/$(echo "$repo" | tr '/' '_')"
  if git clone --depth 1 "https://github.com/${repo}.git" "$clone_dir" >/dev/null 2>&1; then
    src="${clone_dir}/${subpath}"
    if [ -e "$src/SKILL.md" ] || [ -d "$src" ]; then
      mkdir -p "${SKILLS_LIB}/${dest}"
      rsync -a --delete --exclude='.git' "$src/" "${SKILLS_LIB}/${dest}/" 2>/dev/null \
        || cp -rf "$src/." "${SKILLS_LIB}/${dest}/"
      echo "  ✓ updated"
      updated=$((updated+1))
    else
      echo "  ✗ subpath '${subpath}' not found in repo" >&2
      failed=$((failed+1))
    fi
  else
    echo "  ✗ clone failed (private/renamed repo?)" >&2
    failed=$((failed+1))
  fi
done

echo ""
echo "sync-skills done: ${updated} updated, ${failed} failed."
echo "To distribute: commit + push the mateo-studio repo, then others run /plugin update."
