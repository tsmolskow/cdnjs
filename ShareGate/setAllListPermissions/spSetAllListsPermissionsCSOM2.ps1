# spSetAllListsPermissionsCSOM2

cls

Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Proivde your details: SharePoint Site Url, UserName and Password   
$SiteUrl="https://eyonespace.ey.com/Sites/536a5ebeec1044b0b8accf5c44547c41"
$UserName = "P.AUOPRTMIGP.10@ey.com"
$Password = 'cL95H@urF7~Vk3%'
$SecPwd = $(ConvertTo-SecureString $Password -asplaintext -force)  

#Connecting site web
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)  
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,$SecPwd)  
$ctx.credentials = $credentials
$ctx.Load($ctx.Web) 
$ctx.ExecuteQuery()
 
#Find list by Title
$list=$ctx.Web.Lists.GetByTitle("Documents") 
$ctx.Load($list) 
$ctx.ExecuteQuery()