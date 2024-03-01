-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version("1.0.3")
author("Cfx.re <root@cfx.re>")
description("Limits the number of players to the amount set by sv_maxclients in your server.cfg.")
repository("https://github.com/bitpredator/cfx-server-data")

client_script("client.lua")
server_script("server.lua")

fx_version("adamant")
games({ "gta5" })
