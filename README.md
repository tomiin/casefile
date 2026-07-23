# ◆ Casefile — Lite Edition

**The server integrity suite for FiveM. Stop scrolling Discord logs — start investigating.**

Casefile turns your server's flood of events into something you can actually search.
Money, items, admin actions, and connections — captured, stored, and searchable in
seconds instead of scrolled through forever.

> This is the **free Lite Edition**. The full **Pro** and **Elite** editions — with the
> auto-flag watchtower, auto-built case files, item provenance tracing, the connection
> web, staff-abuse auditing, and economy rewind — are on the **[Cfx Marketplace »](https://marketplace.cfx.re/)**

---

## ▶ See it in action

Live interactive demos: **[open the landing page](https://tomiin.github.io/casefile/)**

| Demo | What it shows |
|------|---------------|
| Case file | An investigation dossier auto-assembled on a player |
| Watchtower | Detection rules that trip on their own + AI rule authoring |
| Provenance | Tracing a duped item back to its exact source |
| Connections | Interactive red-string laundering-ring board |

---

## What the Lite Edition does (free)

- Captures core events (money, items, admin actions, sessions) on **ESX** and **QBCore**
- Stores them in **your own database** — your data never leaves your server
- In-game **search panel**: filter by player, category, and time range
- Optional **Discord webhook** mirror for live alerts

## What the paid editions add

| | Lite (free) | Pro | Elite |
|---|:---:|:---:|:---:|
| Event capture + search | ✅ | ✅ | ✅ |
| Discord mirror | ✅ | ✅ | ✅ |
| Auto-flags (watchtower) | | ✅ | ✅ |
| Auto-built case files + evidence export | | ✅ | ✅ |
| AI plain-English rule authoring | | ✅ | ✅ |
| Item provenance / dupe-source tracing | | | ✅ |
| Connection web / ring detection | | | ✅ |
| Staff-abuse auditing (watch the watchers) | | | ✅ |
| Economy rewind / rollback | | | ✅ |

**Pro $34.99 · Elite $74.99 — one-time, buy once, no monthly fee.**
**[Get Pro / Elite on the Cfx Marketplace »](https://marketplace.cfx.re/)**

---

## Works alongside your stack

Casefile is **not** an anticheat and **not** a replacement for txAdmin. It sits on top of
them and answers the question they can't: *what actually happened, and who did it.*
It can even ingest events from your anticheat and txAdmin so everything lands in one
searchable place.

---

## Install (Lite)

1. Download this repo (**Code → Download ZIP**) and unzip into your server's `resources` folder.
2. Import `casefile.sql` into your database (creates the log tables).
3. Add `ensure casefile` to your `server.cfg`.
4. (Optional) set your Discord webhook in `config.lua`.
5. Restart the server.

Requires `oxmysql`. Auto-detects ESX / QBCore.

---

## License

Casefile Lite is released under the **Casefile Community License** — see [`LICENSE`](./LICENSE).
In short: **use it on your own server (even a commercial one), but you may not
redistribute, resell, or use it to build a competing product.** The name "Casefile"
and the paid editions are reserved.

_This license text is a practical starting point, not legal advice — have it reviewed
before you rely on it commercially._

---

## Repo structure — how the code is protected

This **public** repository contains **only the Lite Edition** — deliberately limited to
capture + search. The valuable features live elsewhere:

```
casefile/                  ← THIS public repo (Lite only)
├── README.md
├── LICENSE
├── fxmanifest.lua
├── config.lua
├── casefile.sql
└── lite/                  ← capture hooks + search panel only

casefile-full/  (PRIVATE)  ← never published; your real source
                             watchtower, provenance, connection web,
                             case engine, rewind, staff-audit

Cfx Marketplace listing     ← paid build, shipped ENCRYPTED via
                             Asset Escrow (buyers run it, can't read it)
```

Rule of thumb: **if a feature is worth paying for, it never touches this public repo.**
The Lite Edition is marketing — a working taste that funnels to the locked paid build.

---

Built by **Shima Interactive** · [github.com/tomiin](https://github.com/tomiin)
