

$dt = Get-Date 
$mth = $dt.Month
if($mth -eq 1 -or $mth -eq 2 -or $mth -eq 3 -or $mth -eq 4 -or $mth -eq  5 -or $mth -eq 6 -or $mth -eq 7 -or $mth -eq 8 -or $mth -eq 9)
{
$mth = "0"+$mth;
}
$dte = $dt.Day.ToString()+ '_' + $mth.ToString() + '_' + $dt.Year.ToString() +'_'+ $dt.Hour.ToString() + '_' + $dt.Minute.ToString() + '_' + $dt.Second.ToString();

$trPath = "C:\Test\MigrationLog_" + $dte + ".txt"
$timeStamp = "C:\Test\MigrationTimeLog_" + $dte + ".csv"
New-Item -Path $timeStamp -ItemType file -Force
Add-Content -Path $timeStamp -Value "SiteURL,MigrationTime"

Start-Transcript $trPath
$startTime = Get-Date
Import-Module Sharegate
#Path of user mapping file to be used during sharegate migration
$mappings = Import-UserAndGroupMapping -Path "C:\SharegateMigrationReports\UserandGroupMappings.sgum"

$copysettings = New-CopySettings -OnContentItemExists IncrementalUpdate

#Path of site objects mapping file to be used during sharegate migration
$csvFile = "D:\Rupesh\Scripts\SharegateMigrationReports\Migrate Content Scripts\Input\Batch 3\Special 2 PAS Sites\Rupesh_Special2_CopyStructure.csv"
$table = Import-Csv $csvFile -Delimiter "^"

$srcCred = Get-Credential -Message "Credentials for Source Site.."

$dstCred = Get-Credential -Message "Credentials for Destination Site.."
$excludedlist = @(
    "Site Assets",
    "Engagement Library Status",
    "EngagementTools",
    "App Links",
    "Contacts",
    "Site Pages",
    "Web Part Gallery",
    "MicroFeed",
    "Style Library",
    "Master Page Gallery",
    "Form Templates",
    "appdata",
    "Composed Looks",
    "Content type publishing error log",
    "Converted Forms",
    "List Template Gallery",
    "Search Config List",
    "Solution Gallery",
    "TaxonomyHiddenList",
    "Theme Gallery",
    "Search Config List",
    "wfpub",
    "Workflows"
    )

$srcSiteAddress = "";
$result = "";

Set-Variable dstSite, dstList
$indx = 1;
$ttl = $table.Length

foreach ($row in $table) {
    $ListTitle = $row.Title
    if($excludedlist.Contains($ListTitle) -or $ListTitle -like "*_Tools*")
        {
            Write-Host "Executing Row Number: $indx of total: $ttl" -BackgroundColor Green
            $indx++;
            Write-Host $ListTitle " is excluded from migration process" -BackgroundColor Magenta
 
        }
    else
        {
            Write-Host "Executing Row Number: $indx of total: $ttl" -BackgroundColor Green
            $indx++;

            if($srcSiteAddress -eq $row.SiteAddress){
            
            $msg2 = "Copying List structure for " + $ListTitle + " - from Site URL: " + $srcSiteAddress + " to Destination " + $destinationSite
            Write-Host $msg2 -BackgroundColor Magenta 
                        
            Copy-List -SourceSite $srcSite -Name $ListTitle -DestinationSite $dstSite
 
            Write-Host "Structure Copy successful.." -BackgroundColor Green
            
            
            }
            
        else
            {
            $nowTime = Get-Date
            if($srcSiteAddress -ne "")
            {
                $tdiff = $nowTime - $prevTime
                $stamp = $srcSiteAddress + "," + $tdiff
                Add-Content -Path $timeStamp -Value $stamp
            }

            #Get Source site address from CSV
            $srcSiteAddress = $row.SiteAddress
            $srcSite = $null
            $dstSite = $null
            #Get source site from URL if it is unique
            $srcSite = Connect-Site -Url $srcSiteAddress -Username $srcCred.UserName -Password $srcCred.Password
                        
            #Desitnation site address
            $destinationSite = $row.DestinationAddress
            $dstSite = Connect-Site -Url $destinationSite -Username $dstCred.UserName -Password $dstCred.Password 
                        
            $prevTime = Get-Date

            $msg2 = "Copying List structure for " + $ListTitle + " - from Site URL: " + $srcSiteAddress + " to Destination " + $destinationSite
            Write-Host $msg2 -BackgroundColor Magenta 
                        
            Copy-List -SourceSite $srcSite -Name $ListTitle -DestinationSite $dstSite
 
            Write-Host "Structure Copy successful.." -BackgroundColor Green
            }
            
        }

    
}
 
$endTime = Get-Date
$tdiff = $endTime - $prevTime
$stamp = $srcSiteAddress + "," + $tdiff
Add-Content -Path $timeStamp -Value $stamp
$runtime = $endTime - $startTime

$totalTime = "Total Execution Time," + $runtime
Write-Host $totalTime
Add-Content -Path $timeStamp -Value $totalTime
Stop-Transcript