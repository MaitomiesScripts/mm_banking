fx_version 'cerulean'
games { 'gta5' }
lua54 "yes"

author 'MM Scripts'
description ''
version '1.0.0'

ui_page "Html/index.html"

files {
    "Html/logo.png",
    "Html/index.html",
    "Html/style.css",
    "Html/main.js",
}

shared_scripts {
    '@mysql-async/lib/MySQL.lua',
    "@ox_lib/init.lua",
    "Config.lua"
}

client_scripts {
    "Client/cl_*.lua"
}

server_scripts {
    "Server/sv_*.lua"
}