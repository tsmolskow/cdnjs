# Get All SP On_Premise Lists
# spGetAllSPOPLists.ps1
# As of: 7/15/2021
# Developer: Tom Molskow, Cognizant

## Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

cls

## Login Information
#$spousername = "ey\P.AUOPRTMIGP.10@ey.com"
$spousername = "ey\P.AUOPRTMIGP.10"
$spopassword = "cL95H@urF7~Vk3%"
$sposecurepassword = $spopassword | ConvertTo-SecureString -AsPlainText -Force

#Setup the context
$Ctx = Get-SPContext $SiteURL $spousername $sposecurepassword
  

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath ="C:\Test\Report\"

## CSV List Input File - Modify This Path Variable to Reflect the Local Environment
## !!!The 'spopSites.CSV' File Must Exist Prior to Running!!!
#$csvFile = "C:\Test\spopSitesUS1.csv" 

## Table Variable
#$table = Import-Csv $csvFile -Delimiter ";"
 
## --- Main Script ---##
    
foreach ($row in $table)
{

    try{
    
        $srcList = $row.DestinationSite
        $ID = $row.Id
        Write-Host "Site in Table " $row.DestinationSite

        # CSV Inventory Output File - This File Will be Created Dynamically
        #$ReportOutput = $ReportPath + $row.Id + "spopInventoryD"  + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm) + ".csv" 
        $ReportOutput = $ReportPath + $ID + "spopInventoryD.csv" 

        # Get the site collection   
        $SiteURL = $srcList
        $Site = Get-SPSite $SiteURL
 
        $ResultData = @()

      Foreach($web in $Site.AllWebs)
      {
    
        try
        {
        
        Write-host -f Yellow "Processing Site: "$Web.URL
  
        # Get all lists - Exclude Hidden System lists
        $ListCollection = $web.lists
        # Write-Host "List Collection " $ListCollection # For Testing Only
 
            # Iterate through All lists and Libraries
            ForEach ($List in $ListCollection)
            {
                    $Data = New-Object PSObject -Property @{

                    'ListName' = $List.Title
                    'Item Count' = $List.ItemCount # Optional Data
                    #'Site Title' = $Web.Title
                    #'Site URL' = $Web.URL
                    #'Created By' = $List.Author.DisplayName # Optional Data
                    #'Last Modified' = $List.LastItemModifiedDate.ToString(); # Optional Data
                    #'List URL' = "$($Web.Url)/$($List.RootFolder.Url)" # Optional Data

                    } 
                    If($List.Title -ne "Content type publishing error log" -and $List.Title -ne "Workflows"){
                        $ResultData += $Data
                    }
            } 
        }

        catch
        {
            $ErrorMessage = $_.Exception.Message
            Write-Host "Error has occurred:" $ErrorMessage
        }

      }

      # Export the data to CSV
      $ResultData | Export-Csv $ReportOutput -NoTypeInformation
    
    } catch {

        $ErrorMessage = $_.Exception.Message
        Write-Host "Error has occurred:" $ErrorMessage
    }
    
}
 
Write-host -f Green "Report Generated Successfully at : "$ReportOutput
 
#Fetch SharePoint Context
function Get-SPContext {
    Param(
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String] $source,                
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][String] $userId,
        [Parameter(Mandatory = $true)] $securePassword
    )
    try {
        $context = $null
        #Context for Online sites
        if($source.ToLower().contains("sharepoint.com") -or $source.ToLower().contains("sites.ey.com")) {
            #$credentials = New-Object System.Management.Automation.PSCredential($userId,$securePassword)            
            #Connect-PnPOnline -Url $source -Credentials $credentials
            #$context = Get-PnPContext
            $context = New-Object Microsoft.SharePoint.Client.ClientContext($source)  
            $context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userId,$securePassword)                        
            $context.add_ExecutingWebRequest({
                param($objSender, $eventArgs)
                $request = $eventArgs.WebRequestExecutor.WebRequest
                $request.UserAgent = "NONISV|Cognizant|CTSRemediation/1.0"
            })
        }
        else {
            #Context for OnPrem sites
            $context = New-Object Microsoft.SharePoint.Client.ClientContext($source)
            $context.Credentials = New-Object System.Net.NetworkCredential($userId, $securePassword)
            $context.add_ExecutingWebRequest({
                param($objSender, $eventArgs)
                $eventArgs.WebRequestExecutor.WebRequest.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")
            })
        }
        return $context
    }
    catch {
        Write-Host "Failed in executing Get-SPContext method: $($_.Exception.Message) `n"  -ForegroundColor Red
        throw
    }
}