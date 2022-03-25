## spGetUserProfileDataAdmin2.ps1
## Process Profile Queries, Output CSV File Report  
## Must be Run in the Farm Admin Account
## Tom Molskow, Able Solutions
## As Of 3/14/2022

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
## Configuration Variables
$dtgDateTime1 = get-date -uformat %d-%m-%Y-%H.%M.%S
$SiteURL = "http://houasspd01d:2016" # http://houasspd01d:2016
$outputReport = "c:\scripts\CSVOutput\UserProfileReport" + $dtgDateTime1 + ".csv"

## Script Start Time
Write-Host "Script Start Time:" $dtgDateTime1 "`n" -f Green

## Get Objects
$ServiceContext  = Get-SPServiceContext -site $SiteURL
$UPM = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($ServiceContext) 

## Get All User Profiles
$UserProfiles = $UPM.GetEnumerator()
 
## Create Array to Hold Create Profiles
$ProfileDataCollection = @() 
 
## Iterate Through Each Profile
foreach ($Profile in $UserProfiles)
{

    $ProfileData = New-Object PSObject 

    #Retrieve User Profile Properties 
    
    $ProfileData | Add-Member -MemberType NoteProperty -name "User Login" -value $Profile["UserLogin"] 

    $ProfileData | Add-Member -MemberType NoteProperty -name "Account Name" -value $Profile["AccountName"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "First Name" -value $Profile["FirstName"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Last Name" -value $Profile["LastName"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Preferred Name" -value $Profile["PreferredName"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Work Email" -value $Profile["WorkEmail"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "About Me" -value $Profile["AboutMe"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Picture URL" -value $Profile["PictureURL"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Title" -value $Profile["Title"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "SPS SIP Address" -value $Profile["SPS-SipAddress"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Web Site" -value $Profile["WebSite"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "SPS Responsibility" -value $Profile["SPS-Responsibility"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Office" -value $Profile["Office"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Picture Time Stamp" -value $Profile["SPS-PictureTimestamp"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Picture Placeholder State" -value $Profile["SPS-PicturePlaceholderState"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Picture Exchange Sync State" -value $Profile["SPS-PictureExchangeSyncSta"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Role" -value $Profile["Role"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Department" -value $Profile["SPS-Department"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Manager" -value $Profile["Manager"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Location" -value $Profile["SPS-Location"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Home Phone" -value $Profile["HomePhone"]

    $ProfileData | Add-Member -MemberType NoteProperty -name "Work Phone" -value $Profile["WorkPhone"]

   
    #Add User Profile to Array
    $ProfileDataCollection+=$ProfileData
    write-host "Processed Profile:"$profile["PreferredName"]

}

## Export User Profile Data to CSV
$ProfileDataCollection | Export-Csv $outputReport -NoType
Write-Host "`n User Profile Report written to -" $outputReport -f Green

## Script End Time
$dtgDateTime2 = get-date -uformat %d-%m-%Y-%H.%M.%S
Write-Host "`n Script End Time:" $dtgDateTime2 -f Green




