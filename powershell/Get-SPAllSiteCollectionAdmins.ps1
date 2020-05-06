Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite -Limit All | Select Url, Owner, SecondaryContact