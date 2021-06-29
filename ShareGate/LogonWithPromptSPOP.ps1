##Load SharePoint CSOM Assemblies
#Does Not Work with SPO Sites, SP On-Prem Only

Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
Cls

##Config Variable
$SiteURL = "https://us.eyonespace.ey.com/Sites/f8151001268342838b959d7f33ed2e29"
#$SiteURL = "https://eyonespace.ey.com/Sites/fe1527d7f0e7466ea3f11c51beeaa97e"
#$SiteURL = "https://us.eyonespace.ey.com/Sites/eb3c0602f35f4adf9336638e4bf02d34"
#$SiteURL = "https://us.tdm.ey.net/sites/0899cb2fb0be428aaefafd26ad7293bc"
#$SiteURL = "https://us.tdm.ey.net/sites/5afc1e13eac141aaa518d70b34a0fbff"
#$SiteURL = "https://us.tdm.ey.net/sites/aea2edb2c272474392bb04b3fe9b8ba4"

 
##Setup Credentials to Connect with Prompt
$Cred = Get-Credential
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
