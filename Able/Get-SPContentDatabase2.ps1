asnp *sh*
#Get all SharePoint content databases available
$ContentDatabases = Get-SPContentDatabase
#Loop through each content database
 foreach($ContentDb in $ContentDatabases)
  {
   Write-Host "`nContent Database Name:  $($ContentDb.Name) Size:$($ContentDb.DiskSizeRequired/1MB) MB " -ForegroundColor DarkGreen
 #Get all site collections in the content database
 Write-Host "Site Collections List:" -ForegroundColor Blue
     foreach($site in $ContentDb.Sites)
     {
        write-host $site.url
     }
 }