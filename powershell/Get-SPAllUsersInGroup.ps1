Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3/arkansas" | Select -ExpandProperty RootWeb | Select -ExpandProperty Groups | Where {$_.Name -EQ "Arkansas Legal"} | Select -ExpandProperty Users | Select Name, Email