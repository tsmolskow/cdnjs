# Compare Inventory Lists ver 3
# spCompareInventory3.ps1
# As of:7/28/2021
# Developer: Tom Molskow, Cognizant

cls

## File Path
$FilePath = "C:\Test\"

## Get Compare Lists File
$csvCompareLists = "C:\Test\compareLists1.csv"
$table = Import-Csv $csvCompareLists -Delimiter ";"

## CSV Inventory Output File - This File Will be Created Dynamically
$CSVPath = "C:\Test\spoPermissionCompare" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv"

## Main Script
 foreach ($row in $table)
 {

    try{

        ## Importing Source CSV
        $File1Name = $row.Source
        $FilePath1 = $FilePath + $File1Name 
        Write-Host "FilePath1 " + $FilePath1
        $File1 = Import-Csv -Path $FilePath1
        #$File1 = Import-Csv -Path $FilePath1 -Header 'Title', 'SiteAddress', 'UserGroup', 'PermissionLevels', 'Inherited'

        $fileSize1 = $File1.Length/1Kb
        Write-Host  "File Size 1:" $fileSize1

        ## Importing Destination CSV 
        $File2Name = $row.Destination
        $FilePath2 = $FilePath + $File2Name
        Write-Host "FilePath2 " + $FilePath2
        $File2 = Import-Csv -Path $FilePath2
        #$File2 = Import-Csv -Path $FilePath2 -Header 'Title', 'SiteAddress', 'UserGroup', 'PermissionLevels', 'Inherited'

        $fileSize2 = $File2.Length/1Kb
        Write-Host  "File Size 2:" $fileSize2

        ## Compare both CSV files - column SamAccountName
        if($fileSize1 -gt 0 -and $fileSize2 -gt 0){

            $Results = Compare-Object  $File1 $File2 -Property SiteAddress, UserGroup, PermissionLevels -Verbose
            #$Results = Compare-Object  $File1 $File2 -Property UserGroup, PermissionLevels, SiteAddress -Verbose
            #$Results = Compare-Object -ReferenceObject $File1 -DifferenceObject $File2

        }
    
        ## File Compare Text
        $strCompare1 = ";" + $row.Id1 + ";" + $row.SourceURL + ";" + $row.DestinationURL + ";"

        Write-Host "strCompare1:" $strCompare1
 
        $Array = @() 
    
        Foreach($R in $Results)
        {

            #If( $R.sideindicator -eq "<=" ) ## Difference in Source Site
            If( $R.sideindicator -eq "=>" ) ## Difference in Destination Site
            {

                    $Object = [pscustomobject][ordered] @{

                        SiteAddress = $R.SiteAddress
                        
                        UserGroup = $R.UserGroup

                        PermissionLevels = $R.PermissionLevels

                }
              
                #Write-Host "Title: " $R.Title 
                Write-Host $R.SiteAddress "|" $R.UserGroup "|" $R.PermissionLevels  
                #Write-Host "PermissionLevels: " $R.PermissionLevels              
                $Array += $Object

            }
        }

        ## Display results in console
        $Array | Export-Csv -Path $CSVPath -Force -NoTypeInformation -Append
        $strCompare1 | add-content -Path $CSVPath -Force

        Write-Host "Exported" 

        $Array = @() 
        #$strMessage = @() 

    } catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage

    }

}





