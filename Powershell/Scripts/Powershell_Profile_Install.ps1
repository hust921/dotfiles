# Check administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output "Not running as administrator.."
    Exit 1
}

# == LINK FIRST ==
#
# Install Profile.ps1
# Create link to Configs\WindowsPowerShell directory
function CreateLink($symlink, $targetFile) { cmd /c mklink /J $($symlink) $($targetFile) }
CreateLink("$($HOME)\Documents\WindowsPowerShell", "$(pwd)\Configs\WindowsPowerShell")

# =============== Install modules ===============

# Update package provider
Install-PackageProvider -Name NuGet -Force

# Install oh-my-posh modules
Install-Module posh-git -Force
Install-Module oh-my-posh -Force

# Install Cargo (rust completion)
Install-Module posh-cargo -Scope CurrentUser -AllowClobber -Force

# Install PSFzf modules
Install-Module PSFzf -Force
