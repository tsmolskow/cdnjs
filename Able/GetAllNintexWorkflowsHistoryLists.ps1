[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null 
$outputFile = "e:\scripts\output\AllworkflowHistoryLists-NEW-UAT-03282022-a.csv"

$farm = [Microsoft.SharePoint.Administration.SPFarm]::local
$websvcs = $farm.Services | where -FilterScript {$_.GetType() -eq [Microsoft.SharePoint.Administration.SPWebService]} 
$webapps = @() 

#$outputHeader = "HistoryList,ItemCount" > $outputFile
$outputHeader = "`"" + "HistoryList" + "`"" > $outputFile

foreach ($websvc in $websvcs) { 

 foreach ($webapp in $websvc.WebApplications) { 
  foreach ($site in $webapp.Sites) {
   foreach ($web in $site.AllWebs) {
    foreach ($List in $web.Lists) {
      if ($List.BaseTemplate -eq "WorkflowHistory"){
      #$output = $web.Url + $List.RootFolder + "," + $list.ItemCount
      $output = "`"" + $web.Url + "/" + "`"" + "," + $list.ItemCount
      Write-Output $output >> $outputFile
      }
     }
    } 
   } 
  }
 }
$Web.Dispose();
$site.Dispose();