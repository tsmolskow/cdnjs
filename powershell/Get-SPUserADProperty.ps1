Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

$aSiteCollection = "https://bentest.bhcorp.ad/sites/regulatory3";
$serviceContext = Get-SPServiceContext($aSiteCollection);
$profileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($serviceContext);
$profileManager.GetUserProfile("bhcorp\tomolsko").GetProfileValueCollection("department")