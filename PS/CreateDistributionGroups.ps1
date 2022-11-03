#Requires -Modules @{ ModuleName="ExchangeOnlineManagement"; ModuleVersion="2.0.5" }

# *********** Important: Make Sure You are Connected To Exchange Online: Run: Connect-ExchangeOnline *********** #

############################# BULK CREATE DISTRIBUTION GROUPS ###########################
################ This Script Requires Exchange Online PowerShell Module ##################

#Ensure that the input file columns for name is changed to groupname and PrimarySMTPAddress is primarysmtp
#Ensure that the CSV input is filtered for only DirSync values of True (non-cloud DG's and mailenabledDG's in seperate files)
#Seperate runs will be needed for Line 41 -Type Security and -Type Distribution  Security value represent mail enabled DG's and Distribution is the everyday Distribution group not used for security


Function CreateDistributionGroups {

Param (
    [Parameter(Mandatory = $true)]
    #Verify the CSV actually exists before we let the script run.
    [ValidateScript({ $_ -and (Test-Path -Path $_ -Filter '*.csv' -PathType Leaf)})]
    [string]$csvFile = "Data.csv",

    [Parameter(Mandatory = $true)]
    [string]$logFile = "DistributionGroupMigrationOutputTranscript.txt"
)

    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference = "Continue"
    Start-Transcript -path $logFile -Append

    $DistributionGroupsDataSet = Import-Csv $csvFile -Delimiter ','

    foreach ($DistributionGroup in $DistributionGroupsDataSet)
    {
        #Set Variables
        $Identity = $DistributionGroup.Identity
        Write-Host "Started Processing $Identity" -ForegroundColor Yellow

        $RequireSenderAuthenticationEnabled = [System.Convert]::ToBoolean($DistributionGroup.RequireSenderAuthenticationEnabled)
        $ModerationEnabled = [System.Convert]::ToBoolean($DistributionGroup.ModerationEnabled)
        $BypassNestedModerationEnabled = [System.Convert]::ToBoolean($DistributionGroup.BypassNestedModerationEnabled)
        $BccBlocked = [System.Convert]::ToBoolean($DistributionGroup.BccBlocked)
        $HiddenFromAddressListsEnabled = [System.Convert]::ToBoolean($DistributionGroup.HiddenFromAddressListsEnabled)
        $HiddenGroupMembershipEnabled = [System.Convert]::ToBoolean($DistributionGroup.HiddenGroupMembershipEnabled)
        $ReportToOriginatorEnabled = [System.Convert]::ToBoolean($DistributionGroup.ReportToOriginatorEnabled)
        $ReportToManagerEnabled = [System.Convert]::ToBoolean($DistributionGroup.ReportToManagerEnabled)
        $SendOofMessageToOriginatorEnabled = [System.Convert]::ToBoolean($DistributionGroup.SendOofMessageToOriginatorEnabled)

        $Description = $DistributionGroup.Description
        if($Description -eq $null -or $Description -eq "")
        {
            $Description = "Email Distribution List"
        }

        $DistributionGroupParams = @{
            Name                               = $Identity;
            Description                        = $Description;
            DisplayName                        = $DistributionGroup.DisplayName;
            PrimarySmtpAddress                 = $DistributionGroup.PrimarySmtpAddress;
            MemberJoinRestriction              = $DistributionGroup.MemberJoinRestriction;
            MemberDepartRestriction            = $DistributionGroup.MemberDepartRestriction;
            RequireSenderAuthenticationEnabled = $RequireSenderAuthenticationEnabled;
            ModerationEnabled                  = $ModerationEnabled;
            BypassNestedModerationEnabled      = $BypassNestedModerationEnabled;
            SendModerationNotifications        = $DistributionGroup.SendModerationNotifications;
        }

        if($row.MemberJoinRestriction) {
            $DistributionGroupParams.Alias = $DistributionGroup.Alias
        }
    
        #$Host.EnterNestedPrompt()
    
        #$DistributionGroupParams
        $CommandString = "New-DistributionGroup"
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
        Write-Host "Command: $CommandString -IgnoreNamingPolicy" -ForegroundColor Yellow
    
        New-DistributionGroup @DistributionGroupParams -IgnoreNamingPolicy
        Write-Host "Finished Processing $Identity`r`n" -ForegroundColor Green
    }

    Stop-Transcript

}


#Start

CreateDistributionGroups
############################## BULK CREATE DISTRIBUTION GROUPS ###########################