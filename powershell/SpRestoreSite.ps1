cls

Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue
Restore-SPSite https://bentest.bhcorp.ad/sites/cptestsecurity2 -Path F:\installs\Transfer\Regulatory\Regulatory2-28-20.bak -DatabaseName SPS_Regulatory_Content_2 -Force

               