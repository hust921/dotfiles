#!/usr/bin/zsh

function jjf ()
{
    local tmpfile
    tmpfile=$(mktemp "/tmp/formattet_XXXXXXXXXXX.json")
    win32yank.exe -o >> "$tmpfile"
    nvim +FormatJson +w "$tmpfile"
}

function xxf ()
{
    local tmpfile
    tmpfile=$(mktemp "/tmp/formattet_XXXXXXXXXXX.xml")
    win32yank.exe -o >> "$tmpfile"
    nvim +FormatXml +w "$tmpfile"
}

function hhf ()
{
    local tmpfile
    tmpfile=$(mktemp "/tmp/formattet_XXXXXXXXXXX.html")
    win32yank.exe -o >> "$tmpfile"
    nvim +FormatHtml +w "$tmpfile"
}
