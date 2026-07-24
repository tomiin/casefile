--[[
  Casefile Lite — core.lua
  DB-agnostic capture. Pure Lua (no FiveM natives) so it's unit-tested in
  /test and reused unchanged by the FiveM adapter (capture.lua).

  Lite records events to a flat, indexed audit log. (Asset/custody tracking,
  the rules engine and case assembly live in Pro/Elite.)

  store = { events = {} }
]]

local Core = {}

function Core.record(store, ev)
  ev.ts     = ev.ts or os.time()
  ev.id     = #store.events + 1
  ev.source = ev.source or "core"
  store.events[ev.id] = ev
  return ev
end

-- FiveM has no require(): expose on a shared global (scripts share one env,
-- loaded in fxmanifest order). The return is for the offline test harness.
Casefile = rawget(_G, 'Casefile') or {}
Casefile.core = Core
return Core
