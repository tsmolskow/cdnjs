asnp *sh*

###############################################################
#Run these cmdlets on SharePoint server for new OOS farm

New-SPWOPIBinding -ServerName houasspo11t.westlake.wlg.int -AllowHTTP

Get-SPWOPIBinding

Get-SPWOPIZone

Set-SPWOPIZone -zone "internal-http"

(Get-SPSecurityTokenServiceConfig).AllowOAuthOverHttp

#If False is returned, run these cmdlets

$config = (Get-SPSecurityTokenServiceConfig)

$config.AllowOAuthOverHttp = $false

$config.Update()

############################################################
#Run the following command again to verify that the AllowOAuthOverHttp setting is now set to True.
#To enable the Excel SOAP API, run the following PowerShell where is the URL of your Office Online Server farm. (For example, http://OfficeOnlineServer.contoso.com.)

(Get-SPSecurityTokenServiceConfig).AllowOAuthOverHttp

############################################################
#The Excel SOAP API is needed for scheduled data refresh with Excel Online, and for Excel Web Part rendering.

$Farm = Get-SPFarm
$Farm.Properties.Add("WopiLegacySoapSupport", "<URL>/x/_vti_bin/ExcelServiceInternal.asmx");
$Farm.Update();

############################################################
#If, for any reason, you want to disconnect SharePoint Server 2016 from Office Online Server, use the following command example.

Remove-SPWOPIBinding -All:$true


Update-SPWOPIProofKey -ServerName "HOUASSPO11T.WESTLAKE.WLG.INT"