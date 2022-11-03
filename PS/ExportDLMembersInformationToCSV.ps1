#Requires -Modules @{ ModuleName="ExchangeOnlineManagement"; ModuleVersion="2.0.5" }

Function ExportDLMembersInformationToCSV {
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$logFile = "AddingMembersToDLOutputTranscript.txt",

        [Parameter(Mandatory = $true)]
        [string]$UserAccountName,
        
        [Parameter()]
        [string]$IdentityPrefix = "zz_",

        [Parameter(Mandatory = $true)]
        [string]$OutFilePath = "Data.csv",

        [Parameter(Mandatory = $true)]
        [string]$Delimiter = ";",

        [Parameter()]
        $TestSize = @{
            #First = "1"
        }
    )

    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference = "Continue"
    Start-Transcript -path $logFile -Append

    $ParentFolder = Split-Path $OutFile -Parent
    if ( -not (Test-Path $ParentFolder)) {
        mkdir $ParentFolder | out-Null
    }

    $Identities = @(
        ""
    )

    #Connect-ExchangeOnline -UserPrincipalName $AffinionSYS

    $Results = @()

    $Identities | % {
        $Results += Get-DistributionGroup -Identity $_ | Select-Object `
            @{N='Identity';E={if ($IdentityPrefix) { "{0}{1}" -f $IdentityPrefix, $_.Identity } Else { $_.Identity } }},
            Description,
            Alias,
            DisplayName,
            @{N='PrimarySMTPAddress';E={ if ($IdentityPrefix) { "{0}{1}" -f $IdentityPrefix, $_.PrimarySMTPAddress } Else { $_.PrimarySMTPAddress } }},
            RequireSenderAuthenticationEnabled,
            MemberJoinRestriction,
            MemberDepartRestriction,
            @{N="Members";E={
                (([ADSISearcher]"anr=$($_.Identity)").FindOne().GetDirectoryEntry().member | % { ([adsi]"LDAP://$_").mail }) -join ','
            }},
            @{N='EmailAddresses';E={
                ($_.EmailAddresses | % {
                    if ($IdentityPrefix) {
                        ("'{0}'" -f $_) -creplace "SMTP:", ("SMTP:{0}" -f $IdentityPrefix)
                    }
                    else {
                        ("'{0}'" -f $_)
                    }
                }) -Join ','}
            },
            ManagedBy,
            SendModerationNotifications,
            ArbitrationMailbox,
            SamAccountName,
            Notes,
            ModerationEnabled,
            BypassNestedModerationEnabled,
            BccBlocked,
            HiddenGroupMembershipEnabled,
            HiddenFromAddressListsEnabled,
            ReportToOriginatorEnabled,
            ReportToManagerEnabled,
            SendOofMessageToOriginatorEnabled,
            AcceptMessagesOnlyFrom,
            AcceptMessagesOnlyFromDLMembers,
            AcceptMessagesOnlyFromSendersOrMembers,
            RejectMessagesFrom,
            RejectMessagesFromDLMembers,
            RejectMessagesFromSendersOrMembers,
            CustomAttribute1,
            CustomAttribute2,
            CustomAttribute3,
            CustomAttribute4,
            CustomAttribute5,
            CustomAttribute6,
            CustomAttribute7,
            CustomAttribute8,
            CustomAttribute9,
            CustomAttribute10,
            CustomAttribute11,
            CustomAttribute12,
            CustomAttribute13,
            CustomAttribute14,
            CustomAttribute15
    }

    $Results | 
        Select-Object @TestSize `
            Identity,
            Description,
            Alias,
            DisplayName,
            PrimarySMTPAddress,
            RequireSenderAuthenticationEnabled,
            MemberJoinRestriction,
            MemberDepartRestriction,
            Members,
            EmailAddresses,
            "OrganizationManagedAAD@cxloyalty.com",
            SendModerationNotifications,
            ArbitrationMailbox,
            SamAccountName,
            Notes,
            ModerationEnabled,
            BypassNestedModerationEnabled,
            BccBlocked,
            HiddenGroupMembershipEnabled,
            HiddenFromAddressListsEnabled,
            ReportToOriginatorEnabled,
            ReportToManagerEnabled,
            SendOofMessageToOriginatorEnabled,
            AcceptMessagesOnlyFrom,
            AcceptMessagesOnlyFromDLMembers,
            AcceptMessagesOnlyFromSendersOrMembers,
            RejectMessagesFrom,
            RejectMessagesFromDLMembers,
            RejectMessagesFromSendersOrMembers,
            CustomAttribute1,
            CustomAttribute2,
            CustomAttribute3,
            CustomAttribute4,
            CustomAttribute5,
            CustomAttribute6,
            CustomAttribute7,
            CustomAttribute8,
            CustomAttribute9,
            CustomAttribute10,
            CustomAttribute11,
            CustomAttribute12,
            CustomAttribute13,
            CustomAttribute14,
            CustomAttribute15 |
        ConvertTo-Csv -NoTypeInformation -Delimiter $Delimiter | 
    
    Out-File $OutFile
}

ExportDLMembersInformationToCSV -Delimiter ','