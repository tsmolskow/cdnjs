$site = Get-SPSite http://atlas-uat.westlake.com/sites/mdm
$proxy = Get-SPServiceApplicationProxy | ?{$_.TypeName -eq 'Workflow Service Application Proxy'}
$proxy.GetHostname($site)
$proxy.GetWorkflowScopeName($site)