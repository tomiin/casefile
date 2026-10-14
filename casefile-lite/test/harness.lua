--[[
  Casefile Lite — test/harness.lua
  Proves the pure logic outside the game: the framework->event mappers, plus
  capture + search. Run: python3 test/run.py
]]

local Core = dofile("server/core.lua")
local Q    = dofile("server/queries.lua")

local pass, fail = 0, 0
local function check(name, cond, extra)
  if cond then pass = pass + 1; print("  [PASS] " .. name)
  else fail = fail + 1; print("  [FAIL] " .. name .. "  " .. tostring(extra or "")) end
end

print("\nCasefile Lite — mappers + capture + search\n------------------------------------------")

-- ── mapper: money (QBCore OnMoneyChange) ───────────────────────────────────
local m1 = Core.fromMoneyChange("license:abc", "Jay", "bank", 5000, "remove", "atm")
check("money: category",      m1.category == "money")
check("money: remove->action", m1.action == "remove_money", m1.action)
check("money: amount kept",   m1.amount == 5000)
check("money: account in detail", m1.detail.account == "bank")
check("money: add->give_money", Core.fromMoneyChange("l","n","cash",10,"add").action == "give_money")
check("money: set->set_money",  Core.fromMoneyChange("l","n","cash",10,"set").action == "set_money")

-- ── mapper: item swap (ox_inventory) ───────────────────────────────────────
local i1 = Core.fromItemSwap("license:abc", {
  action = "give", source = 1, fromInventory = 1, toInventory = 2, count = 3,
  fromSlot = { name = "water", metadata = { serial = "WPN123" } },
})
check("item: category",      i1.category == "item")
check("item: give->give_item", i1.action == "give_item", i1.action)
check("item: name in detail", i1.detail.item == "water")
check("item: count kept",    i1.amount == 3)
check("item: serial pulled", i1.serial == "WPN123")
check("item: move->move_item", Core.fromItemSwap("l", { action="move", fromSlot={name="x"} }).action == "move_item")

-- ── mapper: session + admin ────────────────────────────────────────────────
check("session mapper", Core.fromSession("l","Jay","connect",{}).category == "session")
check("admin mapper",   Core.fromAdmin("l","Mod","ban","Tom").action == "ban")

-- ── capture + search end-to-end (store) ────────────────────────────────────
local store = { events = {} }
Core.record(store, Core.fromMoneyChange("license:jay", "Jayden", "bank", 50000, "remove", "transfer"))
Core.record(store, Core.fromMoneyChange("license:mike", "Mike", "cash", 12, "remove", "shop"))
Core.record(store, Core.fromItemSwap("license:jay", { action="give", fromInventory=1, toInventory=2, count=1, fromSlot={name="pistol"} }))
Core.record(store, Core.fromAdmin("license:riot", "RiotMod", "ban", "Tom"))

check("captured 4 events", #store.events == 4, #store.events)
check("search by actor substring", #Q.search(store, { actorLike = "jay" }) == 2)
check("filter category money", #Q.search(store, { category = "money" }) == 2)
check("filter actor+category", #Q.search(store, { actorLike = "jay", category = "item" }) == 1)
check("admin captured", #Q.search(store, { category = "admin" }) == 1)

print(("\nRESULT: %d passed, %d failed\n"):format(pass, fail))
if fail > 0 then os.exit(1) end
