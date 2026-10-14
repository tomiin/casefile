-- Casefile DB-layer test against REAL MariaDB.
-- Simulates Casefile capturing events (same INSERT shape db.lua uses), then
-- runs the exact search queries from db.lua (DB.search WHERE builder).

-- ── capture (mirrors DB.saveEvent -> DB.flush INSERT) ──────────────────────
INSERT INTO casefile_events (ts,actor_id,actor_name,category,action,target_id,amount,serial,detail,source) VALUES
 (1000,'Mike_L',   NULL,'money','give_money','Shop',   12,   NULL,        NULL,'core'),
 (1100,'Jayden_R', NULL,'money','give_money','Mike_L', 50000,NULL,        NULL,'core'),
 (1200,'Jayden_R', NULL,'money','give_money','Dana_P', 50000,NULL,        NULL,'core'),
 (1300,'Jayden_R', NULL,'item', 'spawn_item',NULL,     NULL, 'pistol_9f2',NULL,'core'),
 (1400,'RiotMod',  NULL,'admin','ban',        'TommyG',NULL, NULL,        NULL,'core'),
 (1500,'Jayden_R', NULL,'item', 'give_item',  'BiggsY',NULL, 'pistol_9f2',NULL,'core');

SELECT '=== total events captured (expect 6) ===' AS ' ';
SELECT COUNT(*) AS captured FROM casefile_events;

SELECT '=== search: player LIKE "jay" (expect 4) ===' AS ' ';
SELECT ts, actor_id, action, target_id, amount, serial
FROM casefile_events WHERE 1=1 AND actor_id LIKE '%jay%'
ORDER BY ts DESC LIMIT 200;

SELECT '=== search: category = money (expect 3) ===' AS ' ';
SELECT ts, actor_id, action, target_id, amount
FROM casefile_events WHERE 1=1 AND category='money'
ORDER BY ts DESC LIMIT 200;

SELECT '=== search: "jay" + money (expect 2) ===' AS ' ';
SELECT ts, actor_id, action, target_id, amount
FROM casefile_events WHERE 1=1 AND actor_id LIKE '%jay%' AND category='money'
ORDER BY ts DESC LIMIT 200;

SELECT '=== search: admin actions (expect 1: the ban) ===' AS ' ';
SELECT ts, actor_id, action, target_id
FROM casefile_events WHERE 1=1 AND category='admin'
ORDER BY ts DESC LIMIT 200;
