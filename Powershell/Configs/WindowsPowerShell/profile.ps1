# ================= Enviroment Variables =================


# ================= Modules =================
# oh-my-posh & posh git 
Import-Module posh-git
Import-Module oh-my-posh
Import-Module posh-cargo
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

function Audio-Download
{
    $output = '"' + $(Get-ScriptDirectory) + '\%(title)s.%(ext)s"'
    $ariapath = '"' + $(Get-Command aria2c | % { $_.Source }) + '"'
    youtube-dl --prefer-ffmpeg --external-downloader $($ariapath) -o $output --extract-audio --audio-format mp3 $args
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

# SSH setup
Set-Alias -name 'ssh-agent' "$env:ProgramFiles\git\usr\bin\ssh-agent.exe"
Set-Alias -name 'ssh-add' "$env:ProgramFiles\git\usr\bin\ssh-add.exe"
ssh-agent

# NeoVim setup
Set-Alias -name 'nvim' -Value 'Start-Vi'
Set-Alias -name 'vim' -Value 'Start-Vi'
Set-Alias -name 'vi' -Value 'Start-Vi'

# aliases
function nixls { Get-ChildItem -Hidden }
New-Alias ll nixls
New-Alias la nixls

function Start-Vi ($firstArg)
{
    wsl nvim (wsl wslpath "'$firstArg'")
}
