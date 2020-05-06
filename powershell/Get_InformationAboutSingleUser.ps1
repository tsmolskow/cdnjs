Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

Get-SPUser -web "https://bentest.bhcorp.ad/" -Identity "bhcorp\tomolsko_sa" | Select ID, UserLogin, DisplayName