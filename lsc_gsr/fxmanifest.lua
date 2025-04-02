fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'Kentain - LSC'
description 'GSR'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

