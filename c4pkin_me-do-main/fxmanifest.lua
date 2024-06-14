fx_version 'adamant'
game 'gta5'

author 'c4pkin'
description 'c4pkin Developments'
version '1.0'

shared_script 'config.lua'
client_script 'client.lua'
server_scripts {
 '@mysql-async/lib/MySQL.lua',
 'server.lua'
 }


