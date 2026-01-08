fx_version 'cerulean'
games { 'gta5' }
version '2.0.0'
author 'Cfx.re <root@cfx.re> - Refactor Bitpredator'
description 'Provides baseline chat functionality using a NUI-based interface.'
repository 'https://github.com/citizenfx/cfx-server-data'

ui_page 'dist/ui.html'

client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
  'dist/ui.html',
  'dist/index.css',
  'html/vendor/*.css',
  'html/vendor/fonts/*.woff2',
}

dependencies {
  'yarn',
  'webpack'
}

webpack_config 'webpack.config.js'
