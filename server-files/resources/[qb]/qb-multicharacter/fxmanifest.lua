fx_version "adamant"
game "gta5"
lua54 'yes'

escrow_ignore {
    'shared.lua',
}

client_script "client.lua"
server_script {
    "server.lua",
    "@oxmysql/lib/MySQL.lua"
}
shared_script "shared.lua"
ui_page 'ui/index.html'

files {
    'ui/*.html',
    'ui/*.js',
    'ui/*.css',
    'ui/images/*.png',
    'addons/peds.meta'
}

data_file 'PED_METADATA_FILE' 'addons/peds.meta'

dependencies {
    'qb-core'
}