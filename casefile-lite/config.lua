Config = {}

-- 'auto' detects ESX or QBCore; force it if auto-detect guesses wrong.
Config.Framework = 'auto'          -- 'auto' | 'esx' | 'qbcore'

-- Optional Discord webhook mirror. Leave empty to disable.
Config.DiscordWebhook = ''

-- Keep events for N days (0 = keep forever). Your database, your data.
Config.RetentionDays = 0

-- Batch writes to protect server FPS: flush on N events or M milliseconds.
Config.FlushEvery   = 25
Config.FlushEveryMs = 4000

-- ── Upgrade ─────────────────────────────────────────────────────────────
-- Auto-flags (watchtower), auto-built case files, item provenance / dupe
-- tracing, the connection web, staff-abuse auditing and economy rewind are
-- in Casefile Pro & Elite on the Cfx Marketplace.
