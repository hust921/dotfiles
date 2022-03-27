local alpha = require('alpha')
local startify = require('alpha.themes.startify')

startify.section.header.val = {
        [[                                   __                ]],
        [[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }
    startify.section.top_buttons.val = {
        startify.button( "e", "   New file" , ":ene <BAR> startinsert <CR>"),
        startify.button( "cc", "  Clipboard OPEN" , ':enew<CR>:normal "+p<CR>'),
        startify.button( "cj", "  Clipboard JSON" , ':enew<CR>:normal "+p<CR>:FormatJson<CR>'),
        startify.button( "cx", "謹 Clipboard XML" , ':enew<CR>:normal "+p<CR>:FormatXml<CR>'),
        startify.button( "ch", "  Clipboard HTML" , ':enew<CR>:normal "+p<CR>:FormatHtml<CR>'),
    }

alpha.setup(startify.opts)
