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

        #Write-Host $row.Source $row.Destination #For Testing Only

        #Importing Source CSV
        $File1Name = $row.Source
        $FilePath1 = $FilePath + $File1Name 
        $File1 = Import-Csv -Path $FilePath1

        #Importing Destination CSV 
        $File2Name = $row.Destination
        $FilePath2 = $FilePath + $File2Name
        $File2 = Import-Csv -Path $FilePath2

        #Compare both CSV files - column SamAccountName
        $Results = Compare-Object  $File1 $File2 -Property ListName -IncludeEqual

        # CSV Inventory Output File - This File Will be Created Dynamically
        #$CSVPath = "C:\Test\spoInventoryCompare" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"
 
        # File Compare Text
        $strCompare0 = " "
        $strCompare1 = "File Name Comparison: " + $File1Name + " compared to " + $File2Name
        $strCompare2 = "------------------------------------------------------------------"

        Write-Host $strCompare1
 
        $Array = @()   
        #$Array += $strCompare
    
        Foreach($R in $Results)
        {

            If( $R.sideindicator -eq "<=" )
            {
                $Object = [pscustomobject][ordered] @{
                    ListName = $R.ListName 
                }
        
                $Array += $Object

            }
        }


        #Display results in console
        $Array | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Append
        $strCompare0 | add-content -Path $CSVPath
        $strCompare1 | add-content -Path $CSVPath
        $strCompare2 | add-content -Path $CSVPath

        #Write-Host "Exported"

        $Array = @()  

    }

} catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage
}
 
