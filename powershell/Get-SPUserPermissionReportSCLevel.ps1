# Regulatory Site Collection Permission Report - User
# Last Update October 2019
# See User Guide's for More Information

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

$report = "F:\Scripts\Reports\SharePoint_Individual_User_Permission_Report_" + $(get-date -f dd_MM_yyyy_HH_mm_ss) +".csv"

Function GetUserAccessReport($WebAppURL, $FileUrl)
{
 #Get All Site Collections of the WebApp
 $SiteCollections = Get-SPSite -WebApplication $WebAppURL -Limit All

#Write CSV- TAB Separated File) Header
"User Name; User Login; Permissions; Web\Site Title; Web\Site URL" | out-file $FileUrl
" " | out-file $FileUrl -Append

	#Check Web Application Policies
	$WebApp= Get-SPWebApplication $WebAppURL

	foreach ($Policy in $WebApp.Policies) 
  	{
	 	#Check if the search users is member of the group
		#if($Policy.UserName -eq $SearchUser)
		  #	{
				#Write-Host $Policy.UserName
	 			$PolicyRoles=@()
		 		foreach($Role in $Policy.PolicyRoleBindings)
				{ 
					$PolicyRoles += $Role.Name #+";"
				}

				#Write-Host "Permissions: " $PolicyRoles
				#User Name, User Login, Permissions, Web\Site Title, Web\Site URL
				"User Name: $($Policy.DisplayName); User: $($Policy.UserName); Permissions: $($PolicyRoles); Web App Title: $($WebApp.Name); Web App URL: $($WebApp.URL)" | Out-File $FileUrl -Append
			#}
 	 }
  
  #Loop through all site collections
   foreach($Site in $SiteCollections) 
    {
	  #Check Whether the Search User is a Site Collection Administrator
	  foreach($SiteCollAdmin in $Site.RootWeb.SiteAdministrators)
      	{
                #Write-Host "SCA Role $($SiteCollAdmin)" 
                ##User, Permissions, Web\Site Title, Web\Site URL
				"User Name: $($SiteCollAdmin.DisplayName); User Login: $($SiteCollAdmin.LoginName); SCA Permissions: $($PolicyRoles); Site Title: $($Site.RootWeb.Title); Site URL: $($Site.RootWeb.Url)" | Out-File $FileUrl -Append
		
		}
  
	   #Loop throuh all Sub Sites
       foreach($Web in $Site.AllWebs) 
       {	
			if($Web.HasUniqueRoleAssignments -eq $True)
            	{
		        #Get all the users granted permissions to the list
	            foreach($WebRoleAssignment in $Web.RoleAssignments ) 
	                { 
	                  #Is it a User Account?
						if($WebRoleAssignment.Member.userlogin)    
							{
							  			#Get the Permissions assigned to user
									 	$WebUserPermissions=@()
									    foreach ($RoleDefinition  in $WebRoleAssignment.RoleDefinitionBindings)
									   	{
				                    	    $WebUserPermissions += $RoleDefinition.Name #+";"
				                       	}

										#Send the Data to Log file
                                        ##User, Permissions, Web\Site Title, Web\Site URL
										"User Name: $($WebRoleAssignment.Member.DisplayName); User Login: $($WebRoleAssignment.Member.LoginName); Permission: $($WebUserPermissions); Site Title: $($Web.Title); Site URL: $($Web.Url)" | Out-File $FileUrl -Append
							}
					#Its a SharePoint Group, So search inside the group and check if the user is member of that group
					else  
						{
                        foreach($user in $WebRoleAssignment.member.users)
                            {
								    #Get the Group's Permissions on site
									$WebGroupPermissions=@()
							    	foreach ($RoleDefinition  in $WebRoleAssignment.RoleDefinitionBindings)
							   		{
		                    	  		$WebGroupPermissions += $RoleDefinition.Name #+";"
		                       		}

									#write-host "Group has these permissions: " $WebGroupPermissions									
									#Send the Data to Log file
                                    ##User, Permissions, Web\Site Title, Web\Site URL
									"User Name: $($user.DisplayName); User Login: $($user.LoginName); $($WebRoleAssignment.Member.Name): $($WebGroupPermissions); Site Title: $($Web.Title); Site URL: $($Web.Url)" | Out-File $FileUrl -Append
							}
						}
               	    }
				}
				
				#********  Check Lists with Unique Permissions ********/
		            foreach($List in $Web.lists)
		            {
		                if($List.HasUniqueRoleAssignments -eq $True -and ($List.Hidden -eq $false))
		                {
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
							                    	    $ListUserPermissions += $RoleDefinition.Name #+";"
							                       	}

													#write-host "with these permissions: " $ListUserPermissions													
													#Send the Data to Log file
                                                    ##User, Permissions, Web\Site Title, Web\Site URL
													"User Name: $($ListRoleAssignment.Member.Name); User Login: $($ListRoleAssignment.Member); Permission: $($ListUserPermissions); List Title: $($List.Title); List URL: $($List.ParentWeb.Url)/$($List.RootFolder.Url)" | Out-File $FileUrl -Append
										}
										#Its a SharePoint Group, So search inside the group and check if the user is member of that group
									else  
										{
					                        foreach($user in $ListRoleAssignment.member.users)
					                            {
													    #Get the Group's Permissions on site
														$ListGroupPermissions=@()
												    	foreach ($RoleDefinition  in $ListRoleAssignment.RoleDefinitionBindings)
												   		{
							                    	  		$ListGroupPermissions += $RoleDefinition.Name #+";"
							                       		}

														#write-host "Group has these permissions: " $ListGroupPermissions														
														#Send the Data to Log file
                                                        ##User, Permissions, Web\Site Title, Web\Site URL
														"User Name: $($user.DisplayName); User Login: $($user.LoginName); $($ListRoleAssignment.Member.Name): $($ListGroupPermissions); List Title: $($List.Title); List URL: $($Web.Url)" | Out-File $FileUrl -Append

												}
									}	
			               	    }
				            }
		            }
				}	
			}
					
		}


#Call the function to Check User Access
GetUserAccessReport "https://bentest.bhcorp.ad" $report

