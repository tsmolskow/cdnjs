## ShareGate Migrate Copy P.AUOPRTMIGP.10
## sgMigrateCopyGroups5.ps1
## Copy All Groups From SPO to SPOP
## As of: 10/11/2021
## Developer: Tom Molskow, Cognizant

cls

## Get Input File
$csvFile = "C:\Test\Stage\copyGroupsMig.csv"
$table = Import-Csv $csvFile -Delimiter ","

## Import ShareGate Module
Import-Module Sharegate

## Process copyGroupsMig.csv Batch File
foreach ($row in $table)
{

    #try {
    
        ## Set Variables
        $ID = $row.ID
        $spoSite = $row.SPOSite
        $spopSite = $row.SPOPSite

        ## Write Variables to Console
        Write-Host "`$ID = $ID"
        Write-Host "`$spoSite = $spoSite"
        Write-Host "`$spopSite = $spopSite`n"

        ## Connect to SPO and SPOP Sites Using Browser
        $spoSiteSG = Connect-Site -Url $spoSite -Browser -DisableSSO # Connect to SPO Using Browser
        $spopSiteSG = Connect-Site -Url $spopSite -Browser -DisableSSO # Connect to SPOP Using Browser

        ## Connect to SPO and SPOP Sites Using Prompt
        #$Credentials = Get-Credential
        #$spoSiteSG = Connect-Site -Url $spoSite -Credential $Credentials # Connect to SPO Using Prompt

        ## Connect to SPO and SPOP Sites Using Prompt
        #$Credentials = Get-Credential
        #$spopSiteSG = Connect-Site -Url $spopSite -Credential $Credentials # Connect to SPOP Using Prompt

        ## Set Report File Path and Name
        #$CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + $ID + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".xlxs" # Excel Version
        $CopyPermissionsReportPathFile = "C:\Test\Stage\Logs" + $ID + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv" # CSV Version

        ## Import Mappings
        $mappingSettings = Import-UserAndGroupMapping -Path "C:\Test\Stage\EXT-UserGroup-Mapping.sgum" # EXT Site
        #$mappingSettings = Import-UserAndGroupMapping -Path "C:\Test\Stage\INT-UserGroup-Mapping.sgum" # INT Site      
        
        ## Copy Groups
        $copysettings = New-CopySettings -OnContentItemExists Overwrite -OnSiteObjectExists Merge
        $toCopy = Get-Group -Site $spoSiteSG
        $CopyGroups = Copy-Group -Group $toCopy -DestinationSite $spopSiteSG -CopySettings $copysettings -MappingSettings $mappingSettings
        $CopyObjPerm = Copy-ObjectPermissions -Source $spoSiteSG -Destination $spopSiteSG 

        ## Export Report
        #Export-Report -CopyResult $CopyGroups -Path $CopyPermissionsReportPathFile
        Export-Report -CopyResult $CopyObjPerm -Path $CopyPermissionsReportPathFile -Overwrite

        ## Write Completion Message to Console
        Write-Host "`n "    
        Write-Host "Copy For $spopSiteSG Completed, Starting Sleep for 15 Seconds `n"  -ForegroundColor Green
        Start-Sleep -Seconds 15

    #} catch {

        #$ErrorLine = $_.InvocationInfo.ScriptLineNumber
        #$ErrorMessage = $_.Exception.Message
        #Write-Host -f Red "Error has occurred:" $ErrorMessage + " Line: " + $ErrorLine

    #}

}