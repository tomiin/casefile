--[[
  Casefile Lite — capture.lua  (FiveM layer)
  Wires real framework events into the tested core, resolves player identifiers,
  persists to MySQL, and mirrors admin actions to Discord. Uses verified APIs:
    - QBCore money:  QBCore:Server:OnMoneyChange(src, type, amount, op, reason)
    - items:         ox_inventory registerHook('swapItems') + post-hook
    - sessions:      playerConnecting / playerDropped (core FiveM events)
    - universal:     exports.casefile:log(event)  (any script/anticheat/txAdmin)

  NOTE: ESX has no clean money event — ESX money capture goes through the export
  below (call exports.casefile:log from your paycheck/transfer code). Validated
  on a live server (VPS step), not the offline harness, which proves the mappers.
]]

local Core = Casefile.core
local DB   = Casefile.db

local store = { events = {} }   -- lightweight recent-activity mirror

-- framework detection
local FW = Config.Framework
if FW == 'auto' then
  if GetResourceState('es_extended') == 'started' then FW = 'esx'
  elseif GetResourceState('qb-core') == 'started' then FW = 'qbcore'
  else FW = 'standalone' end
end
print(('[casefile] Lite started — framework: %s'):format(FW))

Casefile = rawget(_G, 'Casefile') or {}
function Casefile.discord(msg)
  if not Config.DiscordWebhook or Config.DiscordWebhook == '' then return end
  PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
    json.encode({ content = msg }), { ['Content-Type'] = 'application/json' })
end

-- resolve a stable identifier for a player source (license preferred)
local function pid(src)
  if not src or src == 0 then return 'console' end
  local lic = GetPlayerIdentifierByType and GetPlayerIdentifierByType(src, 'license')
  return lic or ('src:' .. tostring(src))
end
local function pname(src)
  return (src and src ~= 0 and GetPlayerName(src)) or 'console'
end

-- single ingest point
local function ingest(ev)
  ev.source = ev.source or 'core'
  Core.record(store, ev)
  DB.saveEvent(ev)
  if ev.category == 'admin' then
    Casefile.discord(('`%s` %s %s'):format(ev.actor or '?', ev.action or '', ev.target or ''))
  end
  return ev.id
end
exports('log', function(ev) return ingest(ev) end)

-- ── money (QBCore: real event) ─────────────────────────────────────────────
if FW == 'qbcore' then
  AddEventHandler('QBCore:Server:OnMoneyChange', function(src, moneyType, amount, operation, reason)
    ingest(Core.fromMoneyChange(pid(src), pname(src), moneyType, amount, operation, reason))
  end)
end
-- ESX money: no broadcast event — call exports.casefile:log from your money code,
-- e.g. exports.casefile:log({ actor = id, category='money', action='give_money', amount=n })

-- ── items (ox_inventory: real hook + post-hook) ────────────────────────────
if GetResourceState('ox_inventory') == 'started' then
  local hookId = exports.ox_inventory:registerHook('swapItems', nil, {})
  AddEventHandler(hookId, function(success, payload)
    if not success or not payload then return end
    -- capture transfers/gives (moves within one's own inventory are noise)
    if payload.action == 'give' then
      ingest(Core.fromItemSwap(pid(payload.source), payload))
    end
  end)
end

-- ── sessions (core FiveM events) ───────────────────────────────────────────
AddEventHandler('playerConnecting', function(name)
  local src = source
  local lic = (GetPlayerIdentifierByType and GetPlayerIdentifierByType(src, 'license')) or ('src:' .. src)
  ingest(Core.fromSession(lic, name, 'connect', { discord = GetPlayerIdentifierByType and GetPlayerIdentifierByType(src, 'discord') }))
end)
AddEventHandler('playerDropped', function(reason)
  local src = source
  ingest(Core.fromSession(pid(src), pname(src), 'disconnect', { reason = reason }))
end)

-- ── admin (generic; bind your admin menu / txAdmin here) ───────────────────
RegisterNetEvent('casefile:internal:admin', function(action, target)
  local src = source
  ingest(Core.fromAdmin(pid(src), pname(src), action, target and tostring(target) or nil))
end)

-- ── Lite search command (Pro/Elite replace with an in-game NUI panel) ──────
RegisterCommand('casefile', function(src, args)
  if args[1] == 'search' then
    DB.search({ actorLike = args[2], category = args[3] }, function(rows)
      print(('[casefile] %d result(s):'):format(rows and #rows or 0))
      for _, r in ipairs(rows or {}) do
        print(('  %s  %s  %s  %s'):format(os.date('%H:%M', r.ts), r.actor_id, r.action, r.target_id or ''))
      end
    end)
  else
    print('[casefile] usage: casefile search <player?> <category?>')
  end
end, true)  -- restricted to console / ACE-permitted admins
