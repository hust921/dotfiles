# Check administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output "Not running as administrator.."
    Exit 1
}

# Check if choco already installed
if (Get-Command choco -ErrorAction SilentlyContinue)
{
    # Upgrade
    choco upgrade -yes --limitoutput chocolatey
}
else
{
    # Install
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    # Add Chocolatey (packages') bin folder to path
    $currentPath =(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
    $updatedPath = $currentPath + "$env:ChocolateyInstall\bin"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $updatedPath
}