# 9router Backup Reference

## 9router Directory Layout

Home: `~/.9router/`

| Path | Purpose | Size | Backup? |
|------|---------|------|---------|
| `auth/cli-secret` | CLI auth credentials | 64B | Yes |
| `bin/cloudflared` | Cloudflare tunnel binary | ~30MB | Yes (or re-download) |
| `db/data.sqlite` | Main SQLite database | ~900KB | Yes |
| `db/data.sqlite-wal` | SQLite WAL file | Var | Yes |
| `db/data.sqlite-shm` | SQLite shared memory | Var | Yes |
| `db/backups/` | DB schema migration backups | Var | Yes |
| `jwt-secret` | JWT signing secret | 64B | Yes |
| `machine-id` | Machine identity token | 64B | Yes |
| `mitm/aliases.json` | MITM alias config | ~2B | Yes |
| `runtime/mitm/server.js` | MITM server code | Small | Yes |
| `runtime/package.json` | Node deps manifest | Small | Yes |
| `runtime/package-lock.json` | Lock file | Small | Yes |
| `runtime/node_modules/` | Installed Node deps | ~30MB | **No** — regenerable from package.json |
| `logs/` | Runtime logs | Var | **No** — ephemeral |
| `tunnel/` | Tunnel state | Empty/Var | Optional |

## Excludes

Always exclude from backup:

- `runtime/node_modules/` — 30MB, fully regenerable
- `logs/` — ephemeral runtime logs

## Hermes Integration

9router runs as a local OpenAI-compatible API at `http://localhost:20128/v1`. Configured in Hermes `config.yaml`:

```yaml
model:
  default: 9router-combo
  provider: custom:local-(localhost:20128)
  base_url: http://localhost:20128/v1
  api_key: sk-...
```

This config is part of the Hermes profile and gets backed up automatically by `hermes profile export`.

## Restore

```bash
# Clone the backup repo
git clone https://github.com/mosioc/hermes-backup.git

# Restore 9router
cp -r hermes-backup/9router/* ~/.9router/

# Reinstall node_modules (excluded from backup)
cd ~/.9router/runtime && npm install
```
