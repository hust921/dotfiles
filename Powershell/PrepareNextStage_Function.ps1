function PrepareNextStage ($dotInstallPath, $dotInstallStage)
{
    # Key (Register "directory")
    $dotKeyPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\"
    $dotKeyName = "RunOnce"
    $dotKey = $dotKeyPath + $dotKeyName

    # Script to run (Register "value")
    $dotPropertyName = "DotfilesInstaller"
    $dotPropertyValue = "$dotInstallPath $dotInstallStage"

    # Create Key if missing
    if (!(Test-Path $dotKey)) {
        New-Item -Path $dotKeyPath -Name $dotKeyName
    }

    # Create Value
    
    Set-ItemProperty -Path $dotKey -Name $dotPropertyName -Value $dotPropertyValue
}

PrepareNextStage("path\to\ps", 5)