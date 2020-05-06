Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3" | Get-SPWeb -Limit All | Select -ExpandProperty Lists | Select -ExpandProperty Folders | Where { $_.HasUniqueRoleAssignments } | Select {$_.ParentList.ParentWebUrl + "/" + $_.ParentList.Title + "/" +$_.DisplayName}