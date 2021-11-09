## ShareGate Test Script Snippets
## sgMigrateCopy.ps1
## Copy From Source to Destination - PreCheck Only
## As of: 9/16/2021
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

## DMZ
#$spoUsername = "Z.AUOPRTMIGP.10@ey.com"
#$spoUsername = "Z.AUOPRTMIGP.10"
#$spopPassword = "xSTQGPNkA62)0I#"

## Get spoSites File
$csvFile = "C:\Test\Stage\CopyGroupsMig.csv"
$table = Import-Csv $csvFile -Delimiter ";"

## Process SPO - Pass Credentials
#$spoPasswordSG = ConvertTo-SecureString $spoPassword -AsPlainText -Force
#$spoSiteSG = Connect-Site -Url $spoSite -Username $spoUsername -Password $spoPasswordSG
#$spoSiteSG = Connect-Site -Url $spoSite -Browser -DisableSSO

## Connect to SPOP - Pass Crednetials
#$spopPasswordSG = ConvertTo-SecureString $spopPassword -AsPlainText -Force
#$spopSiteSG = Connect-Site -Url $spopSite -Username $spopUsername -Password $spopPasswordSG 
#$spopSiteSG = Connect-Site -Url $spopSite -Browser -DisableSSO

foreach ($row in $table)
{

$ID = $row.ID
$spoSite = $row.SPOSite
$spopSite = $row.SPOPSite

## Import ShareGate Module
Import-Module Sharegate

## Connect to SPO and SPOP Sites
$spoSiteSG = Connect-Site -Url $spoSite -Browser -DisableSSO
$spopSiteSG = Connect-Site -Url $spopSite -Browser -DisableSSO

#$CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".xlxs" # Excel Versions
$CopyPermissionsReportPathFile = "C:\Test\Stage\" + $ID + "Logs_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv" # Excel Versions

## Copy Groups
$CopyGroups = Copy-Group -All -SourceSite $spoSiteSG -DestinationSite $spopSiteSG -WhatIf # Pre-Check
#$CopyGroups = Copy-Group -All -SourceSite $spoSiteSG -DestinationSite $spopSiteSG # Actual Copy
Export-Report -CopyResult $CopyGroups -Path $CopyPermissionsReportPathFile

}



