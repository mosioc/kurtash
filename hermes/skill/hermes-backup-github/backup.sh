#!/usr/bin/env bash
# Hermes + 9router GitHub backup script
# Usage: bash scripts/backup.sh <owner/repo> [--include-9router] [--public]
#
# Invoke through the `terminal` tool.
set -euo pipefail

REPO="${1:?Usage: backup.sh <owner/repo> [--include-9router] [--public]}"
INCLUDE_9ROUTER=false
VISIBILITY="--private"

for arg in "${@:2}"; do
  case "$arg" in
    --include-9router) INCLUDE_9ROUTER=true ;;
    --public) VISIBILITY="--public" ;;
  esac
done

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
REMOTE_URL="https://github.com/$REPO.git"

echo "=== Hermes Profile Backup ==="

# 1. Export profile
hermes profile export default
TARBALL="$HERMES_HOME/default.tar.gz"

if [ ! -f "$TARBALL" ]; then
  echo "ERROR: Tarball not found at $TARBALL"
  exit 1
fi

# 2. Extract to temp dir
TMPDIR=$(mktemp -d)
tar -xzf "$TARBALL" -C "$TMPDIR"
cd "$TMPDIR/default"

# 3. Init git
git init
git config user.email "hermes-backup@local"
git config user.name "Hermes Backup"
git config http.postBuffer 524288000

# 4. Create repo if needed
gh repo create "$REPO" "$VISIBILITY" --confirm 2>/dev/null || true
git remote add origin "$REMOTE_URL" 2>/dev/null || git remote set-url origin "$REMOTE_URL"

# 5. Pull existing remote history (prevents push rejection)
git pull origin main --allow-unrelated-histories --no-rebase 2>/dev/null || true

# 6. Commit and push
git add -A
git commit -m "Hermes profile backup $(date -u +'%Y-%m-%d %H:%M:%S UTC')" || true
git branch -M main
git push -u origin main

echo "=== Hermes profile pushed ==="

# 7. Optional: 9router backup
if [ "$INCLUDE_9ROUTER" = true ] && [ -d "$HOME/.9router" ]; then
  echo "=== 9router Backup ==="

  TMPDIR2=$(mktemp -d)
  cd "$TMPDIR2"
  git init
  git config user.email "hermes-backup@local"
  git config user.name "Hermes Backup"
  git config http.postBuffer 524288000
  git remote add origin "$REMOTE_URL"
  git pull origin main --allow-unrelated-histories --no-rebase 2>/dev/null || true

  mkdir -p 9router
  rsync -a --exclude='runtime/node_modules' --exclude='logs' --exclude='.git' \
    "$HOME/.9router/" "$TMPDIR2/9router/"

  git add -A
  git commit -m "9router backup $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
  git branch -M main
  git push -u origin main

  rm -rf "$TMPDIR2"
  echo "=== 9router pushed ==="
fi

# 8. Cleanup
rm -rf "$TMPDIR" "$TARBALL"

# 9. Verify
echo "=== Verification ==="
gh repo view "$REPO" --json name,updatedAt,defaultBranchRef

echo "=== Backup complete ==="
