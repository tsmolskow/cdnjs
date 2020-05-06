if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$site = new-object Microsoft.SharePoint.SPSite("https://bentest.bhcorp.ad:3873");
$site = new-object Microsoft.SharePoint.SPSite("http://bhdcprojd01:44945");
$serviceContext = Get-SPServiceContext $site;            
$connectionName = “BHE AD Import” #Name of the SharePoint synchronization connection

$spsProperty = "OfficeState” #InternalSharePoint user profile property
$fimProperty = “st”  #Aattribute in LDAP

#$spsProperty = "OfficeZip” #InternalSharePoint user profile property
#$fimProperty = “postalCode”  #Aattribute in LDAP

#$spsProperty = “departmentNumber” #NOT display name but InternalSharePoint user profile property
#$fimProperty = “departmentNumber” #Aattribute in LDAP

$upManager = new-object Microsoft.Office.Server.UserProfiles.UserProfileConfigManager($serviceContext)
$synchConnection = $upManager.ConnectionManager[$connectionName]

$synchConnection.PropertyMapping.AddNewMapping([Microsoft.Office.Server.UserProfiles.ProfileType]::User, $spsProperty, $fimProperty)
