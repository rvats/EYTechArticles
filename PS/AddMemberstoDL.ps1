#Requires -Modules @{ ModuleName="ExchangeOnlineManagement"; ModuleVersion="2.0.5" }

Function AddMemberstoDL {
    Param (
        [Parameter(Mandatory = $true)]
        #Verify the CSV actually exists before we let the script run.
        [ValidateScript({ $_ -and (Test-Path -Path $_ -Filter '*.csv' -PathType Leaf)})]
        [string]$MembersCSVFile,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$logFile = "AddingMembersToDLOutputTranscript.txt"
    )

    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference = "Continue"
    Start-Transcript -path $logFile -Append

    Connect-ExchangeOnline

    $Table = import-csv $MembersCSVFile
    Write-Host "Processing Adding Members to Distribution Groups" -ForegroundColor Yellow
    $Table | 
    % {
        $Identity = $_.Identity
        $Members = $_.Members.Split(",")
        foreach ($Member in $Members)
        {
            Write-Host "Add-DistributionGroupMember -Identity `"$Identity`" -Member " $Member " -BypassSecurityGroupManagerCheck"
            Add-DistributionGroupMember -Identity $Identity -Member $Member -BypassSecurityGroupManagerCheck
        }
    }
    Stop-Transcript
}
#Start

AddMemberstoDL 