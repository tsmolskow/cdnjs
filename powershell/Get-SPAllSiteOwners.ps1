Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

$web = Get-SPWeb "https://bentest.bhcorp.ad/sites/regulatory3" 
#$web.AssociatedOwnerGroup.Users

foreach($owner in $Web.AssociatedOwnerGroup.Users) {

  Write-Host "Ownwer User Login:" $($owner.LoginName) "| Display Name:" $($owner.DisplayName) "| Owner Group:" $($Web.AssociatedOwnerGroup)

}