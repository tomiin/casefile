--[[
  Casefile Lite — test/harness.lua
  Proves capture + search outside the game. Run: python3 test/run.py
]]

local Core = dofile("server/core.lua")
local Q    = dofile("server/queries.lua")

local pass, fail = 0, 0
local function check(name, cond, extra)
  if cond then pass = pass + 1; print("  [PASS] " .. name)
  else fail = fail + 1; print("  [FAIL] " .. name .. "  " .. (extra or "")) end
end

local store = { events = {} }
local function fire(ev) Core.record(store, ev) end

local t0 = os.time({ year = 2026, month = 1, day = 5, hour = 14, min = 0, sec = 0 })
fire{ ts = t0,       actor = "Mike_L",  category = "money", action = "give_money", target = "Shop", amount = 12 }
fire{ ts = t0 + 60,  actor = "Jayden_R",category = "money", action = "give_money", target = "Mike_L", amount = 50000 }
fire{ ts = t0 + 120, actor = "Jayden_R",category = "item",  action = "spawn_item", serial = "pistol_9f2" }
fire{ ts = t0 + 180, actor = "RiotMod", category = "admin", action = "ban", target = "TommyG" }

print("\nCasefile Lite — capture + search\n--------------------------------")
check("captured 4 events", #store.events == 4, "got " .. #store.events)
check("search by exact player", #Q.search(store, { actor = "Jayden_R" }) == 2)
check("search substring 'jay'", #Q.search(store, { actorLike = "jay" }) == 2)
check("filter by category money", #Q.search(store, { category = "money" }) == 2)
check("filter player + category", #Q.search(store, { actor = "Jayden_R", category = "item" }) == 1)
check("admin search finds ban", #Q.search(store, { category = "admin" }) == 1)
check("empty search returns all", #Q.search(store, {}) == 4)

print(("\nRESULT: %d passed, %d failed\n"):format(pass, fail))
if fail > 0 then os.exit(1) end
