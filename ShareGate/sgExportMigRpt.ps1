#sgExportMigRpt
#As of: 4/29/2021
#Notes: Dynamic file name, Password sent in clear, Needs for each loop to get all lists\libraries,
#Read from a SP List, Update to a SP List?

cls

#Import ShareGate Modules
Import-Module Sharegate	

#Set Variables
$srcSiteURL = "https://m365b742352.sharepoint.com/MigrateSubsite"
$dstSiteURL = "http://spfarm.eastus2.cloudapp.azure.com/sites/TestMigration3/TM3Subsite1"

$srcSiteName = $srcSiteURL.Split("/")[-1]
$dstSiteName = $dstSiteURL.Split("/")[-1]

$srcList = Get-List -Name "TestLib1" -Site $srcSite
$dstList = Get-List -Name "TestLib1" -Site $dstSite

$userName1 = "EYTestAdmin@M365B742352.onmicrosoft.com"
$userName2 = "CONTOSO\migadmin"
$mypassword1 = ConvertTo-SecureString "Cognizantadmin123!" -AsPlainText -Force
$mypassword2 = ConvertTo-SecureString "Cognizantadmin123!" -AsPlainText -Force

$filePath = "F:\MigrationReport\s" + $srcSiteName + "_d" + $dstSiteName + "_dt" + $(get-date -f dd_MM_yyyy) +".xlsx"

#Break

#Connect Source Site
$srcSite = Connect-Site -Url $srcSiteURL -Username $userName1 -Password $mypassword1

#Connect Destination Site
$dstSite = Connect-Site -Url $dstSiteURL -Username $userName2 -Password $mypassword2

#Copy All - Full Migration
$result = Copy-List -All -SourceSite $srcSite -DestinationSite $dstSite

#Copy All - Incremental Migration
$copysettings = New-CopySettings -OnContentItemExists IncrementalUpdate
$result = Copy-Content -SourceList $srcList -DestinationList $dstList -CopySettings $copysettings

#Export Migration Report
Export-Report $result -Path $filePath -Overwrite
