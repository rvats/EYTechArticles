# Import AD Module
Import-Module ActiveDirectory

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
 
Function ExportDLMembersInformationToCSV {
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$txtGroupFile = "ADDG2_descope.txt",

        [Parameter()]
        [string]$logFilePath = "MoveGroups_OutputAndErrors.txt",
        
        [Parameter(Mandatory = $true)]
        [string]$successLogFile= "MovedGroups.csv",

        [Parameter()]
        [string]$IdentityPrefix = "zz_",

        [Parameter(Mandatory = $true)]
        [string]$OutFilePath = "DataDump.csv",

        [Parameter(Mandatory = $true)]
        [string]$Delimiter = ";",

        [Parameter(Mandatory = $true)]
        [string]$TargetOU = "OU=NoO365Sync,OU=Distribution,OU=AG_Groups,DC=AffinionDS,DC=Com",

        [Parameter()]
        $TestSize = @{
            #First = "1"
        }
    )
    # Specify path to the text file with the account names
    $Import_groups = Get-Content $txtGroupFile
    $isLogFileCreated = $False

    #Array to Hold Result - PSObjects
    $ADGroupCollection = @()

    ForEach($ADGroup in $Import_groups){
    try {
        # Retrieve DN of Group
        $Group   = Get-ADGroup -Identity $ADGroup.Trim() -Properties *
        $GroupDN = $Group.distinguishedName
        
        #Get-ADGroup -Identity $ADGroup |Select @{Name='OU';Expression={$_.DistinguishedName -split '(?<!\\),' |Select -Index 1}}
        $OU=$GroupDN -replace '^.*?,(?=[A-Z]{2}=)'
        
        Write-Host "Moving Accounts....."

        # Move Group to target OU. Remove the -WhatIf parameter after you tested.
        $MovedGroup = Move-ADObject -Identity $GroupDN -TargetPath $TargetOU -PassThru

        $ReplaceParams = @{
            sAMAccountName     = "$($IdentityPrefix)_$($MovedGroup.sAMAccountName)"
            mail               = "$($IdentityPrefix)_$($MovedGroup.mail)"
            displayName        = "$($IdentityPrefix)_$($MovedGroup.displayName)"
            proxyAddresses     = $MovedGroup.ProxyAddresses | ? { $_ -like "SMTP:*" } | % { "$($_ -Replace 'smtp:','smtp:zz_')" } # change zz_ with $($IdentityPrefix)
        }

        #Set-ADGroup -Identity $GroupDN -Clear 'Mail'
        #Set-ADGroup -Identity $MovedGroup.DistinguishedName -Replace $ReplaceParams

        $ExportItem = New-Object PSObject
        $ExportItem | Add-Member -MemberType NoteProperty -name "SamAccountName" -value $ADGroup
        $ExportItem | Add-Member -MemberType NoteProperty -Name "LegacyUserDN" -value $GroupDN
        $ExportItem | Add-Member -MemberType NoteProperty -Name "OUPath" -value $OU
        $ADGroupCollection += $ExportItem
   
        }
        catch 
        {
            Write-host "Error in moving groups:"  $_.Exception.Message
            $logMessage= "Error in moving groups" + $_.Exception.Message
            Write-Log $logMessage
        }
    } 
    Write-Host "Completed move"
    $ADGroupCollection | Export-CSV $successLogFile -NoTypeInformation
}