# ======== Source Scripts ========
function SourceScript ($scriptFile)
{
    # Check log path
    if (!(Test-Path $LogPath))
    {
        mkdir $LogPath
        Write-Output "Created log directory"
    }

    # Source
    Start-Transcript -Path "$($LogPath)\$($scriptFile).txt" -Append -Force
    . "$($ScriptPath)\$($scriptFile).ps1"
    Stop-Transcript
    
}