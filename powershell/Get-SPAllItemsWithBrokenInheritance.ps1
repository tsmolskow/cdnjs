Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3"  | Get-SPWeb -Limit All | Select -ExpandProperty Lists | Select -ExpandProperty Items | Where { $_.HasUniqueRoleAssignments } | Select Name, {$_.ParentList.ParentWebUrl + "/" + $_.ParentList.Title}