--[[
  Casefile Lite — queries.lua
  The read side: filtered search over the audit log. Pure Lua; the FiveM
  db.lua adapter runs the same shape as an indexed SQL query.
]]

local Q = {}

-- filters: { actor, actorLike, category, since, until_ }
function Q.search(store, f)
  f = f or {}
  local out = {}
  for _, e in ipairs(store.events) do
    local ok = true
    if f.actor    and e.actor ~= f.actor then ok = false end
    if f.actorLike and not string.find(string.lower(e.actor or ""), string.lower(f.actorLike), 1, true) then ok = false end
    if f.category and e.category ~= f.category then ok = false end
    if f.since    and e.ts < f.since  then ok = false end
    if f.until_   and e.ts > f.until_ then ok = false end
    if ok then out[#out + 1] = e end
  end
  return out
end

Casefile = rawget(_G, 'Casefile') or {}
Casefile.queries = Q
return Q
