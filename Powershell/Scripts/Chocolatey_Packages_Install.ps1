# Check administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Output "Not running as administrator.."
    Exit 1
}

# Install packages
foreach ($line in Get-Content "Configs\Chocolatey_Packages.txt")
{
    # Ignore comments
    if (!($line.ToString().Trim().Startswith("#")))
    {
        # Ignore whitespace only lines
        if (!([string]::IsNullOrWhiteSpace($line)))
        {
            Write-Host "[DRY-RUN] choco install --yes --limitoutput $($line)"
            #choco install --yes --limitoutput $cPackage
        }
    }
}