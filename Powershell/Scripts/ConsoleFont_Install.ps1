# Check administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output "Not running as administrator.."
    Exit 1
}

# ============== REQUIRES RESTART! ==============


#
# - Adding fonts with Powershell: 
#   https://blogs.technet.microsoft.com/deploymentguys/2010/12/04/adding-and-removing-fonts-with-windows-powershell/
#
# - Deja Vu Sans Mono (Nerd Fonts, hassosaurus fork):
#   https://github.com/haasosaurus/nerd-fonts/blob/17247fd92fdfe9a2ef9cc6871045177f7c5cf13b/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf
#

# ====== Install using Add-Font.ps1 (microsoft) ======
PowerShell -ExecutionPolicy Bypass -File Scripts\Add-Font.ps1 "Assets\DejaVu Sans Mono Nerd Font Complete Mono Windows Compatible.ttf"

# ====== Add Font to cmd/powershell ======
$TrueTypeFontPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\"
$TrueTypeFontName = "TrueTypeFont"
$TrueTypeFont     = $TrueTypeFontPath + $TrueTypeFontName

# Test if directory exist or create
if (!(Test-Path $TrueTypeFont)) {
    New-Item -Path $TrueTypeFontPath -Name $TrueTypeFontName
}

# Iterate over auditional installed fonts (0, 00, ...)
$fontKeyName = "0"

while ($(Get-ItemProperty -Path $TrueTypeFont -Name $fontKeyName -ErrorAction SilentlyContinue)) {
    $fontKeyName = $fontKeyName + "0"
}

# Create string value
Set-ItemProperty -Path $TrueTypeFont -Name $fontKeyName -Value "DejaVuSansMono NF"
Write-Host "Added $($TrueTypeFont)\$($fontKeyName) to registry"