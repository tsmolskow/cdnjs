Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPUser -Web "https://bentest.bhcorp.ad/sites/regulatory3" | Where { $_.IsDomainGroup }