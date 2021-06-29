#Run Child Scripts
#RunChildScripts.ps1
#Pre-Requirement: SP-SDK Must be Installed to the Local Server
#First Logon Before Running (Can Use LogonWithPrompt or Logon Without Prompt)

cls

$csvFile = "C:\Test\csvSites.csv"
$table = Import-Csv $csvFile -Delimiter ";"

Try {

    foreach ($row in $table)
    {

        Start-Sleep -Seconds 2.5
        ."C:\Users\A3066653-3\Desktop\Scripts\GetAllSPOLists.ps1" $row.SourceSite $row.Id
        Start-Sleep -Seconds 2.5
        Write-Host -f Green  "List processed " $row.SourceSite "runChildScripts.ps1"

    }

} Catch {
    write-host -f Red "Error:" $_.Exception.Message
}

