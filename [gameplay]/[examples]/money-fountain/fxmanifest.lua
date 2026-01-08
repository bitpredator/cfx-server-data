fx_version("bodacious")
game("gta5")
version("2.0.0")
description("An example money system client containing a money fountain.")
repository("https://github.com/citizenfx/cfx-server-data")
author("Cfx.re <root@cfx.re> Refactor Bitpredator")

client_script("client.lua")
server_script("server.lua")

shared_script("mapdata.lua")

dependencies({
    "mapmanager",
    "money",
})

lua53("yes")
