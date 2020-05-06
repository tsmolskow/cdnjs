# Regulatory Site Collection Permission Report
# Last Update October 2019
# See User Guide's for More Information 

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$FilePath = "F:\Scripts\Reports\SharePoint_Permission_Report_" + $(get-date -f dd_MM_yyyy_HH_mm_ss) +".csv"
$SiteURL = "https://bentest.bhcorp.ad" 

Function GetUserAccessReport($WebAppURL, $FileUrl)
{
    #!!! Set This Value Equal to the Dev\Test or Production Regulatory Site Collection !!!
    $SiteCollections = Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3/"

    #Append User Level Header
    "******* Security Report - User Level, $($WebApp.Name), $($WebApp.URL) *******" | Out-File $FileUrl

    #Append Web Application Header
    " " | Out-file $FileUrl -Append
    "User Level Security" | Out-file $FileUrl -Append
    “User Name | User Login | Domain Group (True\False)" | Out-file $FileUrl -Append

    $AllSCUsers = Get-SPUser -Web $SiteCollections.Url | Select DisplayName, UserLogin, IsDomainGroup 
    foreach($SCUser in $AllSCUsers){

        "User Name: $($SCUser.DisplayName) | Login: $($SCUser.UserLogin)" | Out-file $FileUrl -Append

    }

    #Append Web Application Header
    " " | Out-file $FileUrl -Append
    "******* Security Report - Web Application Level, $($WebApp.Name), $($WebApp.URL) *******" | Out-File $FileUrl -Append

    #Append Web Application Header
    " " | Out-file $FileUrl -Append
    "Web Application Level Security" | Out-file $FileUrl -Append
    “Web App Group or User | Web App Group or User Permissions" | Out-file $FileUrl -Append

    #Check Web Application Policies
    $WebApp= Get-SPWebApplication $WebAppURL

    foreach ($Policy in $WebApp.Policies)
    {

        $PolicyRoles=@()
        foreach($Role in $Policy.PolicyRoleBindings)
        {
            $PolicyRoles+= $Role.Name +";"
        }

        #Append Web App Security Information
        "Group or User: $($Policy.UserName.ToString().replace('i:0#.w|','')) | Permissions: $($PolicyRoles)” | Out-File $FileUrl -Append

    }

    #*** Site Collection Level Security ***
    #Loop Through All Site Collections

    foreach($Site in $SiteCollections)
    {
        
        #Append Site Collection Header
        " "  | Out-File $FileUrl -Append
        "******* Security Report - Site Collection Level, $($Site.RootWeb.Title), $($Site.RootWeb.Url) *******" | Out-File $FileUrl -Append

        #Append Site Collection Administrator Header
        " "  | Out-File $FileUrl -Append
        "$($Site.RootWeb.Title) Site Collection Administrators" | Out-File $FileUrl -Append
        "Admin Name | Admin Login | Admin Email" | Out-File $FileUrl -Append
        
        #* Site Collection Administrators *
        foreach($SiteCollAdmin in $Site.RootWeb.SiteAdministrators)
        {         
                 
            #Append Site Collection Administrator Security Information
            “Name: $($SiteCollAdmin.DisplayName) | Login: $($SiteCollAdmin.LoginName.ToString().replace('i:0#.w|','')) | Email: $($SiteCollAdmin.Email)" | Out-File $FileUrl -Append 
        }

        #Loop Throuh all Sub-Sites
        foreach($Web in $Site.AllWebs)
        {
         
            #* Site Owners *   
            #Append Site Owner Header
            " "  | Out-File $FileUrl -Append
            "$($Web.Title) Site Owners"  | Out-File $FileUrl -Append
            "Owner Group | Owner Name | Owner Login | Owner Email" | Out-File $FileUrl -Append

            foreach($owner in $Web.AssociatedOwnerGroup.Users) {                

                #Append Site Owner Security Information
                "Group: $($Web.AssociatedOwnerGroup) | Name: $($owner.DisplayName) | Login: $($owner.LoginName.ToString().replace('i:0#.w|','')) | Email: $($owner.Email)" | Out-File $FileUrl -Append

            }

            #* Site Groups *
            #Append Site Groups Header
            " "  | Out-File $FileUrl -Append
            "$($Web.Title) Site Groups" | Out-File $FileUrl -Append
            "Group Name | Group Owner Name | Group Owner Login | Group Members | Group Member Name | Group Member Login" | Out-File $FileUrl -Append

            foreach($groups in $Web.Groups) {

               #Append Site Groups Security Information
               "Group: $($groups.Name) | Owner Name: $($groups.Owner.DisplayName) | Owner Login: $($groups.Owner.LoginName.ToString().replace('i:0#.w|',''))" | Out-File $FileUrl -Append

               foreach($groupUser in $groups.Users){

                  foreach ($userInGroup in $groupUser) {

                    "Name: $($userInGroup.DisplayName) | Login:  $($userInGroup.LoginName.ToString().replace('i:0#.w|',''))" | Out-File $FileUrl -Append

                  }
               }
            }

            #* Site Users *
            #Append Site Users Header
            " "  | Out-File $FileUrl -Append
            "$($Web.Title) Site Users"  | Out-File $FileUrl -Append
            "Site User Group | Group Permission | User Name | User Login " | Out-File $FileUrl -Append

            if($Web.HasUniqueRoleAssignments -eq $True)
            {
                
                #Get All the Users 
                foreach($WebRoleAssignment in $Web.RoleAssignments )
                {
                    
                    #User Account
                    if($WebRoleAssignment.Member.userlogin)
                    {
                        
                        #Permissions Assigned to User
                        $WebUserPermissions=@()

                        foreach ($RoleDefinition  in $WebRoleAssignment.RoleDefinitionBindings)
                        {
                            $WebUserPermissions += $RoleDefinition.Name +";"
                        }

                        #Trim Off Login Prefix String
                        $DirectUserLogin = $WebRoleAssignment.Member.LoginName.ToString()
                        $DirectUserLoginTrim = $DirectUserLogin.replace("i:0#.w|","")

                        #Append Site Direct User Security Information
                        "Group: N/A | Direct Permission: $($WebUserPermissions) | User Name: $($WebRoleAssignment.Member.DisplayName) | User Login: $($DirectUserLoginTrim)” | Out-File $FileUrl -Append
                    }

                #SharePoint Group, Members of the Groups
                else
                {
                     foreach($user in $WebRoleAssignment.member.users)
                {

                    #Permissions Assigned to the Group
                    $WebGroupPermissions=@()

                    foreach ($RoleDefinition  in $WebRoleAssignment.RoleDefinitionBindings)
                    {
                        $WebGroupPermissions += $RoleDefinition.Name +”;”
                    }

                    #Trim Off Login Prefix String
                    $NotDirectUserLogin = $user.LoginName.ToString()
                    $NotDirectUserLoginTrim = $NotDirectUserLogin.replace("i:0#.w|","")

                    #Append Site User Security Information
                    “Group: $($WebRoleAssignment.Member.Name) | Permission: $($WebGroupPermissions) | User Name: $($user.DisplayName) | User Login: $($NotDirectUserLoginTrim)" | Out-File $FileUrl -Append


            }
           }
          }
         }

        #* Check Lists with Unique Permissions *
        foreach($List in $Web.lists)
        {
            if($List.HasUniqueRoleAssignments -eq $True -and ($List.Hidden -eq $false))
        {

        #* Site Lists *
        #Append Site List Header
        " "  | Out-File $FileUrl -Append
        "$($Web.Title) Site List - $($List.Title), $($List.RootFolder.Url)" | Out-File $FileUrl -Append
        "List Group | Group Permissions | Group Members" | Out-File $FileUrl -Append

        #Get All Users Granted Permissions List
        foreach($ListRoleAssignment in $List.RoleAssignments)
        {

            #Is User Granted Direct Permissions
            if($ListRoleAssignment.Member.userlogin)
            {

                #Get the Permissions assigned to user
                $ListUserPermissions=@()

                foreach ($RoleDefinition  in $ListRoleAssignment.RoleDefinitionBindings)
                {
                    $ListUserPermissions += $RoleDefinition.Name +";"
                }

                #Trim Off Login Prefix String
                $ListDirectUserLogin = $ListRoleAssignment.Member.ToString()
                $ListDirectUserLoginTrim = $ListDirectUserLogin.replace("i:0#.w|","")

                #Append Site List Security Information
                "Direct Permission: $($ListRoleAssignment.Member.Name) | Permission: $($ListUserPermissions) |  User: $($ListDirectUserLoginTrim)” | Out-File $FileUrl -Append

            }

            #Check Group Permissions for User
            else
            {
                   
                #Get Group Permissions for the List
                $ListGroupPermissions=@()

                foreach ($RoleDefinition  in $ListRoleAssignment.RoleDefinitionBindings)
                {
                    $ListGroupPermissions += $RoleDefinition.Name +";"
                }
                
                “Group: $($ListRoleAssignment.Member.Name) | Permissions: $($ListGroupPermissions)” | Out-File $FileUrl -Append

                foreach($user in $ListRoleAssignment.member.users){

                    foreach ($listUser in $users) {

                        "User Name: $($user.DisplayName) | Login Name: $($user.LoginName.ToString().replace('i:0#.w|',''))"  | Out-File $FileUrl -Append

                }

                }
            {
            
        }
       }
      }
     }
    }
   }
  }

}

GetUserAccessReport $SiteUrl $FilePath

$WebURL = "https://bentest.bhcorp.ad/sites/regulatory3/" 
$DocLibName = "Security Reports" 
$FilePath2 = $FilePath

$Web = Get-SPWeb $WebURL 
$List = $Web.GetFolder($DocLibName) 
$Files = $List.Files
$FileName = $FilePath2.Substring($FilePath2.LastIndexOf("\")+1)
$File= Get-ChildItem $FilePath2

$Files.Add($DocLibName +"/" + $FileName,$File.OpenRead(),$false) 

$web.Dispose()