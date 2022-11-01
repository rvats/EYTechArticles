############################## BULK CREATE DISTRIBUTION GROUPS ###########################
################ This Script Requires Exchange Online PowerShell Module ##################

Function ExchangeMigration {
    Param (
        [Parameter(Mandatory = $true)]
        #Verify the CSV actually exists before we let the script run.
        [ValidateScript({ $_ -and (Test-Path -Path $_ -Filter '*.csv' -PathType Leaf)})]
        [string]$csvFile = "DataDump.csv",

        [Parameter(Mandatory = $true)]
        [string]$logFile = "DistributionGroupMigrationOutputTranscript.txt"
    )

    Connect-ExchangeOnline 
    
    $table1 = Import-Csv $csvFile -Delimiter ","
    foreach ($row in $table1)
    {
        Write-Host "Processing " $GroupName -ForegroundColor Yellow
        #Set Variables
        $GroupName = $row.groupname
        if($row.RequireSenderAuthenticationEnabled){
            Write-Host "RequireSenderAuthenticationEnabled " $row.RequireSenderAuthenticationEnabled -ForegroundColor White
        }
        else{
            Write-Host "RequireSenderAuthenticationEnabled " $row.RequireSenderAuthenticationEnabled -ForegroundColor Red
        }
    
        #Change Office 365 Group primary SMTP
        #This line creates the initial DG - not all inputs are accepted and require the set-distributionGroup command
        #New-DistributionGroup -Name "$($row.groupname)" -Description "$($row.description)" -Alias "$($row.alias)" -DisplayName "$($row.DisplayName)" -MemberDepartRestriction "$($row.MemberDepartRestriction)" -ManagedBy "$($row.ManagedBy)" -PrimarySmtpAddress "$($row.primarysmtp)" -MemberJoinRestriction "$($row.MemberJoinRestriction)" -RequireSenderAuthenticationEnabled "$($row.RequireSenderAuthenticationEnabled)" -SendModerationNotifications "$($row.SendModerationNotifications
        #)"-IgnoreNamingPolicy -Type Security -Confirm:$false
        New-DistributionGroup -Name "$($row.groupname)" -Description "$($row.description)" -Alias "$($row.alias)" -DisplayName "$($row.DisplayName)" -MemberDepartRestriction "$($row.MemberDepartRestriction)" -ManagedBy "$($row.ManagedBy)" -PrimarySmtpAddress "$($row.primarysmtp)" -RequireSenderAuthenticationEnabled ($row.RequireSenderAuthenticationEnabled) -IgnoreNamingPolicy -Type Security -Confirm:$false
        Write-Host "Finished Processing " $GroupName -ForegroundColor Green
    }
}
#Get-DistributionGroup | Set-DistributionGroup -ArbitrationMailbox SystemMailbox{3f3d3b0a-1ef3-4b62-82cf-d82d74ff3a44}
#All DG have this same systemmailbox assigned and this command could be run if needed (WE ARE LETTING THE EXCHANGE ONLINE ASSIGN THE ARBITRATION MAILBOX
    
############################## BULK CREATE DISTRIBUTION GROUPS ###########################