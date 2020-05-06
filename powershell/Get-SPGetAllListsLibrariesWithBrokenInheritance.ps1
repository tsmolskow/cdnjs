Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3" | Get-SPWeb -Limit All | Select -ExpandProperty Lists | Where { $_.HasUniqueRoleAssignments -AND -NOT $_.Hidden } | Select Title, ParentWebUrl