## ShareGate Test Script Snippets
## sgMigrateCopyGroups4.ps1
## Copy Groups From SPO to SPO - PreCheck or Actual
## As of: 9/29/2021
## Developer: Tom Molskow, Cognizant

cls

## SPO Login and Password
$spoUsername = "P.AUSPORTMIGP.10@ey.com" #
#$spousername = "P.AUSPORTMIGP.10" #
$spoPassword = "QReJ+MMvJ+Vnaba1" #

## SPOP Login and Password
#$spoUsername = "ey\P.AUOPRTMIGP.10@ey.com" #
#$spoUsername = "P.AUOPRTMIGP.10@ey.com" #
#$spoUsername = "ey\P.AUOPRTMIGP.10" #
#$spoUsername = "P.AUOPRTMIGP.10" #
#$spopPassword = "cL95H@urF7~Vk3%" #

## DMZ Login and Password
#$spoUsername = "Z.AUOPRTMIGP.10@ey.com"
#$spoUsername = "Z.AUOPRTMIGP.10"
#$spopPassword = "xSTQGPNkA62)0I#"

## Get spoSites File
$csvFile = "C:\Test\Stage\uniqueGroups6.csv"
$table = Import-Csv $csvFile -Delimiter ","

## Import ShareGate Module
Import-Module Sharegate

foreach ($row in $table)
{
    Write-Host "`$ID = " $row.ID

    #if ($row.ID = 3)
    #{

    $ID = $row.ID
    $spoSite = $row.SPOSite
    $spopSite = $row.SPOPSite

    Write-Host "`$ID = $ID"
    Write-Host "`$spoSite = $spoSite"
    Write-Host "`$spopSite = $spopSite`n"

    ## Connect to SPO and SPOP Sites
    $spoSiteSG = Connect-Site -Url $spoSite -Browser -DisableSSO
    $spopSiteSG = Connect-Site -Url $spopSite -Browser -DisableSSO

    ## Set Report File Path and Name
    #$CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".xlxs" # Excel Version
    $CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + $ID + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv" # CSV Version
    #$CopyPermissionsReportPathFile = "C:\Test\Stage\CopyGroupsLogs" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv" # CSV Version

    ## Copy Groups
    #$CopyGroups = Copy-Group -All -SourceSite $spoSiteSG -DestinationSite $spopSiteSG -WhatIf # Pre-Check
    #$CopyGroups = Copy-Group -All -SourceSite $spoSiteSG -DestinationSite $spopSiteSG # Actual Copy

    $copysettings = New-CopySettings -OnContentItemExists Overwrite -OnSiteObjectExists Merge
    $toCopy = Get-Group -Site $spoSiteSG
    $CopyGroups = Copy-Group -Group $toCopy -DestinationSite $spopSiteSG -CopySettings $copysettings
    $CopyObjPerm = Copy-ObjectPermissions -Source $spoSiteSG -Destination $spopSiteSG

    ## Export Reports
    Export-Report -CopyResult $CopyGroups -Path $CopyPermissionsReportPathFile
    Export-Report -CopyResult $CopyObjPerm -Path $CopyPermissionsReportPathFile -Overwrite

    Write-Host "`n "
    
    Write-Host "Copy For $spopSiteSG Completed `n"  -ForegroundColor Green

    Start-Sleep -Seconds 15

    #}
}