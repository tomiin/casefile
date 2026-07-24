--[[
  Casefile Lite — db.lua  (FiveM layer)
  oxmysql adapter. Batches event inserts off the game thread (protects FPS)
  and serves the indexed search. Validated on a live server (not the offline
  harness, which proves the pure logic in core/queries).
]]

local DB = {}
local queue = {}

function DB.saveEvent(ev)
  queue[#queue + 1] = ev
  if #queue >= (Config.FlushEvery or 25) then DB.flush() end
end

function DB.flush()
  if #queue == 0 then return end
  local params = {}
  for _, e in ipairs(queue) do
    params[#params + 1] = { e.ts, e.actor, e.actor_name, e.category, e.action,
                            e.target, e.amount, e.serial,
                            e.detail and json.encode(e.detail) or nil, e.source or 'core' }
  end
  MySQL.prepare('INSERT INTO casefile_events '
    .. '(ts,actor_id,actor_name,category,action,target_id,amount,serial,detail,source) '
    .. 'VALUES (?,?,?,?,?,?,?,?,?,?)', params)
  queue = {}
end

-- Indexed, instant search — the thing a Discord log channel can't do.
function DB.search(f, cb)
  local where, params = { '1=1' }, {}
  if f.actorLike then where[#where+1] = 'actor_id LIKE ?'; params[#params+1] = '%' .. f.actorLike .. '%' end
  if f.category  then where[#where+1] = 'category = ?';    params[#params+1] = f.category end
  if f.since     then where[#where+1] = 'ts >= ?';         params[#params+1] = f.since end
  if f.until_    then where[#where+1] = 'ts <= ?';         params[#params+1] = f.until_ end
  MySQL.query('SELECT * FROM casefile_events WHERE ' .. table.concat(where, ' AND ')
    .. ' ORDER BY ts DESC LIMIT 200', params, cb)
end

-- Timed flush safety-net so nothing lingers unwritten.
CreateThread(function()
  while true do Wait(Config.FlushEveryMs or 4000); DB.flush() end
end)

Casefile = rawget(_G, 'Casefile') or {}
Casefile.db = DB
return DB
