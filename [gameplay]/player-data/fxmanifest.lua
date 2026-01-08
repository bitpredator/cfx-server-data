-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.
fx_version 'cerulean'
game 'common'
version '2.0.0'
description 'A basic resource for storing player identifiers.'
author 'Cfx.re <root@cfx.re> - Refactor Bitpredator'
repository 'https://github.com/citizenfx/cfx-server-data'

server_script 'server.lua'

provides {
    'cfx.re/playerData.v1alpha1'
}
