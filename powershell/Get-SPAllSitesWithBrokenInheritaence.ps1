Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3" | Get-SPWeb -Limit All | Where { $_.HasUniquePerm -AND $_.ParentWeb -NE $Null } | Select ServerRelativeUrl