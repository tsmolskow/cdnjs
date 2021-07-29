# https://www.sptrenches.com/2015/04/script-to-get-all-webs-in-sharepoint.html

BEGIN{
function Get-SPOSubWebs{
        Param(
        [Microsoft.SharePoint.Client.ClientContext]$Context,
        [Microsoft.SharePoint.Client.Web]$RootWeb
        )

        cls

        $Webs = $RootWeb.Webs
        $Context.Load($Webs)
        $Context.ExecuteQuery()

        ForEach ($sWeb in $Webs)
        {
            Write-Output $sWeb
            #Get-SPOSubWebs -RootWeb $sWeb -Context $Context
        }
    }
    Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll" | Out-Null
    Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll" | Out-Null
}
PROCESS{

    cls

    $SiteUrl = "https://eyus.sharepoint.com/sites/eyimdUSA-0001677-MM"

    $securePassword = ConvertTo-SecureString $PassWord -AsPlainText -Force
    $spoCred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("P.AUSPORTMIGP.10@ey.com", "QReJ+MMvJ+Vnaba1")
    $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl)
    $ctx.Credentials = $spoCred

    $Web = $ctx.Web
    $ctx.Load($Web)
    $ctx.ExecuteQuery()

    Write-Output "Web: " $Web

    Get-SPOSubWebs -RootWeb $Web -Context $ctx
}