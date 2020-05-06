Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

$web = Get-SPWeb "https://bentest.bhcorp.ad/sites/regulatory3"
$web.AssociatedOwnerGroup.Users