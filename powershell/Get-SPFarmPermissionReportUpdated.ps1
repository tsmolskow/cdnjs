# Regulatory Site Collection Permission Report
# Last Update 10/1/2019
# See User Guide's for More Information 

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$FilePath = "F:\Scripts\Reports\SharePoint_Permission_Report_" + $(get-date -f dd_MM_yyyy_HH_mm_ss) +".csv"
$SiteURL = "https://bentest.bhcorp.ad" 

Function GetUserAccessReport($WebAppURL, $FileUrl)
{
    #!!! Set This Value Equal to the Dev\Test or Production Regulatory Site Collection !!!
    $SiteCollections = Get-SPSite "https://bentest.bhcorp.ad/sites/regulatory3/"

    #Append Web Application Header
    "******* Web Application Security *******" | Out-File $FileUrl -Append

    #*** Web Application Level Security ***
    #Append Web Application Header
    "Web Application Level Security" | Out-file $FileUrl -Append
    “Web App URL | Web App Name | Web App Permissions | Web App Security Group" | Out-file $FileUrl -Append

    #Check Web Application Policies
    $WebApp= Get-SPWebApplication $WebAppURL

    foreach ($Policy in $WebApp.Policies)
    {

        $PolicyRoles=@()
        foreach($Role in $Policy.PolicyRoleBindings)
        {
            $PolicyRoles+= $Role.Name +";"
        }

    #Trim Off Login Prefix String
    $policyUserName = $Policy.UserName.ToString()
    $policyUserNameTrim = $policyUserName.replace("i:0#.w|","")

    #Append Web App Security Information
    "Web App URL: $($WebApp.URL) | Web App Name: $($WebApp.Name) | Web App Permissions: $($PolicyRoles) | Web App Security Group: $($policyUserNameTrim)” | Out-File $FileUrl -Append

    }

    #*** Site Collection Level Security ***
    #Loop Through All Site Collections

    foreach($Site in $SiteCollections)
    {
        
        #Append Site Collection Header
        " "  | Out-File $FileUrl -Append
        "******* Regulatory Site Collection Administrators *******" | Out-File $FileUrl -Append

        #Append Site Collection Administrator Header
        " "  | Out-File $FileUrl -Append
        "$($Web.Title) Site Collection Administrators" | Out-File $FileUrl -Append
        "SC Name | SC URL | SC Admin Name | SC Admin Login" | Out-File $FileUrl -Append
        
        #* Site Collection Administrators *
        foreach($SiteCollAdmin in $Site.RootWeb.SiteAdministrators)
        {
         
            #Trim Off Login Prefix String
            $SCAdminLoginName = $SiteCollAdmin.LoginName.ToString()
            $SCAdminLoginNameTrim = $SCAdminLoginName.replace("i:0#.w|","")

            #Append Site Collection Administrator Security Information
            “SC Name: $($Site.RootWeb.Title) | SC URL: $($Site.RootWeb.Url) | SC Admin Name: $($SiteCollAdmin.DisplayName) | SC Admin Login: $($SCAdminLoginNameTrim)" | Out-File $FileUrl -Append
        }

        #Loop Throuh all Sub-Sites
        foreach($Web in $Site.AllWebs)
        {

            #Append Site Collection Header
            " "  | Out-File $FileUrl -Append
            "******* $($Web.Title) Site Collection Security *******" | Out-File $FileUrl -Append
         
            #* Site Owners *   
            #Append Site Owner Header
            " "  | Out-File $FileUrl -Append
            "$($Web.Title) Site Owners"  | Out-File $FileUrl -Append
            "Owner Group | Owner Name | Owner Login " | Out-File $FileUrl -Append

            foreach($owner in $Web.AssociatedOwnerGroup.Users) {

                #Trim Off Login Prefix String
                $OwnerLoginName = $owner.LoginName.ToString()
                $OwnerLoginNameTrim = $OwnerLoginName.replace("i:0#.w|","")

                #Append Site Owner Security Information
                "Owner Group: $($Web.AssociatedOwnerGroup) | Owner Name: $($owner.DisplayName) | Owner Login: $($OwnerLoginNameTrim)" | Out-File $FileUrl -Append

            }

            #* Site Groups *
            #Append Site Groups Header
            " "  | Out-File $FileUrl -Append
            "$($Web.Title) Site Groups" | Out-File $FileUrl -Append
            "Group Name | Group Owner | Group Members" | Out-File $FileUrl -Append

            foreach($groups in $Web.Groups) {

               $GroupOwnerList = ""

               foreach($groupUser in $groups.Users){

                  #Trim Off Login Prefix String
                  $GroupOwnerLogin = $groupUser.ToString()
                  $GroupOwnerLoginTrim = $GroupOwnerLogin.replace("i:0#.w|","")
                  #Populate a List Variable from the Array
                  $GroupOwnerList += "$($GroupOwnerLoginTrim), "

               }

               #Append Site Groups Security Information
               "Group Name: $($groups.Name) | Group Name: $($groups.Owner.DisplayName) | Group Members: $($GroupOwnerList)" | Out-File $FileUrl -Append

            }

            #* Site Users *
            #Append Site Users Header
            " "  | Out-File $FileUrl -Append
            "$($Web.Title) Site Users"  | Out-File $FileUrl -Append
            "Site Url | Site Name | Group | Group Permission | User Name | User Login " | Out-File $FileUrl -Append

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
                        "Site Url: $($Web.Url) | Site Name: $($Web.Title) | Group: N/A | Direct Permission: $($WebUserPermissions) | User Name: $($WebRoleAssignment.Member.DisplayName) | User Login: $($DirectUserLoginTrim)” | Out-File $FileUrl -Append
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
                    “Site URL: $($Web.Url) | Site Name: $($Web.Title) | Group: $($WebRoleAssignment.Member.Name) | Group Permission: $($WebGroupPermissions) | User Name: $($user.DisplayName) | User Login: $($NotDirectUserLoginTrim)" | Out-File $FileUrl -Append


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
        "$($Web.Title) Site List - $($List.Title)" | Out-File $FileUrl -Append
        "List URL | List Title | List Group | Group Permissions | Group Members" | Out-File $FileUrl -Append

        #Get all the users granted permissions to the list
        foreach($ListRoleAssignment in $List.RoleAssignments )
        {

        #Is it a User Account?
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
            "List URL: $($List.ParentWeb.Url)/$($List.RootFolder.Url) | List Title: $($List.Title) | Direct Permission: $($ListRoleAssignment.Member.Name) | Permission: $($ListUserPermissions) |  User: $($ListDirectUserLoginTrim)” | Out-File $FileUrl -Append
        }

        #Check Group Permissions for User
        else
        {
            foreach($user in $ListRoleAssignment.member.users)
        {

        #Get Group Permissions for the List
        $ListGroupPermissions=@()

        foreach ($RoleDefinition  in $ListRoleAssignment.RoleDefinitionBindings)
        {
            $ListGroupPermissions += $RoleDefinition.Name +”;”
        }

            #Trim Off Login Prefix String
            $ListUserLogin = $user.LoginName.ToString()
            $ListUserLoginTrim = $ListUserLogin.replace("i:0#.w|","")
 
            #Append Site List Security Information
            “List URL: $($List.ParentWeb.Url)/$($List.RootFolder.Url) | List Title: $($List.Title) | List Group: $($ListRoleAssignment.Member.Name) | Group Permissions: $($ListGroupPermissions) | Group Member: $($ListUserLoginTrim)” | Out-File $FileUrl -Append

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