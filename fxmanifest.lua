fx_version "adamant"

game "gta5"

client_script { 
"main/client.lua"
}

server_script {
"main/server.lua"
} 

shared_script "main/shared.lua"


ui_page "html/index.html"
files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css',
    'html/img/*.png',
    'html/img/*.gif',
    'html/img/*.jpg',
    'html/style.css',
}
