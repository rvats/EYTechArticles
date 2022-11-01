Function AddNetBIOStoHostFile {

Param (
    [Parameter(Mandatory = $true)]
    [string]$hostFileEntry
)
    Write-Host "Adding Host File Entry as: $($hostFileEntry)"
    $file = "C:\Windows\System32\drivers\etc\hosts"
    $hostfile = Get-Content $file
    $hostfile += ""
    $hostfile += $hostFileEntry
    Set-Content -Path $file -Value $hostfile -Force
}

#Start

AddNetBIOStoHostFile