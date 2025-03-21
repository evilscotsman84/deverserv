fx_version 'cerulean'
game 'gta5'

version '1.0.0'

shared_scripts {
	'config.lua',
	-- '@qb-houses/config.lua',
	'@qb-apartments/config.lua'
}

client_script 'client.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/reset.css',
	'html/*.png',
}

lua54 'yes'
dependency '/assetpacks'server_scripts { '@mysql-async/lib/MySQL.lua' }