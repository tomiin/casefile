# Casefile — Lite Edition

**Event capture + searchable audit for FiveM (ESX / QBCore).**
Stop scrolling Discord logs — store your server's activity in your own database and search it in seconds.

> This is the free **Lite** edition. **Pro** (auto-flags, case files, evidence export) and
> **Elite** (item provenance, connection web, staff-audit, rewind) are on the **Cfx Marketplace**.

> **Status — beta.** Verified on a live FiveM server (Linux, MySQL 8.4 over SSL): events sent through
> `exports.casefile:log` are batched into MySQL and found again by `casefile search`, and data survives
> restarts. Auto-capture is also wired for **QBCore money** (`OnMoneyChange`), **item gives**
> (ox_inventory hook) and **sessions** (connect/disconnect), but those hooks are **not yet tested on a
> live server** — they're built against the documented APIs. **ESX money** has no broadcast event, so
> capture it via the `log` export from your money code. Bug reports welcome.

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
