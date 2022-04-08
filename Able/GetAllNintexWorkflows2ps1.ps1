#[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null 
$outputFile = Read-Host "Filename and location (e.g. C:\output.csv)"

$farm = [Microsoft.SharePoint.Administration.SPFarm]::local
$websvcs = $farm.Services | where -FilterScript {$_.GetType() -eq [Microsoft.SharePoint.Administration.SPWebService]} 
$webapps = @() 

$outputHeader = "Name;Author;Enabled;URL;Title;Running Instances" > $outputFile

foreach ($websvc in $websvcs) { 

 foreach ($webapp in $websvc.WebApplications) { 
  foreach ($site in $webapp.Sites) {
   foreach ($web in $site.AllWebs) {
    foreach ($List in $web.Lists) {
     foreach ($workflow in $List.WorkflowAssociations) {
	  if ($workflow.Name -notlike "*Previous Version*") {
      $output = $workflow.Name + ";" + $workflow.Author + ";" + $workflow.Enabled + ";" + $web.Url + ";" + $List.Title + ";" + $workflow.RunningInstances 
      Write-Output $output >> $outputFile
      }
     }
    } 
   } 
  }
 }
}
$Web.Dispose();
$site.Dispose();