# Casefile — Lite Edition

**Event capture + searchable audit for FiveM (ESX / QBCore).**
Stop scrolling Discord logs — store your server's activity in your own database and search it in seconds.

> This is the free **Lite** edition. **Pro** (auto-flags, case files, evidence export) and
> **Elite** (item provenance, connection web, staff-audit, rewind) are on the **Cfx Marketplace**.

> **Status — early release.** The capture pipeline, search, schema and the `exports.casefile:log`
> API are built and unit-tested. Native ESX/QBCore auto-hooks are being finalized — for now,
> feed events via the `log` export (see below) or your own event bindings. Feedback welcome.

## What Lite does
- Captures money, item, admin, session events (ESX/QBCore auto-detected)
- Stores them in **your own MySQL** — your data never leaves your server
- Instant, indexed **search** by player, category, and time (console command)
- Optional **Discord webhook** mirror for admin actions

## Install
1. Download and unzip this folder into your server's `resources` directory as `casefile`.
2. Import the schema: `mysql your_db < sql/casefile.sql`
3. Add `ensure casefile` to your `server.cfg`.
4. (Optional) set `Config.DiscordWebhook` in `config.lua`.
5. Restart the server.

Requires [`oxmysql`](https://github.com/overextended/oxmysql).

## Feed it events
Any resource, anticheat, or txAdmin bridge can push events:
```lua
exports.casefile:log({
  actor = src, category = 'money', action = 'give_money', target = other, amount = 50000
})
```

## Search (Lite)
From the server console (or an ACE-permitted admin):
```
casefile search <player?> <category?>
```

## Tests
The pure capture/search logic is unit-tested:
```
python3 test/run.py      # needs: pip install lupa
```

## License
See [`LICENSE`](../LICENSE) — Casefile Community License (use on your own server; no resale/redistribution).

Built by **Shima Interactive** · github.com/tomiin
