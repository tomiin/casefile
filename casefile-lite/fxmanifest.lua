fx_version 'cerulean'
game 'gta5'

name 'casefile'
author 'Shima Interactive (github.com/tomiin)'
description 'Casefile Lite — event capture + searchable audit for FiveM (ESX/QBCore).'
version '1.0.0'

dependency 'oxmysql'

server_scripts {
  '@oxmysql/lib/MySQL.lua',  -- required to use the MySQL.* API (per oxmysql docs)
  'config.lua',
  'server/core.lua',      -- capture / normalize (pure, unit-tested)
  'server/queries.lua',   -- search
  'server/db.lua',        -- oxmysql adapter
  'server/capture.lua',   -- ESX/QBCore hooks + /casefile search command
}
