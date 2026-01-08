fx_version("cerulean")
game("common")
version("2.0.0")
author("Cfx.re <root@cfx.re> - Refactor Bitpredator")
description("A GTA Online-styled theme for the chat resource.")
repository("https://github.com/citizenfx/cfx-server-data")

file("style.css")
file("shadow.js")

chat_theme("gtao")({
    styleSheet = "style.css",
    script = "shadow.js",
    msgTemplates = {
        default = "<b>{0}</b><span>{1}</span>",
    },
})
