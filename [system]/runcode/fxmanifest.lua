fx_version("cerulean")
game("common")
version("2.0.0")
author("Cfx.re <root@cfx.re> - Refactor Bitpredator")
description(
    "Allows server owners to execute arbitrary server-side or client-side JavaScript/Lua code. *Consider only using this on development servers.")
repository("https://github.com/citizenfx/cfx-server-data")

client_script("runcode_cl.lua")
server_script("runcode_sv.lua")
server_script("runcode_web.lua")

shared_script("runcode_shared.lua")
shared_script("runcode.js")

client_script("runcode_ui.lua")

ui_page("web/nui.html")
files({
    "web/nui.html",
})
