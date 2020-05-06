cls

Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue
Backup-SPSite https://bentest.bhcorp.ad/sites/cptestsecurity -Path F:\backups\Regulatory3\backupCPTest.bak

              

