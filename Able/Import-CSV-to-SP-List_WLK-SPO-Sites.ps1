Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Read the CSV file
$CSVData = Import-CSV -path "\\houasama01t\spodata\wlk-spo-sites.csv" 
 
#Get the Web
$web = Get-SPWeb -identity "http://atlas.westlake.com"
 
#Get the Target List
$List = $web.Lists["ATLAS WLK SPO Sites"]
 
#Iterate through each Row in the CSV
foreach ($Row in $CSVData) 
{
    #Filter using CAML Query
    $CAMLQuery="<Where><Eq><FieldRef Name='Title'/><Value Type='Text'>$($Row.Name)</Value></Eq></Where>"
    $SPQuery=New-Object Microsoft.SharePoint.SPQuery
    $SPQuery.ViewAttributes = "Scope='Recursive'"  #Get all items including Items in Sub-Folders!
    $SPQuery.Query=$CAMLQuery
    $SPQuery.RowLimit = 1 
     
    #Get the List item based on Filter 
    $Item=$List.GetItems($SPQuery)[0]

    If($Item -ne $null)
    {
        #Update List Item
        $Item["Title"] = $Row.Title
        $Item["Site Address"] = "$Row.Site Address"
        $Item["Site Owners"] = "$Row.Site Owners"
        $Item["Site Template"] = "$Row.Site Template"
        $Item["Size"] = $Row.Size
        $item.Update()
        Write-Host "Updated:"$row.Name -ForegroundColor Green
    }
    else
    {
        write-host "No matching Item Found for:"$row.Name -f Red
    }
}