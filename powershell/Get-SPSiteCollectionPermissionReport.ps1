[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
 
#Region MOSS 2007 Cmdlets
 
 Function global:Get-SPSite($url)
 {
  if($url -ne $null)
     {
     return New-Object Microsoft.SharePoint.SPSite($url)
  }
 }
  
 Function global:Get-SPWeb($url)
 {
   $site= Get-SPSite($url)
         if($site -ne $null)
             {
                $web=$site.OpenWeb();
        
             }
     return $web
 }
  
#EndRegion
 
Function GenerateUserAccessReport()
{
 #Site Collection URL - Mandatory parameter
 param( [Parameter(Mandatory=$true)] [string]$SiteCollectionURL)
 
  #Get the site collection
  $Site= Get-SPSite $SiteCollectionURL
  #Append the HTML File with CSS into the Output report
  $Content=Get-Content -Path "table.htm" > PermissionReport.htm
   
 "<h2> $($Site.RootWeb.Title) - Users & Groups Permission Report</h2>" >> PermissionReport.htm
   
  #Table of Contents
  "<h3> List of Sites</h3> <table class='altrowstable' id='alternatecolor' cellpadding='5px'><tr><th>Site Name </th><th> URL </th></tr>" >> PermissionReport.htm
    #Get Users of All Webs : Loop throuh all Sub Sites
       foreach($Web in $Site.AllWebs)
       {
    "<tr> <td> <a href='#$($web.Title.ToLower())'>$($web.Title)</a> </td><td> $($web.URL)</td> </tr>" >> PermissionReport.htm
    }
   
   #Site Collection Administrators Heading
  "</table>
<b>Site Collection Administrators</b>" >> PermissionReport.htm
 
  "<table class='altrowstable' id='alternatecolor' cellpadding='5px'><tr>" >> PermissionReport.htm
 
  #Write CSV (TAB Separated File) Header
  "<th>User Account ID </th> <th>User Name </th></tr>" >> PermissionReport.htm
   
    #Get All Site Collection Administrators
     $Site.RootWeb.SiteAdministrators | sort $_.Name | ForEach-Object   { 
   "<tr><td> $($_.LoginName) </td> <td> $($_.Name)</td></tr> " >> PermissionReport.htm
  }
        
    #Get Users of All Webs : Loop throuh all Sub Sites
       foreach($Web in $Site.AllWebs)
       {
      #Check if site is using Unique Permissions or Inheriting from its Parent Site!
      if($Web.HasUniqueRoleAssignments -eq $true)
   {
         "</table>
<hr> <h3>Site: [ <a name='$($Web.Title.ToLower())'>$($Web.Title) </a> ] at <a href='$($web.URL)'>$($web.URL)</a> is using Unique Permissions. </h3>" >> PermissionReport.htm
   }
   else
   {
     "</table>
<hr> <h3>Site: [ <a name='$($Web.Title.ToLower())'>$($Web.Title) </a> ] at <a href='$($web.URL)'>$($web.URL)</a> is Inheriting Permissions from its Parent Site.</h3>" >> PermissionReport.htm
   }
   
      #Get the Users & Groups from site which has unique permissions - TOP sites always with Unique Permissions
      if($Web.HasUniqueRoleAssignments -eq $True)
             {
           #*** Get all the users granted permissions DIRECTLY to the site ***
     "<b>Site Users and Groups</b><table class='altrowstable' id='alternatecolor' cellpadding='5px'><tr>" >> PermissionReport.htm
     "<th>Users/Groups </th> <th> Type </th><th> User Name </th> <th>Permissions</th></tr>" >> PermissionReport.htm
              foreach($WebRoleAssignment in $Web.RoleAssignments )
                  {
         #*** Get  User/Group Name *****#
         $UserGroupName=$WebRoleAssignment.Member.Name
          
         #**** Get User/Group Type *****#
       #Is it a SharePoint Group?
        if($WebRoleAssignment.Member.GetType() -eq [Microsoft.SharePoint.SPGroup])
        {
         $Type="SharePoint Group"
         $UserName=$WebRoleAssignment.Member.Name
         #Set Flag value for "Group Exists"
         $GroupExistsFlag=$true
        }
                        #Is it a SharePoint User Account or Domain Group?
        else
        {
            $UserName=$WebRoleAssignment.Member.LoginName
         #Is it a Domain Group?
         if($WebRoleAssignment.Member.IsDomainGroup)
         {
           $Type="Domain Group"
         }
         else #if($WebRoleAssignment.Member.LoginName)   
         {
           $Type="SharePoint User"
         }
        }
 
        #Get the Permissions assigned to Group/User
         $WebUserPermissions=@()
           foreach ($RoleDefinition  in $WebRoleAssignment.RoleDefinitionBindings)
           {
                           $WebUserPermissions += $RoleDefinition.Name +";"
                          }
        
        #Send the Data to Log file
        " <tr> <td> $($UserGroupName) </td><td> $($Type) </td><td> $($UserName) </td><td>  $($WebUserPermissions)</td></tr>" >> PermissionReport.htm
      }
      
     #****** Get the Group members *********#
       "</table></br> " >>PermissionReport.htm
       if($GroupExistsFlag -eq $true)
       {
        "<b>Group Users</b><table class='altrowstable' id='alternatecolor' cellpadding='5px'><tr>" >>PermissionReport.htm
       foreach($WebRoleAssignment in $Web.RoleAssignments )
                   {
        #Is it a SharePoint Group?
        if($WebRoleAssignment.Member.GetType() -eq [Microsoft.SharePoint.SPGroup])   
         {
            "<th>Group: $($WebRoleAssignment.Member.Name)</th></tr> " >> PermissionReport.htm
                           foreach($user in $WebRoleAssignment.member.users)
                               {
           #Send the Data to Log file
           " <tr><td></td> <td> $($user.Name) </td><td> $($user.LoginName) </td><td> $($user.Email)</td><tr>" >> PermissionReport.htm
          }
         }
                     }
      }
      #Reset Group Exists Flag
      $GroupExistsFlag=$false
     }
      
     #********  Check Lists with Unique Permissions ********/
              foreach($List in $Web.lists)
              {
      #Skip the Hidden Lists
                  if( ($List.HasUniqueRoleAssignments -eq $True) -and  ($List.Hidden -eq $false))
                  {
       "</table>
<b>Users and Groups in List: [ $($List.Title) ] at <a href='$($List.ParentWeb.Url)/$($List.RootFolder.Url)'>$($List.ParentWeb.Url)/$($List.RootFolder.Url)</a> with Unique Permissions.</b><table class='altrowstable' id='alternatecolor' cellpadding='5px'><tr>" >> PermissionReport.htm
       "<th>Users/Groups </th><th>  Type </th><th> User Name </th><th> Permissions</th></tr>" >> PermissionReport.htm
                   
         #Get all the users granted permissions to the list
               foreach($ListRoleAssignment in $List.RoleAssignments )
                   {
          #*** Get  User/Group Name *****#
          $UserGroupName=$ListRoleAssignment.Member.Name
          
        #**** Get User/Group Type *****#
       #Is it a SharePoint Group?
        if($ListRoleAssignment.Member.GetType() -eq [Microsoft.SharePoint.SPGroup])
        {
         $Type="SharePoint Group"
         $UserName=$ListRoleAssignment.Member.Name
        }
                        #Is it a SharePoint User Account or Domain Group?
        else
        {
            $UserName=$ListRoleAssignment.Member.LoginName
         #Is it a Domain Group?
         if($ListRoleAssignment.Member.IsDomainGroup)
         {
           $Type="Domain Group"
         }
         else #if($ListRoleAssignment.Member.LoginName)   
         {
           $Type="SharePoint User"
         }
        }
 
        #Get the Permissions assigned to Group/User
         $ListUserPermissions=@()
           foreach ($RoleDefinition  in $ListRoleAssignment.RoleDefinitionBindings)
           {
                           $ListUserPermissions += $RoleDefinition.Name +";"
                          }
        
        #Send the Data to Log file
        "<tr><td>$($UserGroupName) </td><td> $($Type) </td><td> $($UserName) </td><td>  $($ListUserPermissions)</td></tr>" >> PermissionReport.htm
        }
        "</table>" >>PermissionReport.htm
                }
                }
    }
                 "</body></html>" >>PermissionReport.htm
   }
 
#Call the function to Get Users & groups Report
GenerateUserAccessReport "http://sharepoint.crescent.com/sites/compliance"


#Read more: http://www.sharepointdiary.com/2013/03/users-and-groups-permission-report.html#ixzz5tkxCVg3I