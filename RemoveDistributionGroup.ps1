#Requires -Modules @{ ModuleName="ExchangeOnlineManagement"; ModuleVersion="2.0.5" }

# *********** Important: Make Sure You are Connected To Exchange Online: Run: Connect-ExchangeOnline *********** #

############################## BULK REMOVE DISTRIBUTION GROUPS ###########################
################ This Script Requires Exchange Online PowerShell Module ##################
#Set Variables and loading CSV File

Function RemoveDistributionGroups {

Param (
    [Parameter(Mandatory = $true)]
    #Verify the CSV actually exists before we let the script run.
    [ValidateScript({ $_ -and (Test-Path -Path $_ -Filter '*.csv' -PathType Leaf)})]
    [string]$csvFile = "Data.csv",

    [Parameter()]
    [string]$logFile = "DistributionGroupMigrationOutputTranscript.txt"
)

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $logFile -Append

$table1 = Import-Csv $csvFile -Delimiter ","

foreach ($row in $table1)
{
    #Set Variables
    $Identity = $row.Identity
    Write-Host Removing Group $Identity -ForegroundColor Yellow
    #Following command set the additional properties which cannot be set during Initialization
    Write-Host "Remove-DistributionGroup -Identity `"$Identity`" -Confirm:`$$false -BypassSecurityGroupManagerCheck"
    Remove-DistributionGroup  -Identity $Identity -Confirm:$false -BypassSecurityGroupManagerCheck
}

Stop-Transcript

}

#Start

RemoveDistributionGroups 
############################## BULK REMOVE DISTRIBUTION GROUPS ###########################