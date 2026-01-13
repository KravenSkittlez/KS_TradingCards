fx_version 'cerulean'
game 'gta5'

author 'KravynSkitLZ'
description 'KS Trading Cards'
version '1.1.0'

lua54 'yes'

dependencies {
    'oxmysql',
    'ox_inventory'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    'server/ks_debug.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/*.*',
    'html/css/*.*',
    'html/js/*.*',
    'html/img/*.*'
}
