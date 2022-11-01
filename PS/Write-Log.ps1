Function Write-Log([string]$logMsg)  
{   
    if(!$isLogFileCreated)
    {   
       
        $script:isLogFileCreated = $True
        [string]$logMessage = [System.String]::Format("[$(Get-Date)] - {0}", $logMsg)   
        Add-Content -Path $logFilePath -Value $logMessage
         
    }   
    else   
    {   
        [string]$logMessage = [System.String]::Format("[$(Get-Date)] - {0}", $logMsg)   
        Add-Content -Path $logFilePath -Value $logMessage
    }   
}