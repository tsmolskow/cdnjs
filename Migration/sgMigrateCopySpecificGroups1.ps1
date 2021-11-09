## ShareGate Migrate Copy Specific Groups
## sgMigrateCopySpecificGroups1.ps1
## Copy Specific Groups From SPO to SPOP - PreCheck or Actual
## As of: 10/11/2021
## Developer: Tom Molskow, Cognizant

cls

## Get Input File
$csvFile = "C:\Test\Stage\CopySpecificGroupsMig1.csv"
$table = Import-Csv $csvFile -Delimiter ","

## Import ShareGate Module
Import-Module Sharegate

## Process copyGroupsMig.csv Batch File
foreach ($row in $table)
{

    ## Set Variables
    $ID = $row.ID
    $spoSite = $row.SPOSite
    $spopSite = $row.SPOPSite
    $groupsList = $row.GroupsList # Comma Seperated List String

    ## Write Variables to Console
    Write-Host "`$ID = $ID"
    Write-Host "`$spoSite = $spoSite"
    Write-Host "`$spopSite = $spopSite`n"

    ## Connect to SPO and SPOP Sites
    $spoSiteSG = Connect-Site -Url $spoSite -Browser -DisableSSO # Connect to SPO Using Browser
    $spopSiteSG = Connect-Site -Url $spopSite -Browser -DisableSSO # Connect to SPOP Using Browser

    ## Connect to SPO and SPOP Sites Using Prompt
    #$Credentials = Get-Credential
    #$spoSiteSG = Connect-Site -Url $spopSite -Credential $Credentials # Connect to SPO Using Prompt

    ## Connect to SPO and SPOP Sites Using Prompt
    #$Credentials = Get-Credential
    #$spopSiteSG = Connect-Site -Url $spopSiteSG -Credential $Credentials # Connect to SPOP Using Prompt

    ## Set Report File Path and Name
    #$CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + $ID + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".xlxs" # Excel Version
    $CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + $ID + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv" # CSV Version

    ## Copy Specific Groups
    $copysettings = New-CopySettings -OnContentItemExists Overwrite -OnSiteObjectExists Merge
    $CopyGroups = Copy-Group -Name $groupsList -SourceSite $spoSiteSG -DestinationSite $spopSiteSG # Specific Groups
    $CopyObjPerm = Copy-ObjectPermissions -Source $spoSiteSG -Destination $spopSiteSG

    ## Export Reports
    Export-Report -CopyResult $CopyGroups -Path $CopyPermissionsReportPathFile
    Export-Report -CopyResult $CopyObjPerm -Path $CopyPermissionsReportPathFile -Overwrite

    ## Write Completion Message to Console
    Write-Host "`n "    
    Write-Host "Copy For $groupsList Completed, Starting Sleep for 15 Seconds `n"  -ForegroundColor Green
    Start-Sleep -Seconds 15

}