--[[
  Casefile Lite — core.lua
  DB-agnostic capture + the pure mappers that turn framework events into
  normalised Casefile events. No FiveM natives here, so it's unit-tested in
  /test and reused unchanged by capture.lua.

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

-- ── event mappers (pure) ───────────────────────────────────────────────────
-- QBCore money change -> Casefile event.
-- (From verified event: QBCore:Server:OnMoneyChange(src, moneyType, amount, operation, reason))
local MONEY_ACTION = { add = "give_money", remove = "remove_money", set = "set_money" }
function Core.fromMoneyChange(actorId, actorName, moneyType, amount, operation, reason)
  return {
    actor = actorId, actor_name = actorName, category = "money",
    action = MONEY_ACTION[operation] or "give_money",
    amount = amount,
    detail = { account = moneyType, reason = reason, op = operation },
  }
end

-- ox_inventory swapItems payload -> Casefile event (item move / give).
-- (From verified hook payload: action, fromSlot{name,metadata}, toInventory, count)
function Core.fromItemSwap(actorId, payload)
  local slot = payload.fromSlot or {}
  local meta = slot.metadata or {}
  return {
    actor = actorId, category = "item",
    action = (payload.action == "give") and "give_item" or "move_item",
    target = payload.toInventory ~= nil and tostring(payload.toInventory) or nil,
    serial = meta.serial,                       -- weapons etc. carry a real serial
    amount = payload.count,
    detail = { item = slot.name, from = tostring(payload.fromInventory),
               to = tostring(payload.toInventory), kind = payload.action },
  }
end

-- Session connect/disconnect -> Casefile event.
function Core.fromSession(actorId, actorName, action, detail)
  return { actor = actorId, actor_name = actorName, category = "session", action = action, detail = detail }
end

-- Generic admin action -> Casefile event.
function Core.fromAdmin(actorId, actorName, action, target, detail)
  return { actor = actorId, actor_name = actorName, category = "admin",
           action = action, target = target, detail = detail }
end

-- FiveM has no require(): expose on a shared global (scripts share one env,
-- loaded in fxmanifest order). The return is for the offline test harness.
Casefile = rawget(_G, 'Casefile') or {}
Casefile.core = Core
return Core
