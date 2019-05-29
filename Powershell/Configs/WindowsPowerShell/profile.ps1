# ================= Enviroment Variables =================


# ================= Modules =================
# oh-my-posh & posh git 
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Agnoster

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# fzf
Import-Module PSFzf -ArgumentList 'Ctrl+t', 'Ctrl+r'

# ================= Aliases =================
# Chrome
Set-Alias chrome "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

# Git (partially from oh-my-zsh)
function glol {git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit $args}
function glola {git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit --all $args}
function gst {git status $args}
function gss {git status -s $args}
function gcv {git commit -v $args}
function gco {git checkout $args}
function gcd {git checkout develop $args}
function glg {git log --stat --graph $args}
function gd  {git diff $args}
function gaa {git add --all $args}

# ================= Video-Download Functions =================
# Preset for youtube-dl for ffmpeg and fast download
function Video-Download
{
    $output = '"' + $(Get-ScriptDirectory) + '\%(title)s.%(ext)s"'
    $ariapath = '"' + $(Get-Command aria2c | % { $_.Source }) + '"'
    youtube-dl --format "best" --prefer-ffmpeg --external-downloader $($ariapath) -o $output $args
}

# Gets the directory from where a script is located
# Commands using script will default have PWD %windows%\system32
function Get-ScriptDirectory
{
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value;
    if($Invocation.PSScriptRoot)
    {
        $Invocation.PSScriptRoot;
    }
    Elseif($Invocation.MyCommand.Path)
    {
        Split-Path $Invocation.MyCommand.Path
    }
    else
    {
        $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"));
    }
}
