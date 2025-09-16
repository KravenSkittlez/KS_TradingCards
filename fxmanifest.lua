fx_version 'cerulean'
game 'gta5'

author 'KravenSkittlez'
description 'Trading Card System with Packs, UI & Debug Tools'
version '1.0.0'

lua54 'yes'

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
    'html/style.css',
    'html/script.js',
    'html/images/*.png'
}
