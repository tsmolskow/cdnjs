cls

if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)  
{  
  
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"  
}  
  
$results = @()  
$siteColl =  "http://hub-dev.westlake.com/sites/EHSS"  
   
$site = Get-SPSite -Identity $siteColl -Limit All  
try  
{   
    foreach ($myWeb in $site.AllWebs)  
    {  
        Write-Host "Looking in Web: " $myWeb.Url -ForegroundColor Green  
        foreach($list in $myWeb.Lists)  
        {  
            if ($list.WorkflowAssociations -eq $true)  
            {  
                Write-Host $list.Title -ForegroundColor Blue  
                foreach ($wflowAssociation in $list.WorkflowAssociations)  
                {  
                    $RowDetails =  @{            
                      "List Name"         = $wflowAssociation.ParentList.Title  
                      "Workflow Name"     = $wflowAssociation.InternalName  
                      "Running Instances" = $wflowAssociation.RunningInstances  
                      "Created On"        = $wflowAssociation.Created  
                      "Modified On"       = $wflowAssociation.Modified  
                      "Parent Web"        = $wflowAssociation.ParentWeb  
                      "Task List"         = $wflowAssociation.TaskListTitle  
                      "History List"      = $wflowAssociation.HistoryListTitle                   
                    }  
  
                    $results += New-Object PSObject -Property $RowDetails  
                }            
            }  
  
        }  
    }  
  
    $myFileName = [Environment]::GetFolderPath("Desktop") + "\workflowList.csv"  
    $results | Select-Object "List Name", "Workflow Name", "Running Instances", "Created On","Modified On","Parent Web", "Task List","History List"    | export-csv -Path $myFileName -NoTypeInformation  
  
}  
  
catch   
{   
    $e = $_.Exception   
    $line = $_.InvocationInfo.ScriptLineNumber   
    $msg = $e.Message   
    Write-Host –ForegroundColor Red "Caught Exception: $e at $line"   
    Write-Host $msg   
    Write-Host "Something went wrong"  
}   
  
Write-Host "`n Completed!" 