cls

#File Path
$FilePath = "C:\Test\"

#Importing CSV
$File1Name = "File1.csv"
$FilePath1 = $FilePath + $File1Name 
$File1 = Import-Csv -Path $FilePath1
 
#Importing CSV 
$File2Name = "File2.csv"
$FilePath2 = $FilePath + $File2Name
$File2 = Import-Csv -Path $FilePath2
 
#Compare both CSV files - column SamAccountName
$Results = Compare-Object  $File1 $File2 -Property ListName -IncludeEqual

# CSV Inventory Output File - This File Will be Created Dynamically
$CSVPath = "C:\Test\spoInventoryCompare" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"
 
# File Compare Text
$strCompare = "File Name Comparison: " + $File1Name + " compared to " + $File2Name 
Write-Host $strCompare
 
$Array = @()       
Foreach($R in $Results)
{

    If( $R.sideindicator -eq "<=" )
    {

        $Object = [pscustomobject][ordered] @{

            ListName = $R.ListName
 
        }

        $Array += $Object

    }

    
    #If( $R.sideindicator -eq "=>" )
    #{
        #$Object = [pscustomobject][ordered] @{ 
            #ListName = $R.ListName 
        #}
        #$Array += $Object
    #}
}
 
#Count users in both files
#($Array | sort-object username | Select-Object * -Unique).count
 
#Display results in console
#$strCompare | Export-Csv -Path $CSVPath -Force -NoTypeInformation
#$Array | add-content -Path $CSVPath
$Array | Export-Csv -Path $CSVPath -Force -NoTypeInformation
$strCompare | add-content -Path $CSVPath

