# ======== Check Administrator ========
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output ""
    Write-Output "========================================================="
    Write-Output ""
    Write-Output "              Run script as administrator"
    Write-Output "          Remember to enable execution policy"
    Write-Output ""
    Write-Output "---------------------------------------------------------"
    Write-Output ""
    Write-Output "     Set-ExecutionPolicy -Scope CurrentUser Unrestricted"
    Write-Output "     Set-ExecutionPolicy -Scope LocalMachine Unrestricted"
    Write-Output ""
    Write-Output "========================================================="
    Write-Output ""

    Pause
    exit 1
}

# ======== Globals ========
$LogPath     = "$(pwd)\Logs"
$ScriptPath  = "$(pwd)\Scripts"
$AssetsPath  = "$(pwd)\Assets"

$Scriptnames = "Chocolatey_Install", "Chocolatey_Packages_Install", "Powershell_Profile_Install", "ConsoleFont_Install", "Vim_Wsl_Install"
# Add scriptname: "Wsl_Ubuntu_Install" with restart and rerun

# ======== Main ========
function Main()
{
    # Source scripts
    foreach ($scriptName in $ScriptNames)
    {
        $question = Read-Host "Do you want to run the script: $scriptName.ps1?`n(y/[n]): "
        if ($question -eq 'y')
        {
            SourceScript($scriptName)        
        }
    }
}

# ======== Manual source utils.ps1 ========
. "$($ScriptPath)\Utils.ps1"


# ================ RUN MAIN ================
Main
