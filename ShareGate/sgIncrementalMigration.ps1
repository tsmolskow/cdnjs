
# ShareGate Incremental Migration
# sgIncrementalMigration.ps1
# As of: 6/10/2021
# Notes: Dynamic file name, Password sent in clear, Needs for each loop to get all lists\libraries,
# Read from a SP List, Update to a SP List

#SPO Login as Admin Without Prompt

cls

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

## --- Unprompted SPO Login - Tenant Admin Level --- ##
#$login = "P.AUOPRTMIGP.3@ey.com"
#$pwd = "t#w59e*t*eStJxt"

#$pwd = ConvertTo-SecureString $pwd -AsPlainText -Force

#Credentials
#$credentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $login,$pwd

#Connect - Tenant Level Credentials
#Connect-SPOService -url "https://m365b742352-admin.sharepoint.com" -Credential $credentials

#Write-Host "Connected to SPO - Tenant Level"

## --- Unprompted SPO Login - SCA Level --- ##
$SiteURL="https://eyus.sharepoint.com/sites/eyimdUSA-0003005-C"
$UserName="P.AUSPORTMIGP.1@ey.com"
$Password = "KVJah1@acnv+KJQ"
 
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
#Connect to PNP Online
Connect-PnPOnline -Url $SiteURL -Credentials $Cred

Write-Host "Connected to SPO - SCA Level"

## --- Import ShareGate Modules --- ##
Import-Module Sharegate	

#Get Source and Destination Sites
$csvFile = "C:\Test\siteURLAndListFileName4.csv"
$table = Import-Csv $csvFile -Delimiter ";"
$errorLog = "C:\Test\mgrErrorLog.csv"

#Logon and Password - SPO and SP On-Prem 
$userName1 = "P.AUSPORTMIGP.10@ey.com"  #SPO
#$userName2 = "P.AUSPORTMIGP.10@ey.com"  #SPO
$userName2 = "P.AUOPRTMIGP.3"  #SP On-Prem

$passWord1 = ConvertTo-SecureString "QReJ+MMvJ+Vnaba1" -AsPlainText -Force  #SPO
#$passWord2 = ConvertTo-SecureString "QReJ+MMvJ+Vnaba1" -AsPlainText -Force  #SPO
$passWord2 = ConvertTo-SecureString "t#w59e*t*eStJxt" -AsPlainText -Force  #SP On-Prem

#Setup Credentials to connect
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName1,(ConvertTo-SecureString $passWord1 -AsPlainText -Force))

#Set Log Report Path and File
$filePath = "C:\Test\s" + $srcSiteName + "_d" + $dstSiteName + "_dt" + $(get-date -f dd_MM_yyyy) +".xlsx"

foreach ($row in $table)
{

    #Set Source Variables
    $srcSiteURL = $row.SourceURL
    Write-Host "srcSiteURL" $srcSiteURL 

    #Set Destination Variables
    $dstSiteURL = $row.DestinationURL
    Write-Host "dstSiteURL" $dstSiteURL

    $srcSiteName = $srcSiteURL.Split("/")[-1]
    Write-Host $srcSiteName
    $dstSiteName = $dstSiteURL.Split("/")[-1]
    Write-Host $dstSiteName

    #Connect Source Site - SPO
    $srcSite = Connect-Site -Url $srcSiteURL -Username $userName1 -Password $passWord1
    Write-Host "Conencted to SPO"

    #Connect Destination Site - SP On-Prem
    $dstSite = Connect-Site -Url $dstSiteURL -Username $userName2 -Password $passWord2
    Write-Host "Conencted to SP On-Prem"

    #Source List Files
    $csvFileS = "C:\Test\" + $row.Source
    $tableS = Import-Csv $csvFileS -Delimiter ";"
    Write-Host "Source List File" $csvFileS

    #Destination List Files
    $csvFileD = "C:\Test\" + $row.Destination
    $tableD = Import-Csv $csvFileD -Delimiter ";"
    Write-Host "Destination List File" $csvFileD

    #Break

    Write-Host "---- Looping Thru Lists ----"
    #Source List

    foreach ($row in $tableS)
    {
	    try
        {
            $srcList = Get-List -Name $row.ListName -Site $srcSite
            $row.SourceList | Out-File -FilePath $errorLog -Append   
            Write-Host "srcList " $row.ListName  

	        $dstList = Get-List -Name $row.ListName -Site $dstSite
            $row.DestinationList | Out-File -FilePath $errorLog -Append 
            Write-Host "dstList " $row.DestinationList 

	        #Script That Does the Actual Migration
            #$copysettings = New-CopySettings -OnContentItemExists IncrementalUpdate
            #$result = Copy-Content -SourceList $srcList -DestinationList $dstList -CopySettings $copysettings

        }
        catch
        {            
            
            $ErrorMessage = $_.Exception.Message
            Write-Host "Error has occurred:" $ErrorMessage
            $ErrorMessage + "`n" | Out-File -FilePath $errorLog -Append 
            
            Copy-List -SourceSite $srcSite -Name $row.ListName -DestinationSite $dstSite           
                  
        }
    }    

}

Break

#Export Migration Report
Export-Report $result -Path $filePath -Overwrite
