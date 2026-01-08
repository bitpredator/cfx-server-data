fx_version("cerulean")
games({ "gta5" })
version("2.0.0")
author("Cfx.re <root@cfx.re> - Refactor Bitpredator")
description("Limits the number of players to the amount set by sv_maxclients in your server.cfg.")
repository("https://github.com/bitpredator/cfx-server-data")

client_script("client.lua")
server_script("server.lua")
