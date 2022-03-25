## spSetUserProfileDataGInput.ps1
## Uses Golden Inventory CSV as Input File
## CSV File Input, Batch Process Profile Updates, Output CSV File Report 
## Must be Run in the Farm Admin Account 
## Tom Molskow, Able Solutions
## As Of 3/23/2022

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

## Set Site URL Variable
$SiteURL = "http://houasspd01d:2016" # http://houasspd01d:2016

## Process spoProfileUpdate File
$csvFile = "C:\Scripts\CSVInput\UserProfileDBUpdateGold.csv"
Write-Host "CSV input file location:" $csvFile
$table = Import-Csv $csvFile -Delimiter ","

## Date Time Group Variable
$dtgDateTime = get-date -uformat %d-%m-%Y-%H.%M.%S

## Create An Error Log
$errorLog  = "c:\scripts\ErrorLog\ErrorLog" + $dtgDateTime + ".csv"
Write-Host "Error Log Output File Location:" $errorLog "`n"
"Error Message Logs: " | Out-File $errorLog 

## Create Profile Report Variables
$outputReport = "c:\scripts\CSVOutput\UserProfileUpdateReport" + $dtgDateTime + ".csv"
Write-Host "CSV Output File Location:" $outputReport "`n"
$ProfileDataCollection = @() 

## Process CSV Input File
foreach ($row in $table)
{

#Create Profile Object
$ProfileData = New-Object PSObject

#Set Variable Values Equal to Table Values
$AccountName = 'Westlake\' + $row.'SamAccountName'
$FirstName = $row.'GivenName'
$LastName = $row.'Surname'
$PreferredName = ""
$WorkEmail = $row.'Mail'
$AboutMe =  ""
$PictureURL =  ""
$Title  = ""
$SPSSipAddress =  ""
$WebSite =  ""
$SPSResponsibility =  ""
$Office =  ""
$SPSPictureTimestamp =  ""
$SPSPicturePlaceholderState =  ""
$SPSPictureExchangeSyncState =  ""
$Role =  ""
$Department =  ""
$Manager =  ""
$SPSLocation = $row.'Location'
$WorkPhone =  ""
$HomePhone =  ""

Write-Host "Profile Summary Data:" $AccountName"," $FirstName $LastName"," $Department #For Testing

#Get User Profile Objects
#$UserLogin = $AccountName
$ServiceContext  = Get-SPServiceContext -site $SiteURL
$UserProfileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($ServiceContext)
 
    #Update Profile
    if ($UserProfileManager.UserExists($AccountName))
    {
        #Get the User Profile
        $Profile = $UserProfileManager.GetUserProfile($AccountName)
        
        #$Profile["AccountName"].Value = $AccountName
        $ProfileData | Add-Member -MemberType NoteProperty -name "Account Name" -value $Profile["AccountName"] 

        $Profile["FirstName"].Value = $FirstName
        $ProfileData | Add-Member -MemberType NoteProperty -name "First Name" -value $Profile["FirstName"]

        $Profile["LastName"].Value = $LastName
        $ProfileData | Add-Member -MemberType NoteProperty -name "Last Name" -value $Profile["LastName"]

        $Profile["PreferredName"].Value = $PreferredName
        $ProfileData | Add-Member -MemberType NoteProperty -name "Preferred Name" -value $Profile["PreferredName"]

        $Profile["WorkEmail"].Value = $WorkEmail
        $ProfileData | Add-Member -MemberType NoteProperty -name "Work Email" -value $Profile["WorkEmail"]

        $Profile["AboutMe"].Value = $AboutMe
        $ProfileData | Add-Member -MemberType NoteProperty -name "About Me" -value $Profile["AboutMe"]

        $Profile["PictureURL"].Value = $PictureURL
        $ProfileData | Add-Member -MemberType NoteProperty -name "Picture URL" -value $Profile["PictureURL"]

        $Profile["Title"].Value = $Title
        $ProfileData | Add-Member -MemberType NoteProperty -name "Title" -value $Profile["Title"]

        $Profile["SPS-SipAddress"].Value = $SPSSipAddress
        $ProfileData | Add-Member -MemberType NoteProperty -name "SPS-SipAddress" -value $Profile["SPS-SipAddress"]

        $Profile["WebSite"].Value = $WebSite
        $ProfileData | Add-Member -MemberType NoteProperty -name "WebSite" -value $Profile["WebSite"]

        $Profile["SPS-Responsibility"].Value = $SPSResponsibility
        $ProfileData | Add-Member -MemberType NoteProperty -name "SPS-Responsibility" -value $Profile["SPS-Responsibility"]

        $Profile["Office"].Value = $Office
        $ProfileData | Add-Member -MemberType NoteProperty -name "Office" -value $Profile["Office"]

        $Profile["SPS-PictureTimestamp"].Value = $SPSPictureTimestamp
        $ProfileData | Add-Member -MemberType NoteProperty -name "SPS-PictureTimestamp" -value $Profile["SPS-PictureTimestamp"]

        $Profile["SPS-PicturePlaceholderState"].Value = $SPSPicturePlaceholderState
        $ProfileData | Add-Member -MemberType NoteProperty -name "SPS-Picture Placeholder State" -value $Profile["SPS-PicturePlaceholderState"]

        $Profile["SPS-PictureExchangeSyncState"].Value = $SPSPictureExchangeSyncState
        $ProfileData | Add-Member -MemberType NoteProperty -name "SPS-Picture Exchange Sync State" -value $Profile["SPS-PictureExchangeSyncState"]

        $Profile["Role"].Value = $Role
        $ProfileData | Add-Member -MemberType NoteProperty -name "Role" -value $Profile["Role"]

        $Profile["SPS-Department"].Value = $SPSDepartment
        $ProfileData | Add-Member -MemberType NoteProperty -name "Department" -value $Profile["SPS-Department"]

        try{
            
            $Profile["Manager"].Value = $Manager
            $ProfileData | Add-Member -MemberType NoteProperty -name "Manager" -value $Profile["Manager"]

        } catch {

             "Getting Manager account '$Manager' failed $(Get-Date). Error: $($_.Exception.Message)" | Out-File $errorLog -Append
        }

        $Profile["SPS-Location"].Value = $SPSLocation
        $ProfileData | Add-Member -MemberType NoteProperty -name "SPS-Location" -value $Profile["SPS-Location"]

        $Profile["WorkPhone"].Value = $WorkPhone
        $ProfileData | Add-Member -MemberType NoteProperty -name "WorkPhone" -value $Profile["WorkPhone"]

        $Profile["HomePhone"].Value = $HomePhone
        $ProfileData | Add-Member -MemberType NoteProperty -name "HomePhone" -value $Profile["HomePhone"]

        #Commit Changes
        try {
            
            $Profile.Commit()
            #write-host "User Information Updated Successfully!" -f Green 

        } catch {

            Write-Warning -Message “There is an issue. `n” -f Red
            Write-Warning $Error[0] | Out-File $errorLog -Append
        } 

        #Add to Array
        $ProfileDataCollection+=$ProfileData
        write-host "Processed profile report for:"$profile["AccountName"] "successfully! `n" -f Green

    }
    else
    {
        write-host "$($AccountName) Not Found - No Updates Made! `n" -f Red | Out-File $errorLog -Append
    }

}

## Export User Profile data to CSV
$ProfileDataCollection | Export-Csv $outputReport -NoType

## Start spSetUserListDataAdmin3.ps1
Start-Process Powershell.exe -Argument "-File C:\Scripts\spSetUserListDataAdmin3.ps1"