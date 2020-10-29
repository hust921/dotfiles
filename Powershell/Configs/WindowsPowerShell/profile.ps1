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
function grv {git remote -v $args}
function gba {git branch -avv $args}
function grh { if ($(Read-Host -Prompt "Are you sure you want to reset (mixed)? [y/N]:") -match "[yY]") { git reset HEAD $args } }
function grhh { if ($(Read-Host -Prompt "Are you sure you want to reset ( HARD )? [y/N]:") -match "[yY]") { git reset --hard HEAD $args } }

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
Set-Alias ls Get-ChildItem
Set-Alias la Get-ChildItem
Set-Alias ll Get-ChildItem
Set-Alias which Get-Command
Set-Alias powershell "C:\Program Files\PowerShell\6\pwsh.exe"

function Start-Vi ($firstArg)
{
    wsl nvim (wsl wslpath "'$firstArg'")
}
