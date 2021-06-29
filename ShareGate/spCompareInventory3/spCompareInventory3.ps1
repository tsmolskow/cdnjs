# Compare Inventory Lists ver 3
# spCompareInventory3.ps1
# As of:6/8/2021
# Developer: Tom Molskow, Cognizant

cls

#File Path
$FilePath = "C:\Test\"

#Get Compare Lists File
$csvCompareLists = "C:\Test\compareLists.csv"
$table = Import-Csv $csvCompareLists -Delimiter ";"

# CSV Inventory Output File - This File Will be Created Dynamically
$CSVPath = "C:\Test\spoInventoryCompare" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"

# Main Script
try{

    foreach ($row in $table)
    {

        #Importing Source CSV
        $File1Name = $row.Source
        $FilePath1 = $FilePath + $File1Name 
        $File1 = Import-Csv -Path $FilePath1

        $fileSize1 = $File1.Length/1Kb
        Write-Host  $fileSize1

        #Importing Destination CSV 
        $File2Name = $row.Destination
        $FilePath2 = $FilePath + $File2Name
        $File2 = Import-Csv -Path $FilePath2

        $fileSize2 = $File2.Length/1Kb
        Write-Host  $fileSize2

        #Compare both CSV files - column SamAccountName
        if($fileSize1 -gt 0 -and $fileSize2 -gt 0){

            $Results = Compare-Object  $File1 $File2 -Property ListName -IncludeEqual

        }

        # CSV Inventory Output File - This File Will be Created Dynamically
        #$CSVPath = "C:\Test\spoInventoryCompare" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"
 
        # File Compare Text
        $strCompare1 = ";" + $row.Id1 + ";" + $row.SourceURL + ";" + $row.DestinationURL + ";"

        Write-Host $strCompare1
 
        $Array = @() 
    
        Foreach($R in $Results)
        {

            If( $R.sideindicator -eq "<=" )
            {
                #if($R.ListName -ne "appfiles" -and $R.ListName -ne "Maintenance Log Library" -and $R.ListName -ne "SiteOwnerPanelConfig" -and $R.ListName -ne "Web Template Extensions" -and $R.ListName -ne "GEAR Document Links"){
                #if($R.ListName -ne "appfiles"  -and $R.ListName -ne "Maintenance Log Library"){

                    $Object = [pscustomobject][ordered] @{
                        ListName = $R.ListName 
                    #}

                }
              
                #Write-Host $R.ListName                
                $Array += $Object

            }
        }

        #Display results in console
        $Array | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Append
        $strCompare1 | add-content -Path $CSVPath -Force

        Write-Host "Exported" 

        $Array = @() 
        #$strMessage = @() 

    }

} catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage
}

#Filter Out Internal SPO Libraries 
[io.file]::readalltext($CSVPath).replace("appfiles","") | Out-File $CSVPath -Encoding ascii –Force
[io.file]::readalltext($CSVPath).replace("Maintenance Log Library","") | Out-File $CSVPath -Encoding ascii –Force
[io.file]::readalltext($CSVPath).replace("SiteOwnerPanelConfig","") | Out-File $CSVPath -Encoding ascii –Force
[io.file]::readalltext($CSVPath).replace("Web Template Extensions","") | Out-File $CSVPath -Encoding ascii –Force
[io.file]::readalltext($CSVPath).replace("eyimdInternalUse001","") | Out-File $CSVPath -Encoding ascii –Force
[io.file]::readalltext($CSVPath).replace("GEAR Document Links","") | Out-File $CSVPath -Encoding ascii –Force
[io.file]::readalltext($CSVPath).replace('"',"") | Out-File $CSVPath -Encoding ascii –Force


