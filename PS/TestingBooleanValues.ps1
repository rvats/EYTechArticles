Function TestingBooleanValues {

Param (
    [Parameter(Mandatory = $true)]
    #Verify the CSV actually exists before we let the script run.
    [ValidateScript({ $_ -and (Test-Path -Path $_ -Filter '*.csv' -PathType Leaf)})]
    [string]$csvFile = "DataDump.csv"
)
    foreach($eachline in $csvFile) {
        $MigrationToUnifiedGroupInProgress = $eachline.MigrationToUnifiedGroupInProgress
        $SamAccountName = $eachline.SamAccountName

        Write-host $eachline.SamAccountName has MigrationToUnifiedGroupInProgress value set to $eachline.MigrationToUnifiedGroupInProgress -ForegroundColor Green
        switch ($eachline.MigrationToUnifiedGroupInProgress)
        {
            $true { 
                "That was true."; 
                break 
            }
            default { "Whatever it was, it wasn't true."; break }
        }
    }
}

TestingBooleanValues