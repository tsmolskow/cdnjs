## ShareGate Test Script Snippets
## sgMigrateCopyGroups3.ps1
## Copy Groups From SPO to SPO - PreCheck or Actual
## As of: 9/29/2021
## Developer: Tom Molskow, Cognizant

cls

## SPO Login and Password
#$spoUsername = "P.AUSPORTMIGP.10@ey.com" #
#$spousername = "P.AUSPORTMIGP.10" #
#$spoPassword = "QReJ+MMvJ+Vnaba1" #

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
$csvFile = "C:\Test\Stage\CopyGroupsMig.csv"
$table = Import-Csv $csvFile -Delimiter ","

## Import ShareGate Module
Import-Module Sharegate

foreach ($row in $table)
{

$ID = $row.ID
$spoSite = $row.SPOSite
$spopSite = $row.SPOPSite

$spoSiteSG = Connect-Site -Url $spoSite -Browser -DisableSSO
$spopSiteSG = Connect-Site -Url $spopSite -Browser -DisableSSO

#$CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".xlxs" # Excel Version
$CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + $ID + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv" # CSV Version

## Copy Groups
$CopyGroups = Copy-Group -All -SourceSite $spoSiteSG -DestinationSite $spopSiteSG -WhatIf # Pre-Check
#$CopyGroups = Copy-Group -All -SourceSite $spoSiteSG -DestinationSite $spopSiteSG # Actual Copy
Export-Report -CopyResult $CopyGroups -Path $CopyPermissionsReportPathFile

 Start-Sleep -Seconds 500

}



