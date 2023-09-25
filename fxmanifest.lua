fx_version 'adamant'
game 'gta5'
description 'BBV bombs'
version '1.0.0'


client_scripts {
	'wrapper/cl_wrapper.lua',
	'wrapper/cl_wp_callback.lua',
	'client/main.lua',
	'client/minigame.lua',
}

server_scripts {
	'wrapper/sv_wrapper.lua',
	'wrapper/sv_wp_callback.lua',
	'server/main.lua',
	'server/items.lua',
}

shared_scripts {
	'config.lua',
}

ui_page {
	'html/index.html'
}
  
files {
	'html/index.html',
	'html/style.css',
	'html/app.js',
	'html/beep.ogg'
}

files {
    'stream/prop_explosive_c4.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/prop_explosive_c4.ytyp'

lua54 'yes'