cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
  
 #Set the Content Database Name
 $ContentDbName = "SPS_Content_Regulatory"
 #Get the Content Database
 $ContentDb = Get-SPContentDatabase -Identity $ContentDbName
  #Iterate through each site collection in the Content database
  foreach($site in $ContentDb.Sites)
 {
  write-host $site.url
 }

