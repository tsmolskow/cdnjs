#Get All SPO Lists
#GetAllSPOLists

#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
Cls

$dt = Get-Date 
$mth = $dt.Month
if($mth -eq 1 -or $mth -eq 2 -or $mth -eq 3 -or $mth -eq 4 -or $mth -eq  5 -or $mth -eq 6 -or $mth -eq 7 -or $mth -eq 8 -or $mth -eq 9)
{
   $mth = "0"+$mth;
}
$dte = $dt.Day.ToString() + $mth.ToString() + $dt.Year.ToString() + $dt.Hour.ToString() + $dt.Minute.ToString() +  $dt.Second.ToString();

Write-Host "date " $dte

#Config Variable
$SiteURL = "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"
$CSVPath = "C:\Test\SiteInventory" + $dte + ".csv"
 
#Setup Credentials to connect
#$Cred = Get-Credential
#$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)

#Setup Credentials to connect
$UserName="P.AUSPORTMIGP.10@ey.com"
$Password = "QReJ+MMvJ+Vnaba1"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $UserName, $SecurePassword
 
#Connect to Site collection
#Connect-PnPOnline -Url $SiteURL -Credentials $Cred
Connect-PnPOnline -Url $SiteURL -Credentials $Cred
 
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Credentials
    
    #Get Lists from the site
    $Web = $Ctx.Web
    $Lists = $Web.Lists
    $Ctx.Load($Web)
    $Ctx.Load($Lists)
    $Ctx.ExecuteQuery()
 
    $ListDataCollection = @()
    #Get List details
    ForEach ($List in $Lists)
    {
        $ListData = New-Object PSObject -Property ([Ordered] @{
        ListName = $List.Title
        #Description = $List.Description
        #ItemCount = $List.ItemCount
        #BaseTemplateID = $List.BaseTemplate
        #Created = $List.Created 
        #BaseType = $List.BaseType
        #ContentTypesEnabled = $List.ContentTypesEnabled
        #Hidden = $List.Hidden
        #ListId = $List.Id
        #IsCatalog = $List.IsCatalog 
        #LastItemDeletedDate = $List.LastItemDeletedDate 
        #LastItemModifiedDate = $List.LastItemModifiedDate 
        #ParentWebUrl = $List.ParentWebUrl 
        #VersioningEnabled = $List.EnableVersioning    
        })
        $ListDataCollection += $ListData
    }
    $ListDataCollection
 
    #Export List data to CSV
    $ListDataCollection | Export-Csv -Path $CSVPath -Force -NoTypeInformation
    Write-host -f Green "List Statistics Exported to CSV!"
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}