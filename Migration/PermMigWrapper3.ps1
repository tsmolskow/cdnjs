## Permissions Migration Script Wrapper
## PermMigWrapper.ps1
## As of: 9/14/2021
## Developer: Tom Molskow, Cognizant

cls

#$ScriptPath = "C:\Users\A3066653-3\Desktop\CSOM Scripts\Permissions\"
$ScriptPath = "C:\Test\"

## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath = $ScriptPath + "Report\"

## Get spoSites File
$csvFile = "C:\Test\PermMigWrapper3.csv"
$table = Import-Csv $csvFile -Delimiter ","

foreach ($row in $table)
{

    $ID = $row.ID
    $PinputCSVPermissions = $row.inputCSVPermissions          
    $PinputCSVURLs = $row.inputCSVURLs
    $Pspousername = $row.spousername
    $Pspopassword = $row.spopassword
    $Pspopusername = $row.spopusername
    $Pspoppassword = $row.spoppassword

    ## CSV Inventory Output File - This File Will be Created Dynamically
    $rptFilePath = $ReportPath + $ID + "PermMigWrapReport.csv"

    ## Set Permissions

    Try{

    Start-Process Powershell.exe -Argument "-File C:\Test\PermissionsMigration7.ps1 $PinputCSVURLs $Pspousername $Pspopassword"

    Write-Host "Parameter Values | inputCSVURLs:" $PinputCSVURLs "| spousername:" $Pspousername "| spopassword:" $Pspopassword 
    
    $ReportString = "Parameter Values | inputCSVURLs:" + $PinputCSVURLs + "| spousername:" + $Pspousername + "| spopassword:" + $Pspopassword 

    $ReportString | Out-File -FilePath $rptFilePath

    Start-Sleep -Seconds 175
    Write-Host "Sleep over in 25 Seconds..."
    Start-Sleep -Seconds 25

    } Catch {

        $ErrorLine = $_.InvocationInfo.ScriptLineNumber
        $ErrorMessage = $_.Exception.Message
        Write-Host -f Red "Error has occurred:" $ErrorMessage + " Line: " + $ErrorLine
        $ReportString = "Error has occurred:" + $ErrorMessage + " Line: " + $ErrorLine
        $ReportString | Out-File -FilePath $rptFilePath

    }  

}



