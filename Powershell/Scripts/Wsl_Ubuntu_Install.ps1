# Check administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output "Not running as administrator.."
    Exit 1
}

# if ( WSL is NOT enabled )
#{
    # ======== Enable WSL (Windows Subsystems/Features) ========
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

    # Prepare next stage (regedit)
    # Restart PC
    
    #
    # Continue this script
    #
    # OR: Continue main script -> goto stage (this) and run again
    # 
#}

# ======== Install Ubuntu ========
    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile ~/Ubuntu.appx -UseBasicParsing
    Add-AppxPackage -Path ~/Ubuntu.appx
    Ubuntu.exe 