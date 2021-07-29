Function HandleMixedModeWebApplication()
{
  param([Parameter(Mandatory=$true)][object]$clientContext)  
  Add-Type -TypeDefinition @"
  using System;
  using Microsoft.SharePoint.Client;
  
  namespace Toth.SPOHelpers
  {
      public static class ClientContextHelper
      {
          public static void AddRequestHandler(ClientContext context)
          {
              context.ExecutingWebRequest += new EventHandler<WebRequestEventArgs>(RequestHandler);
          }
  
          private static void RequestHandler(object sender, WebRequestEventArgs e)
          {
              //Add the header that tells SharePoint to use Windows authentication.
              e.WebRequestExecutor.RequestHeaders.Remove("X-FORMS_BASED_AUTH_ACCEPTED");
              e.WebRequestExecutor.RequestHeaders.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f");
          }
      }
  }
"@ -ReferencedAssemblies "C:\Program Files\WindowsPowerShell\Modules\Microsoft.Online.SharePoint.PowerShell\16.0.20414.12000\Microsoft.SharePoint.Client.dll", "C:\Program Files\WindowsPowerShell\Modules\Microsoft.Online.SharePoint.PowerShell\16.0.20414.12000\Microsoft.SharePoint.Client.Runtime.dll";
  [Toth.SPOHelpers.ClientContextHelper]::AddRequestHandler($clientContext);
}


Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll" 

$userName = "P.AUSPORTMIGP.10@ey.com"
$password = "QReJ+MMvJ+Vnaba1"
$url = "https://eyus.sharepoint.com/sites/eyimdUSA-0001711-MM"

$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$clientContext.Credentials = New-Object System.Net.NetworkCredential($userName, $password, "eyxstaging.net")
$clientContext.AuthenticationMode = [Microsoft.SharePoint.Client.ClientAuthenticationMode]::Default

# Mixed-mode web app handling
HandleMixedModeWebApplication $clientContext;

if (!$clientContext.ServerObjectIsNull.Value)
{
    Write-Host "Connected to site collection..."

    $web = $clientContext.Web
    $clientContext.Load($web)
    $clientContext.ExecuteQuery()

    Write-Host "The site Title is" $web.Title

}
else
{
    Write-Host "Could not create a client context. Check your site url or internet connection."
}