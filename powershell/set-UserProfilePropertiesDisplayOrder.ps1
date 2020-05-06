if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$site = new-object Microsoft.SharePoint.SPSite("https://bentest.bhcorp.ad:3873");
$serviceContext = Get-SPServiceContext $site;                     
$upm = new-object Microsoft.Office.Server.UserProfiles.UserProfileManager($serviceContext);

$userProfile = $upm.GetUserProfile("bhcorp\twendt");
$userProfile.Properties | sort DisplayName | FT DisplayName,Name,@{Label="Type";Expression={$_.CoreProperty.Type}}

#$userProfile.Properties.SetDisplayOrderByPropertyName("UserProfile_GUID",1)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SID",2)
#$userProfile.Properties.SetDisplayOrderByPropertyName("ADGuid",3)
#$userProfile.Properties.SetDisplayOrderByPropertyName("AccountName",4)
#$userProfile.Properties.SetDisplayOrderByPropertyName("FirstName",8)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SPS-PhoneticFirstName",12)
#$userProfile.Properties.SetDisplayOrderByPropertyName("LastName",16)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SPS-PhoneticLastName",20)
#$userProfile.Properties.SetDisplayOrderByPropertyName("PreferredName",24)
#$userProfile.Properties.SetDisplayOrderByPropertyName("WorkPhone",28)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SPS-PhoneticDisplayName",32)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Department",36)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Title",40)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SPS-JobTitle",44)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SPS-Department",48)
#$userProfile.Properties.SetDisplayOrderByPropertyName("departmentNumber",52)
#$userProfile.Properties.SetDisplayOrderByPropertyName("employeeID",54)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Manager",56)
#$userProfile.Properties.SetDisplayOrderByPropertyName("AboutMe",60)
#$userProfile.Properties.SetDisplayOrderByPropertyName("PersonalSpace",64)
#$userProfile.Properties.SetDisplayOrderByPropertyName("PictureURL",68)
#$userProfile.Properties.SetDisplayOrderByPropertyName("UserName",72)
#$userProfile.Properties.SetDisplayOrderByPropertyName("QuickLinks",76)
#$userProfile.Properties.SetDisplayOrderByPropertyName("WebSite",80)
#$userProfile.Properties.SetDisplayOrderByPropertyName("PublicSiteRedirect",84)

#$userProfile.Properties.SetDisplayOrderByPropertyName("WorkEmail",5100)
#$userProfile.Properties.SetDisplayOrderByPropertyName("CellPhone",5104)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Fax",5108)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Pager",5112)
#$userProfile.Properties.SetDisplayOrderByPropertyName("HomePhone",5116)
#$userProfile.Properties.SetDisplayOrderByPropertyName("CalloutNotes",5118)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Office",5120)
#$userProfile.Properties.SetDisplayOrderByPropertyName("SPS-Location",5124)
#$userProfile.Properties.SetDisplayOrderByPropertyName("OfficeCity",5128)
#$userProfile.Properties.SetDisplayOrderByPropertyName("State",5132)
#$userProfile.Properties.SetDisplayOrderByPropertyName("Zip",5136)

#$userProfile.Properties.SetDisplayOrderByPropertyName("Assistant",5150)

$userProfile.Properties.CommitDisplayOrder()

$userProfile.properties | ft name,displayorder
