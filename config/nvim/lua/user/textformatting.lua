-- JSON format + syntax
vim.cmd [[
    function! FormatJson()
        :%!jq .
        set syntax=json
    endfunction

    command FormatJson :call FormatJson()
    command JsonFormat :call FormatJson()
]]

-- XML format + syntax
vim.cmd [[
    function! FormatXml()
        :%!xmllint --format -
        set syntax=xml
    endfunction

    command FormatXml :call FormatXml()
    command XmlFormat :call FormatXml()
]]

-- HTML format + syntax
vim.cmd [[
    function! FormatHtml()
        :%!tidy -q -i --show-errors 0
        set syntax=html
    endfunction

    command FormatHtml :call FormatHtml()
    command HtmlFormat :call FormatHtml()
]]
