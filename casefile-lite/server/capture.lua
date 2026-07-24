--[[
  Casefile Lite — capture.lua  (FiveM layer)
  Wires framework/server events into the tested core, persists to MySQL, and
  mirrors to Discord. Any script/anticheat/txAdmin bridge can push events via
  exports.casefile:log(event).
]]

local Core = Casefile.core
local Q    = Casefile.queries
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

-- the single ingest point everything flows through
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

-- example hooks (extend per framework / your own events)
if FW == 'esx' then
  RegisterNetEvent('casefile:internal:money', function(target, amount)
    ingest{ actor = tostring(source), category = 'money', action = 'give_money',
            target = tostring(target), amount = amount }
  end)
end
RegisterNetEvent('casefile:internal:admin', function(action, target)
  ingest{ actor = tostring(source), category = 'admin', action = action,
          target = target and tostring(target) or nil }
end)

-- Lite search command (Pro/Elite replace this with an in-game NUI panel)
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
