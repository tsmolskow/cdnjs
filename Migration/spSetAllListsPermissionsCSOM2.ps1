# spSetAllListsPermissionsCSOM2
# Last Updated 7/8/2021
# Developer: CTS

cls

## Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

## Load System Reflection Assemblies
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

## Site URL  
#$SiteUrl ="https://eyonespace.ey.com/Sites/536a5ebeec1044b0b8accf5c44547c41"
$SiteUrl = "https://eyus.sharepoint.com/sites/eyimdUSA-0001677-MM"
#$SiteUrl = "https://tdm.ey.net/sites/570fcbe11bae425aa98d9cb810e64ee2"

## Login to Site 
$UserName = "P.AUOPRTMIGP.10@ey.com" #SPO
$Password = 'cL95H@urF7~Vk3%' #SPO
#$UserName = "P.AUOPRTMIGP.10@ey.com" #SPOP
#$Password = 'cL95H@urF7~Vk3%' #SPOP
$SecPwd = $(ConvertTo-SecureString $Password -asplaintext -force)  

## Connect to the Web
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)  
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,$SecPwd)
  
$ctx.credentials = $credentials
$ctx.Load($ctx.Web) 
$ctx.ExecuteQuery()

## Get Lists from the site
$Web = $Ctx.Web
$Lists = $Web.Lists

$Ctx.Load($Web)
$Ctx.Load($Web.Webs);
$Ctx.Load($Lists)
$Ctx.ExecuteQuery()

## File Output Path - Modify This Path Variable to Reflect the Local Environment
$ReportPath = "C:\Test\Report\"
$LogPath = "C:\Test\Logs\"

$OutputFilename = $ReportPath + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv"
$OutputLogFilename = $LogPath + $ID + "spoInventoryS" + "_dt" + $(get-date -f dd_MM_yyyy_HH_mm_ss) + ".csv"

## Creates a Record of the PowerShell Session to a Text File
#Start-Transcript $logPath

## Get spoSites File
$csvFile = "C:\Test\spoSitesUS1.csv"
$table = Import-Csv $csvFile -Delimiter ";"

## Create an Array to Capture Logs while Executing the Script
$oLogDetailsCollection = New-Object System.Collections.ArrayList

## --------------------------------------------------------------------------------------------------
## If Missing, Load SharePoint PowerShell cmdlets - Requires SharePoint Server 
## --------------------------------------------------------------------------------------------------
#if (!(Get-PsSnapin | Where-Object {$_.Name -match "Microsoft.SharePoint.PowerShell"}))
#{Add-PsSnapin Microsoft.SharePoint.PowerShell}

## Dispose of All Objects in Memory
function Dispose-All 
{
    <#  .DESCRIPTION         Disposes of all memory used.,        .EXAMPLE        Dispose-All    #>
	
Get-Variable -exclude Runspace | Where-Object {$_.Value -is [System.IDisposable] -and $_.Value.GetType().Name -ne "SqlBulkCopy"} | 
		Foreach-Object { $_.Value.Dispose() }
}

## Call a Non-Generic Load Method ??? What is this used for ???
Function Invoke-LoadMethod() {

    param(
            [Microsoft.SharePoint.Client.ClientObject]$Object = $(throw "Please provide a client Object"),
            [string]$PropertyName
        )

   ## Load Context
   $ctx = $Object.Context
   $load = [Microsoft.SharePoint.Client.ClientContext].GetMethod("Load")

   ## Load Type
   $type = $Object.GetType()
   $clientLoad = $load.MakeGenericMethod($type)
   
   ## Parameters
   $Parameter = [System.Linq.Expressions.Expression]::Parameter(($type), $type.Name)
   $Expression = [System.Linq.Expressions.Expression]::Lambda([System.Linq.Expressions.Expression]::Convert([System.Linq.Expressions.Expression]::PropertyOrField($Parameter,$PropertyName),[System.Object] ), $($Parameter))
   $ExpressionArray = [System.Array]::CreateInstance($Expression.GetType(), 1)
   $ExpressionArray.SetValue($Expression, 0)
   
   ## Array
   $clientLoad.Invoke($ctx,@($Object,$ExpressionArray))

}

## !!Function to Get Webs's Permissions from Given URL
Function Get-SPOWebPermission([Microsoft.SharePoint.Client.Web]$web)
{
    ## Get all Immediate Subsites of the Site
    $Ctx.Load($web.Webs) 
    $Ctx.executeQuery()
   
    ## Call the Function to Get Lists of the Web
    Write-host -f Green "`n Getting the Permissions of Web "$web.URL"..."
        "Iterating through Permissions of web in the List:"+ $web.URL| Out-File $OutputFilename -Append

    ## Check if the Web has Unique Permissions (Has Broken Inheritance)
    Invoke-LoadMethod -Object $web -PropertyName "HasUniqueRoleAssignments"
    $Ctx.ExecuteQuery()
  
    ## Get the Web's Permissions
    If($web.HasUniqueRoleAssignments -eq $true)
    {
        Get-Permissions -Object $web -SiteURL $SiteURL -OutputFilename $OutputFilename -oLogDetailsCollection $oLogDetailsCollection 
        #Get-Permissions -Object $web -SiteURL $SiteURL -OutputFilename $CSVPath -oLogDetailsCollection $oLogDetailsCollection 

        $oLogDetailsCollection | Export-Csv -Path $OutputFilename -Force -NoTypeInformation         
    }
  
    ## Scan for Lists with Unique Permissions (Broken Inheritance)
    Write-host -f Green "`t Getting the Permissions of Lists and Libraries in "$Web.URL"..."
        "Iterating through the Permissions of Lists and Libraries in:"+ $web.URL| Out-File $OutputFilename -Append
    Get-SPOListPermission($web)
   
    ## Iterate Through Each Subsite in the Current Web
    Foreach ($Subweb in $web.Webs)
    {
            ## Call the Function Recursively                           
            Get-SPOWebPermission($SubWeb)
    }
}

Get-SPOWebPermission([Microsoft.SharePoint.Client.Web]$web)
