##########################################################################################                            
# ### Nintex Workflow Statistics Query ###
# This script will use the Nintex Assembilies to query the Nintex databases and find workflows.
# Please ensure you run this script as Administrative account that has rights to each Nintex database
###########################################################################################

cls

## Adding SharePoint Powershell Snapin
Add-PSSnapin Microsoft.SharePoint.PowerShell -EA silentlycontinue

## The Line below will suppress error messages, uncomment if you are seeing errors but still receiving results.
#$ErrorAction = 'silentlycontinue' 

## Loading SharePoint and Nintex Objects into the PS session
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
[void][System.Reflection.Assembly]::LoadWithPartialName("Nintex.Workflow")
[void][System.Reflection.Assembly]::LoadWithPartialName("Nintex.Workflow.SupportConsole")
[void][System.Reflection.Assembly]::LoadWithPartialName("Nintex.Workflow.Administration")
[void][System.Reflection.Assembly]::LoadWithPartialName("Nintex.Forms.SharePoint.Administration")

## Date Time Group Variable
$dtgDateTime = get-date -uformat %d-%m-%Y-%H.%M.%S

## Create An Error Log
$errorLog  = "c:\scripts\ErrorLog\NintexInventoryErrorLog" + $dtgDateTime + ".csv"
Write-Host "Error Log Output File Location:" $errorLog "`n"

## Create Inventory Report Variables
$outputReport = "c:\scripts\CSVOutput\NintexInventoryReport" + $dtgDateTime + ".csv"
Write-Host "CSV Output File Location:" $outputReport "`n"

## Grab Nintex Config database name
$CFGDB = [Nintex.Workflow.Administration.ConfigurationDatabase]::OpenConfigDataBase().Database

## Creating instance of .NET SQL client
$cmd = New-Object -TypeName System.Data.SqlClient.SqlCommand

$cmd.CommandType = [System.Data.CommandType]::Text

## Begin SQL Query
$cmd.CommandText = "SELECT
               i.WorkflowName,
               i.SiteID,
               i.WebID,
               i.listid,
      pw.Author
FROM dbo.WorkflowInstance I
inner join WorkflowProgress P
               ON I.InstanceID = P.InstanceID
Inner join [$CFGDB].dbo.publishedworkflows pw
on i.WorkflowID = pw.WorkflowId
GROUP BY GROUPING SETS((i.siteid, i.webid, i.listid, i.workflowname, pw.Author), ());"


$indexes = @()

## Call to find all Nintex Content Databases in the Nintex Configuration Database, then execute the above query against each. 
foreach ($database in [Nintex.Workflow.Administration.ConfigurationDatabase]::GetConfigurationDatabase().ContentDatabases)
{

$reader = $database.ExecuteReader($cmd)

## Creating a table
while($reader.Read())
{
$row = New-Object System.Object

if(![string]::IsNullOrEmpty($reader["SiteID"])){

    $Site = $(Get-SPSite -identity $reader["SiteID"] -EA SilentlyContinue) 

}

if(![string]::IsNullOrEmpty($reader["WebID"])){

    try{
        $SubSite = $Site.Allwebs[[Guid]"$($reader["WebID"])"] 
    } catch {
        "Error Message: Cannot find Site ID $($reader["WebID"]), $($_.Exception.Message) `n" | Out-File $errorLog -Append 
    }

}

if(![string]::IsNullOrEmpty($reader["ListID"])){

    $List = $SubSite.Lists[[Guid]"$($reader["ListID"])"]

}

## Adding Query results to table object
$row | Add-Member -MemberType NoteProperty -Name "Workflow Name" -Value $reader["WorkflowName"]
$row | add-member -MemberType NoteProperty -Name "Database" -value $Site.ContentDatabase.Name
$row | Add-Member -MemberType NoteProperty -Name "Site Collection" -Value $Site.Url
$row | Add-Member -MemberType NoteProperty -Name "Subsite" -Value $SubSite
$row | Add-Member -MemberType NoteProperty -Name "List" -Value $List.title
$row | Add-Member -MemberType NoteProperty -Name "Author" -Value $reader["Author"]

$indexes += $row
}
}

## Print results on screen
$indexes  | FT -autosize 
$indexes  | Export-Csv $outputReport -NoType
Write-host "Total Workflows in all DataBases:" $indexes.Count