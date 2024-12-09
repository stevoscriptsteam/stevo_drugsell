fx_version 'cerulean'
game 'gta5'


author 'StevoScripts | steve'
description 'Most advanced free drug selling resource'
version '1.0.0'

shared_scripts {
  'config.lua',
  '@ox_lib/init.lua'
}

files {
  'locales/*.json'
}

client_scripts {
  'resource/client.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
	'resource/server.lua'
}

dependencies {
  'ox_lib',
  'oxmysql',
  'stevo_lib'
}

lua54 'yes'
