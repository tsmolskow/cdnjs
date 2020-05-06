$site = new-object Microsoft.SharePoint.SPSite("https://bhdcprojd01.bhcorp.ad")
#$site = new-object Microsoft.SharePoint.SPSite("http://bhdcprojd01:44945")

$context = [Microsoft.SharePoint.SPServiceContext]::GetContext($site)
$configManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileConfigManager $context
$UPAConnMgr = $configManager.ConnectionManager
$Connection = ($UPAConnMgr | select -First 1)

if ($Connection.Type -eq "ActiveDirectoryImportConnection") {
  $Connection.AddPropertyMapping("OfficeState","st")
  $Connection.Update()
}
