## spSetUserListDataAdmin3.ps1
## Update User List Data Directly from the Profile DB 
## Must be Run in the Farm Admin Account
## Tom Molskow, Able Solutions
## As Of 3/14/2022
## https://www.thelazyitadmin.com/update-sharepoint-user-information-list/

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ea 0

## Set Date Time Group Variable
$dtgDateTime = get-date -uformat %d-%m-%Y-%H.%M.%S

## Create Profile Report Variables
$outputReport = "c:\scripts\CSVOutput\UserListUpdateReport" + $dtgDateTime + ".csv"
Write-Host "CSV output file location:" $outputReport "`n" -f Green

## Define Property Map Array
$ErrorActionPreference = "SilentlyContinue"
$PropertyMap=@(
  "Title,PreferredName,DisplayName",
  "EMail,WorkEmail,EMail",
  "MobilePhone,CellPhone,Mobile Phone",
  "Notes,AboutMe,About Me",
  "SipAddress,WorkEmail,Sip Address",
  "Picture,PictureURL,Picture URL",
  "Department,Department,Department",
  "JobTitle,SPS-JobTitle,Job Title",
  "FirstName,FirstName,First Name",
  "LastName,LastName,Last Name",
  "WorkPhone,WorkPhone,Work Phone",
  "UserName,UserName,UserName",
  "WebSite,WebSite,WebSite",
  "SPSResponsibility,SPS-Responsibility,Ask About Me",
  "Office,Office,Office"
)

## Get SP Farm Context
$Context = Get-SPServiceContext $(Get-SPWebApplication -IncludeCentralAdministration | ? {$_.IsAdministrationWebApplication}).Url

## Get Profile Manager Object
$ProfileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($Context)

If ($ProfileManager){
    
    # Process Thru Each SP Site User List in the SP Sites
    ForEach ($Site in $(Get-SPSite -Limit All | ? {!$_.Url.Contains("Office_Viewing_Service_Cache")})){
        $RootWeb = $Site.RootWeb
        Write-Host "Searching against this location: $($Site.Url) `n" -f Green
 
        # Process Thru Each User in the SP Site User List
        ForEach ($User in $($RootWeb.SiteUsers)){
           
            If ($ProfileManager.UserExists($($User.UserLogin))){

                $UPUser = $ProfileManager.GetUserProfile($($User.UserLogin))
                $UserList = $RootWeb.SiteUserInfoList
                $Query = New-Object Microsoft.SharePoint.SPQuery
                $Query.Query = "<Where><Eq><FieldRef Name='Name' /><Value Type='Text'>$($User.UserLogin)</Value></Eq></Where>"
                $UserItem = $UserList.GetItems($Query)[0]

                # Process Thru the User Property Map for Each User 
                ForEach ($Map in $PropertyMap){

                    $PropName = $Map.Split(',')[0]
                    $SiteProp = $UserItem[$PropName]
                    $UPSProp = $UPUser[$($Map.Split(',')[1])].Value
                    $DisplayName = $Map.Split(',')[2]

                    If ($PropName -eq "Notes"){  
                        if($UPSProp[0] -ne ""){
                            #if($SiteProp -ne $UPSProp){
                                Write-Host "  $DisplayName changed from $SiteProp to $($UPSProp[0].Replace("&nbsp;"," "))" 
                                "$DisplayName changed from $SiteProp to $($UPSProp[0].Replace("&nbsp;"," "))" | Out-File $outputReport -Append
                                $UserItem[$PropName] = $($UPSProp[0].Replace("&nbsp;"," "))
                            #}
                        }
                        Write-Host "Notes: " $UPSProp[0]
                    }
                    ElseIf($PropName -eq "Picture"){
                        if($UPSProp[0] -ne ""){
                            #if($SiteProp -ne $UPSProp){
                                Write-Host "  $DisplayName changed from $($SiteProp.Split(",")[0]) to $($UPSProp[0])" 
                                "$DisplayName changed from $($SiteProp.Split(",")[0]) to $($UPSProp[0])" | Out-File $outputReport -Append
                                $UserItem[$PropName] = $UPSProp[0]
                            #}
                        }
                        Write-Host "Picture: " $UPSProp[0]
                    }
                    ElseIf($PropName -eq "SPSResponsibility"){
                        if($UPSProp[0] -ne ""){
                            #if($SiteProp -ne $UPSProp){
                                Write-Host "  $DisplayName changed from $SiteProp to $($UPSProp -join ', ')"
                                "$DisplayName changed from $SiteProp to $($UPSProp -join ', ')" | Out-File $outputReport -Append
                                $UserItem[$PropName] = $($UPSProp -join ', ')
                            #}
                        }
                        Write-Host "SPSResponsibility: " $UPSProp[0]
                    }
                    Else{
                        if($UPSProp[0] -ne ""){
                            #if($SiteProp -ne $UPSProp){
                                Write-Host "  $DisplayName changed from $SiteProp to $UPSProp"
                                "$DisplayName changed from $SiteProp to $UPSProp" | Out-File $outputReport -Append
                                $UserItem[$PropName] = $UPSProp
                            #}
                        }
                        
                    }
                
                }
                
                # Write Results to Console and Output File
                Write-host "`n Processed user information list report for $($User.UserLogin) successfully!" -f Green
                "Processed user information list report for $($User.UserLogin) successfully!`r`n" | Out-File $outputReport -Append
                Write-Host " Saving: $($User.UserLogin)`n" -f Green
                $UserItem.SystemUpdate()

            }
        }
        $RootWeb.Dispose()
        Write-Host ""
    }
}

Else{
    
    # Write Error Message to Console
    Write-Host -foreground red "Cant connect to the User Profile Service. Please make sure that the UPS is connected to the Central Administration Web Application. Also make sure that you have Administrator Rights to the User Profile Service"
}
Update Domain Login
