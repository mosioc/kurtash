---
name: hermes-github-backup
description: "Backup Hermes + 9router state to a GitHub repository."
version: 0.2.0
author: Mehdi Maleki, Hermes Agent
platforms: [macos, linux]
metadata:
  hermes:
    tags: [Hermes, Backup, GitHub, 9router, Cron]
    homepage: https://github.com/NousResearch/hermes-agent
---

# Hermes GitHub Backup

Back up a Hermes profile (config, skills, sessions, cron, plugins) and optional 9router state (`~/.9router/`) to a GitHub repository. Creates the repo on first run if it doesn't exist, then commits and pushes. Designed to run manually or as a cron job.

Does NOT back up: Hermes source code, logs, or `runtime/node_modules/` for 9router.

## When to Use

- "backup hermes to github"
- "backup hermes and 9router"
- "create github backup for hermes profile"
- "schedule hermes backups to github"
- "migrate hermes profile to new machine via github"

## Prerequisites

- `gh` CLI installed and authenticated (`gh auth login`)
- Git installed
- Hermes CLI available (`hermes` in PATH)
- A GitHub account (repo will be created under your account)
- Optional: `HERMES_HOME` env var set if using non-default location
- **9router** (optional): If using local 9router at `http://localhost:20128/v1`, the `config.yaml` provider entry is backed up as part of the Hermes profile. 9router data (`~/.9router/`) can be backed up alongside.

## How to Run

Manual one-shot via `terminal` tool:

```
hermes chat -q "backup my hermes profile to github repo mosioc/hermes-backup"
```

Or invoke the backup script directly through the `terminal` tool:

```
bash scripts/backup.sh mosioc/hermes-backup --include-9router
```

As a cron job (every 3 days):

```
hermes cron create "every 3d" \
  --prompt "backup hermes profile and 9router to github repo mosioc/hermes-backup" \
  --skills ["hermes-github-backup"] \
  --name "hermes-9router-backup"
```

## Quick Reference

| Command                                            | Purpose                          |
| -------------------------------------------------- | -------------------------------- |
| `hermes profile export <name>`                     | Export profile to tar.gz         |
| `gh repo create <owner>/<repo> --private`          | Create private GitHub repo       |
| `git pull origin main --allow-unrelated-histories` | Merge remote history before push |
| `git config http.postBuffer 524288000`             | Fix HTTP 400 on large pushes     |
| `git push -u origin main`                          | Push to GitHub                   |

## Procedure

1. **Parse the target repo** from the prompt (format: `owner/repo` or `repo` for current user).
2. **Export the Hermes profile** using `hermes profile export default` via the `terminal` tool.
3. **Extract the archive** to a temp directory. The tarball is named `default.tar.gz` (not `default_profile_*.tar.gz`) and lands in `$HERMES_HOME` (typically `~/.hermes/`).
4. **Init git** in the temp dir, set remote to the target repo.
5. **Pull remote history** with `--allow-unrelated-histories` to avoid push rejection on existing repos.
6. **Set `http.postBuffer`** to `524288000` to prevent HTTP 400 on large profile pushes.
7. **Create the GitHub repo** via `gh repo create` if it doesn't exist (private by default).
8. **Add, commit, and push** all profile files.
9. **Optional: Back up 9router** — rsync `~/.9router/` excluding `runtime/node_modules` and `logs`, commit and push to same repo under `9router/` prefix.
10. **Clean up** temp directory and tarball.

### Hermes Profile Backup Commands

```bash
# 1. Export profile
hermes profile export default

# 2. Find the tarball (lands in $HERMES_HOME, NOT ~/)
TARBALL="$HOME/.hermes/default.tar.gz"

# 3. Extract to temp dir
TMPDIR=$(mktemp -d)
tar -xzf "$TARBALL" -C "$TMPDIR"

# 4. Init git
cd "$TMPDIR/default"
git init
git config user.email "hermes-backup@local"
git config user.name "Hermes Backup"
git config http.postBuffer 524288000

# 5. Create repo if needed
REPO="mosioc/hermes-backup"
gh repo create "$REPO" --private --confirm 2>/dev/null || true
git remote add origin "https://github.com/$REPO.git" 2>/dev/null || git remote set-url origin "https://github.com/$REPO.git"

# 6. Pull existing remote history (CRITICAL — prevents push rejection)
git pull origin main --allow-unrelated-histories --no-rebase 2>/dev/null || true

# 7. Commit and push
git add -A
git commit -m "Hermes profile backup $(date -u +'%Y-%m-%d %H:%M:%S UTC')" || true
git branch -M main
git push -u origin main

# 8. Cleanup
rm -rf "$TMPDIR" "$TARBALL"
```

### 9router Backup Commands

```bash
# rsync 9router data (exclude node_modules and logs)
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git init
git config user.email "hermes-backup@local"
git config user.name "Hermes Backup"
git config http.postBuffer 524288000
git remote add origin "https://github.com/$REPO.git"
git pull origin main --allow-unrelated-histories --no-rebase 2>/dev/null || true

mkdir -p 9router
rsync -a --exclude='runtime/node_modules' --exclude='logs' --exclude='.git' \
  "$HOME/.9router/" "$TMPDIR/9router/"

git add -A
git commit -m "9router backup $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
git branch -M main
git push -u origin main
rm -rf "$TMPDIR"
```

## Pitfalls

- **Push rejected on existing repo** — MUST `git pull origin main --allow-unrelated-histories --no-rebase` before pushing. Without this, the first push to a repo that already has commits will fail with `! [rejected] main -> main (fetch first)`.
- **HTTP 400 on large pushes** — set `git config http.postBuffer 524288000` before pushing. The Hermes profile export contains 500+ files / 166K+ lines and GitHub's default buffer is too small.
- **Tarball path is `~/.hermes/default.tar.gz`** — NOT `~/default_profile_*.tar.gz`. The `hermes profile export` command writes to `$HERMES_HOME/`, not the home directory.
- **Private repo by default** — pass `--public` to `gh repo create` if you want public.
- **`gh` must have `repo` scope** — run `gh auth refresh -h github.com -s repo` if push fails.
- **Large profiles** — `hermes profile export` includes `sessions/` which can be large. Consider `hermes sessions prune --older-than 30` before backup.
- **9router `node_modules`** — always exclude `runtime/node_modules/` from 9router backup (30MB, fully regenerable from `package.json`).
- **Concurrent pushes** — no conflict handling. If two backups run simultaneously, one will fail. Stagger cron schedules if backing up multiple components.

## Verification

```bash
gh repo view mosioc/hermes-backup --json name,updatedAt,defaultBranchRef
# updatedAt should show today's date; defaultBranchRef should be "main"
```
