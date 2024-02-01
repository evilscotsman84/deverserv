
fx_version 'cerulean'
games { 'gta5' }

ui_page 'html/index.html'

files {
  'html/*.html',
  'html/*.js',
  'html/*.css',
  'html/*',
}

client_scripts {
  'client.lua',
}

shared_script {
  'config.lua',
}

server_scripts {
  'server.lua',
}

exports {
}
