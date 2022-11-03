#Requires -Modules @{ ModuleName="ExchangeOnlineManagement"; ModuleVersion="2.0.5" }

# *********** Important: Make Sure You are Connected To Exchange Online: Run: Connect-ExchangeOnline *********** #

############################# BULK Set Values to existing DISTRIBUTION GROUPS ###########################
################ This Script Requires Exchange Online PowerShell Module ##################
#Set Variables and loading CSV File

Function SetDistributionGroupsAttributesAndAddMembers {

Param (
    [Parameter(Mandatory = $true)]
    #Verify the CSV actually exists before we let the script run.
    [ValidateScript({ $_ -and (Test-Path -Path $_ -Filter '*.csv' -PathType Leaf)})]
    [string]$csvFile = "Data.csv",

    [Parameter()]
    [string]$logFile = "DistributionGroupMigrationOutputTranscript.txt",

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$IdentityPrefix = "zz_"
)

    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference = "Continue"
    Start-Transcript -path $logFile -Append

    $table1 = Import-Csv $csvFile -Delimiter ","

    $FinalScriptContent = "#Requires -Modules @{ ModuleName=`"ExchangeOnlineManagement`"; ModuleVersion=`"2.0.5`" }`n"
    $FinalScriptContent += "`$ErrorActionPreference=`"SilentlyContinue`"`nStop-Transcript | out-null`n`$ErrorActionPreference = `"Continue`"`nStart-Transcript -path C:\JPMC\DistributionGroupMigrationOutputTranscript.txt -Append`n"

    foreach ($row in $table1)
    {
        #Set Variables
        $Identity = $row.Identity
        $HiddenGroupMembershipEnabled      = [System.Convert]::ToBoolean($row.HiddenGroupMembershipEnabled)
        $HiddenFromAddressListsEnabled     = [System.Convert]::ToBoolean($row.HiddenFromAddressListsEnabled)
        $ReportToOriginatorEnabled         = [System.Convert]::ToBoolean($row.ReportToOriginatorEnabled)
        $ReportToManagerEnabled            = [System.Convert]::ToBoolean($row.ReportToManagerEnabled)
        $SendOofMessageToOriginatorEnabled = [System.Convert]::ToBoolean($row.SendOofMessageToOriginatorEnabled)

        $DistributionGroupParams = @{
            Identity                          = $Identity;
            HiddenGroupMembershipEnabled      = $HiddenGroupMembershipEnabled;
            HiddenFromAddressListsEnabled     = $HiddenFromAddressListsEnabled;
            ReportToOriginatorEnabled         = $ReportToOriginatorEnabled;
            ReportToManagerEnabled            = $ReportToManagerEnabled;
            SendOofMessageToOriginatorEnabled = $SendOofMessageToOriginatorEnabled;
            <# Potential Blank params
            MemberJoinRestriction             = $row.MemberJoinRestriction;
            MemberDepartRestriction           = $row.MemberDepartRestriction;
            SendModerationNotifications       = $row.SendModerationNotifications;
            CustomAttribute1                  = $row.CustomAttribute1;
            CustomAttribute2                  = $row.CustomAttribute2;
            CustomAttribute3                  = $row.CustomAttribute3;
            CustomAttribute4                  = $row.CustomAttribute4;
            CustomAttribute5                  = $row.CustomAttribute5;
            CustomAttribute6                  = $row.CustomAttribute6;
            CustomAttribute7                  = $row.CustomAttribute7;
            CustomAttribute8                  = $row.CustomAttribute8;
            CustomAttribute9                  = $row.CustomAttribute9;
            CustomAttribute10                 = $row.CustomAttribute10;
            CustomAttribute11                 = $row.CustomAttribute11;
            CustomAttribute12                 = $row.CustomAttribute12;
            CustomAttribute13                 = $row.CustomAttribute13;
            CustomAttribute14                 = $row.CustomAttribute14;
            CustomAttribute15                 = $row.CustomAttribute15;
            Managedby                         = $row.ManagedBy;
            #>
        }
        #For these attributes they do not handle blank values
        if($row.MemberJoinRestriction) 
        {
            $DistributionGroupParams.MemberJoinRestriction = $row.MemberJoinRestriction
        }
        if($row.MemberDepartRestriction) 
        {
            $DistributionGroupParams.MemberDepartRestriction = $row.MemberDepartRestriction
        }
        if($row.SendModerationNotifications) 
        {
            $DistributionGroupParams.SendModerationNotifications = $row.SendModerationNotifications
        }
        if($row.CustomAttribute1) 
        {
            $DistributionGroupParams.CustomAttribute1 = $row.CustomAttribute1
        }
        if($row.CustomAttribute2) 
        {
            $DistributionGroupParams.CustomAttribute2 = $row.CustomAttribute2
        }
        if($row.CustomAttribute3) 
        {
            $DistributionGroupParams.CustomAttribute3 = $row.CustomAttribute3
        }
        if($row.CustomAttribute4) 
        {
            $DistributionGroupParams.CustomAttribute4 = $row.CustomAttribute4
        }
        if($row.CustomAttribute5) 
        {
            $DistributionGroupParams.CustomAttribute5 = $row.CustomAttribute5
        }
        if($row.CustomAttribute6) 
        {
            $DistributionGroupParams.CustomAttribute6 = $row.CustomAttribute6
        }
        if($row.CustomAttribute7) 
        {
            $DistributionGroupParams.CustomAttribute7 = $row.CustomAttribute7
        }
        if($row.CustomAttribute8) 
        {
            $DistributionGroupParams.CustomAttribute8 = $row.CustomAttribute8
        }
        if($row.CustomAttribute9) 
        {
            $DistributionGroupParams.CustomAttribute9 = $row.CustomAttribute9
        }
        if($row.CustomAttribute10) 
        {
            $DistributionGroupParams.CustomAttribute10 = $row.CustomAttribute10
        }
        if($row.CustomAttribute11) 
        {
            $DistributionGroupParams.CustomAttribute11 = $row.CustomAttribute11
        }
        if($row.CustomAttribute12) 
        {
            $DistributionGroupParams.CustomAttribute12 = $row.CustomAttribute12
        }
        if($row.CustomAttribute13) 
        {
            $DistributionGroupParams.CustomAttribute13 = $row.CustomAttribute13
        }
        if($row.CustomAttribute14) 
        {
            $DistributionGroupParams.CustomAttribute14 = $row.CustomAttribute14
        }
        if($row.CustomAttribute15) 
        {
            $DistributionGroupParams.CustomAttribute15 = $row.CustomAttribute15
        }
        if($row.Managedby) 
        {
            $DistributionGroupParams.Managedby = $row.ManagedBy
        }
        if($row.AcceptMessagesOnlyFrom)
        {
            $DistributionGroupParams.AcceptMessagesOnlyFrom = $row.AcceptMessagesOnlyFrom
        }
        if($row.AcceptMessagesOnlyFromDLMembers)
        {
            $DistributionGroupParams.AcceptMessagesOnlyFromDLMembers = $row.AcceptMessagesOnlyFromDLMembers        
        }
        if($row.AcceptMessagesOnlyFromSendersOrMembers)
        {
            $DistributionGroupParams.AcceptMessagesOnlyFromSendersOrMembers = $row.AcceptMessagesOnlyFromSendersOrMembers
        }
        if($row.RejectMessagesFrom)
        {
            $DistributionGroupParams.RejectMessagesFrom = $row.RejectMessagesFrom
        }
        if($row.RejectMessagesFromDLMembers)
        {
            $DistributionGroupParams.RejectMessagesFromDLMembers = $row.RejectMessagesFromDLMembers
        }
        if($row.RejectMessagesFromSendersOrMembers)
        {
            $DistributionGroupParams.RejectMessagesFromSendersOrMembers = $row.RejectMessagesFromSendersOrMembers
        }
    
        #$DistributionGroupParams
    
        Write-Host "Processing `"$Identity`"" -ForegroundColor Yellow
        #Following command set the additional properties which cannot be set during Initialization
    
        #$DistributionGroupParams
        $CommandString = "Set-DistributionGroup"
        $DistributionGroupParams.Keys | 
            ForEach-Object {
                #Format Whitespace Params
                if ( $DistributionGroupParams.$_ -match "\s" ) {
                    $CommandString += (' -{0} "{1}"' -f $_, $DistributionGroupParams.$_ )
                }
                #Format Boolean Params
                elseif ( $DistributionGroupParams.$_ -Match "[Tt]rue|[Ff]alse") {
                    $CommandString += (' -{0} {1}' -f $_, $DistributionGroupParams.$_ ).replace("True","`$True").Replace("False","`$False")
                }
                #Add all the rest of the params (Enumerators cannot be double quoted)
                else {
                    $CommandString += (' -{0} {1}' -f $_, $DistributionGroupParams.$_ )
                }
            }

        Write-Host "Command: $CommandString -HiddenGroupMembershipEnabled -IgnoreNamingPolicy" -ForegroundColor Yellow
        #$Host.EnterNestedPrompt()
        #Start-Sleep 5
        Set-DistributionGroup @DistributionGroupParams -BypassSecurityGroupManagerCheck -IgnoreNamingPolicy
        
        $Members = $row.Members.Split(",")
        $MaxJobs = 20
    
        foreach ($Member in $Members)
        {
            #$Jobs = Get-Job -State Running
            Write-Host "Add-DistributionGroupMember -Identity `"$Identity`" -Member " $Member "-ErrorAction Continue -BypassSecurityGroupManagerCheck"
            Add-DistributionGroupMember -Identity $Identity -Member $Member -ErrorAction Continue -BypassSecurityGroupManagerCheck
            <#while ( $MaxJobs.State -ge $MaxJobs ) {
                Start-Sleep -Seconds 1
            }#>
        }

        $FinalScriptContent += "Write-Host `"Executing the Set-DistributionGroup -Identity `"" + $Identity + "`" -Emailaddresses " + $row.Emailaddresses +" -ErrorAction Continue -BypassSecurityGroupManagerCheck Command`" -ForegroundColor Gray`n"
        $FinalScriptContent += "Set-DistributionGroup -Identity `"" + $Identity + "`" -PrimarySMTPAddress " + $row.PrimarySMTPAddress.replace($IdentityPrefix,'') + " -ErrorAction Continue -BypassSecurityGroupManagerCheck`n"
        $FinalScriptContent += "Set-DistributionGroup -Identity `"" + $Identity + "`" -Emailaddresses " + $row.Emailaddresses.replace($IdentityPrefix,'') + " -ErrorAction Continue -BypassSecurityGroupManagerCheck`n"
        $FinalScriptContent += "Set-DistributionGroup -Identity `"" + $Identity + "`" -Name `"" + $Identity.replace($IdentityPrefix,'') + "`" -ErrorAction Continue -BypassSecurityGroupManagerCheck`n"
        $FinalScriptContent += "Start-Sleep -Seconds 1`n"
        $FinalScriptContent += "Write-Host `"Command Executed`" -ForegroundColor Green`n"
        #Set-DistributionGroup -Identity $row.Identity -Emailaddresses @{add=$row.EmailAddresses}
    
        #Write-Host "Set-DistributionGroup -Identity `$Identity `@DistributionGroupParams"

        #Get-DistributionGroup | Set-DistributionGroup -ArbitrationMailbox SystemMailbox{3f3d3b0a-1ef3-4b62-82cf-d82d74ff3a44}
        #All DG have this same systemmailbox assigned and this command could be run if needed (WE ARE LETTING THE EXCHANGE ONLINE ASSIGN THE ARBITRATION MAILBOX
        Write-Host "Finished Processing `"$Identity`"" -ForegroundColor Green
    }


    Write-Host "Execute the final powershell script C:\JPMC\SetDistributionGroupEmailAddresses.ps1" -ForegroundColor Green
    $FinalScriptContent=$FinalScriptContent+"Stop-Transcript"
    $FinalScriptContent | Out-File -FilePath C:\JPMC\SetDistributionGroupEmailAddresses.ps1 -Encoding ASCII
    Stop-Transcript
}

#Start

SetDistributionGroupsAttributesAndAddMembers 
############################## BULK Set Values to DISTRIBUTION GROUPS ###########################