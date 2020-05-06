Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3" | Select -ExpandProperty RootWeb | Select -ExpandProperty Groups | Select {$_.ParentWeb.Url}, Name