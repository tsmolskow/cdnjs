### Lightweight SharePoint Site Permissions
### Writes Results to a File

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

cls

# Site Collection Variables
$Url = "https://bentest.bhcorp.ad/sites/Regulatory2" 
$Site = Get-SPSite $Url
$subSite = "https://bentest.bhcorp.ad/sites/Regulatory2/wyoming" 

# Report File Location
$ReportOutput = "F:\SiteInventory.csv"

Foreach($web in $Site.AllWebs)
{
if($web.Url -eq $subSite){
		Write-Host "Site Name: " $web.Title -ForegroundColor yellow
		$roles=$web.get_Roles()
		Foreach($role in $roles)
		{
            Write-Host "----------------"
            Write-Host "Permission Level:" $role.Name -ForegroundColor green
			Write-Host "Groups that have this permission:"
			$groups = $role.Groups
			if($groups.Count -eq 0){
            Write-Host "No groups have this permission" -ForegroundColor red
			}else{
				Foreach($group in $groups)
				{
				 Write-Host $group":"
				 $groupUsers=$group.Users
				 if($groupUsers.Count -eq 0){
				 	Write-Host "This group does not have users"
				 }else{
				 	Foreach($groupUser in $groupUsers){
                    $groupUser.DisplayName
					}
                    "`n"
				 }
				}
			
			}    
			Write-Host "-------------"
			Write-Host "Users that have this permission:"
			
			$users = $role.Users 
			if($users.Count -eq 0){
				Write-Host "No user have this permission (directly)" -ForegroundColor red
			}else{
				Foreach($user in $users)
				{
				 Write-Host $user
				}
			}
		}
	}
}

#Export the data to CSV
$ResultData | Export-Csv $ReportOutput -NoTypeInformation